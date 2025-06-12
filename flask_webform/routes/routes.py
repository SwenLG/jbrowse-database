from flask import Blueprint, jsonify, request
import psycopg2
import json
import os
import subprocess
from db.db import get_db_connection  # Import the database connection function

routes = Blueprint('routes', __name__)


@routes.route('/validate_path', methods=['POST'])
def validate_path():
    data = request.get_json()
    path = data.get("path", "").strip()
    category = data.get("category", "").strip().lower()  # NEW: Optional category input from frontend

    if not path:
        return jsonify({"valid": False, "error": "No path provided"})

    # 🔹 Normalize path
    if path.startswith("mnt/data/"):
        path = "/mnt/data/" + path[len("mnt/data/"):]
    elif path.startswith("/mnt/data/"):
        path = path  # already correct
    elif path.startswith("data/"):
        path = "/mnt/" + path  # becomes /mnt/data/...
    elif not path.startswith("/"):
        path = "/mnt/data/" + path  # fallback

    print(f"[VALIDATE] Checking path: {path}")
    exists = os.path.isfile(path)

    # 🔹 Determine file type by extension
    def path_type(p):
        lowered = p.lower()
        if lowered.endswith((".fa", ".fasta", ".fa.gz", ".fasta.gz")):
            return "assembly"
        elif lowered.endswith((".vcf", ".vcf.gz", ".bam", ".cram", ".gff", ".gff3", ".gff.gz", ".bed", ".bed.gz", ".delta", ".paf")):
            return "track"
        return "unknown"

    inferred_type = path_type(path)

    is_type_match = True  # default
    if category in {"assembly", "track"}:
        is_type_match = (
            (inferred_type == "assembly" and category == "assembly") or
            (inferred_type == "track" and category == "track")
        )

    return jsonify({
        "valid": exists,
        "typeMatch": is_type_match,
        "inferred": inferred_type
    })




# Fetch assemblies
@routes.route('/get_assemblies', methods=['GET'])
def get_assemblies():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT name FROM "Assemblies";')  
        assemblies = [row[0] for row in cur.fetchall()]
        cur.close()
        conn.close()
        return jsonify(assemblies)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@routes.route('/get_categories', methods=['GET'])
def get_categories():
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # Fetch full category arrays, one per track
        cur.execute('SELECT "category" FROM "Tracks" WHERE "category" IS NOT NULL')
        raw_rows = cur.fetchall()

        # Convert each list of categories into a tuple key (to preserve hierarchy)
        category_paths = set()
        for row in raw_rows:
            path = tuple(row[0])  # row[0] is the category array
            if path:
                category_paths.add(path)

        # Convert back to list of lists for JSON response
        paths = [list(p) for p in sorted(category_paths)]

        cur.close()
        conn.close()
        return jsonify(paths)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    

@routes.route('/insert_assembly', methods=['POST'])
def insert_assembly():
    """Insert an assembly and its corresponding adapter into the database."""
    data = request.get_json()
    default_display = data.get("default_display")
    
    if not data:
        return jsonify({"error": "No JSON data received"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()


        # Check for duplicate fasta file in both adapter tables
        fasta_uri = data['sequence']['adapter'].get('fastaLocation', {}).get('uri')

        # Check IndexedFastaAdapter
        cur.execute('SELECT 1 FROM "IndexedFastaAdapter" WHERE "fastaLocation" = %s', (fasta_uri,))
        if cur.fetchone():
            return jsonify({"error": f"An assembly with fastaLocation: '{fasta_uri}' already exists."}), 400

        # Check BgzipFastaAdapter
        cur.execute('SELECT 1 FROM "BgzipFastaAdapter" WHERE "fastaLocation" = %s', (fasta_uri,))
        if cur.fetchone():
            return jsonify({"error": f"An assembly with fastaLocation: '{fasta_uri}' already exists."}), 400


        # Insert into Assemblies table
        cur.execute("""
            INSERT INTO "Assemblies" ("name", "displayName", "aliases", "sequence_trackId", "sequence_type", "adapterType")
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            data['name'],
            data['displayName'],
            data.get('aliases', []),
            data['sequence']['trackId'],
            data['sequence']['type'],
            data['sequence']['adapter']['type']
        ))

        assembly_id = cur.fetchone()[0]
        print(f" Inserted Assembly ID: {assembly_id}")

        # Insert into the correct adapter table
        adapter = data['sequence']['adapter']
        if adapter['type'] == 'IndexedFastaAdapter':
            cur.execute("""
                INSERT INTO "IndexedFastaAdapter" ("fastaLocation", "faiLocation", "metadataLocation", "assemblyId")
                VALUES (%s, %s, %s, %s)
            """, (
                adapter.get('fastaLocation', {}).get('uri'),
                adapter.get('faiLocation', {}).get('uri'),
                adapter.get('metadataLocation', {}).get('uri'),
                assembly_id
            ))
            print(f" Inserted IndexedFastaAdapter for Assembly ID: {assembly_id}")

        elif adapter['type'] == 'BgzipFastaAdapter':
            cur.execute("""
                INSERT INTO "BgzipFastaAdapter" ("fastaLocation", "faiLocation", "gziLocation", "metadataLocation", "assemblyId")
                VALUES (%s, %s, %s, %s, %s)
            """, (
                adapter.get('fastaLocation', {}).get('uri'),
                adapter.get('faiLocation', {}).get('uri'),
                adapter.get('gziLocation', {}).get('uri'),
                adapter.get('metadataLocation', {}).get('uri'),
                assembly_id
            ))
            print(f" Inserted BgzipFastaAdapter for Assembly ID: {assembly_id}")

        default_display = data.get("default_display")
        if default_display:
            default = next((d for d in data["displays"] if d["type"] == default_display), None)
            others = [d for d in data["displays"] if d["type"] != default_display]
            if default:
                data["displays"] = [default] + others


        # Insert displays
        for display in data['displays']:
            display_id = f"{data['sequence']['trackId']}-{display['type']}"  # 🔹 Format: sequence_trackId-displayType

            cur.execute("""
                INSERT INTO "Displays" ("displayId", "parentId", "parentType", "type")
                VALUES (%s, %s, 'Assembly', %s)
            """, (
                display_id,
                assembly_id,
                display["type"],
            ))
            print(f" Inserted Display: {display['type']} with ID {display_id}")


        conn.commit()
        cur.close()
        conn.close()

        # Trigger config update with the newly inserted assembly name
        try:
            print("🚀 Running update_config_assemblies.py")
            subprocess.run(
                ["python3", "/scripts/update_config_assemblies.py", data['name']],
                check=True
            )
            print(f" Synced assembly '{data['name']}' to config.")
        except subprocess.CalledProcessError as e:
            print(f" Failed to sync assembly to config: {e}")

        return jsonify({"success": True, "assembly_id": assembly_id})

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    
@routes.route('/insert_vcf', methods=['POST'])
def insert_vcf():
    """Insert a VCF track into the database."""
    data = request.get_json()
    default_display = data.get("default_display")
    print("\n Received payload for /insert_vcf:")

    if not data:
        return jsonify({"error": "No JSON data received"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        vcf_uri = data['adapter']['vcfGzLocation']['uri']
        cur.execute('SELECT 1 FROM "VcfTabixAdapter" WHERE "vcfGzLocation" = %s', (vcf_uri,))
        if cur.fetchone():
            return jsonify({"error": f"VCF file '{vcf_uri}' already exists."}), 400

        # Insert into Tracks table
        cur.execute("""
            INSERT INTO "Tracks" ("trackId", "type", "name", "assemblyNames", "category", "adapterType")
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            data['trackId'],
            data['type'],
            data['name'],
            data.get('assemblyNames', []),
            data.get('category', []),
            data['adapter']['type']
        ))

        track_id = cur.fetchone()[0]
        print(f" Inserted VCF Track ID: {track_id}")

        # Insert into VcfTabixAdapter
        adapter = data['adapter']
        cur.execute("""
            INSERT INTO "VcfTabixAdapter" ("trackId", "vcfGzLocation", "indexLocation")
            VALUES (%s, %s, %s)
        """, (
            track_id,
            adapter.get('vcfGzLocation', {}).get('uri'),
            adapter.get('indexLocation', {}).get('uri')
        ))
        print(f" Inserted VcfTabixAdapter for Track ID: {track_id}")

        print(json.dumps(data, indent=2))  # ⬅️ Match insert_delta

        default_display = data.get("default_display")
        if default_display:
            default = next((d for d in data["displays"] if d["type"] == default_display), None)
            others = [d for d in data["displays"] if d["type"] != default_display]
            if default:
                data["displays"] = [default] + others



        # Insert displays
        for display in data['displays']:
            display_id = f"{data['trackId']}-{display['type']}"  # 🔹 Format: trackId-displayType

            cur.execute("""
                INSERT INTO "Displays" ("displayId", "parentId", "parentType", "type")
                VALUES (%s, %s, 'Track', %s)
            """, (
                display_id,
                track_id,
                display["type"],
            ))
            print(f" Inserted Display: {display['type']} with ID {display_id}")

        conn.commit()

        # Trigger config update with the newly inserted track ID
        try:
            print("🚀 Running update_config_tracks.py")
            subprocess.run(
                ["python3", "/scripts/update_config_tracks.py", data['trackId']],
                check=True
            )
            print(f" Synced track '{data['trackId']}' to config.")
        except subprocess.CalledProcessError as e:
            print(f" Failed to sync track to config: {e}")

        cur.close()
        conn.close()


        return jsonify({"success": True, "track_id": track_id})

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    
@routes.route('/get_sequence_adapter_id', methods=['GET'])
def get_sequence_adapter_id():
    """Retrieve the sequence adapter ID and type for a given assembly name."""
    assembly_name = request.args.get('assembly')

    if not assembly_name:
        return jsonify({"error": "No assembly name provided"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # 🔹 Check which adapter type the assembly has (IndexedFasta or BgzipFasta)
        cur.execute("""
            SELECT "adapterType", "Id"
            FROM "Assemblies"
            WHERE "name" = %s
        """, (assembly_name,))
        
        result = cur.fetchone()
        
        if not result:
            return jsonify({"error": f"No assembly found with name {assembly_name}"}), 404

        adapter_type, assembly_id = result

        # 🔹 Determine the correct adapter table
        adapter_table = "BgzipFastaAdapter" if adapter_type == "BgzipFastaAdapter" else "IndexedFastaAdapter"

        # 🔹 Fetch the adapter ID from the correct table
        cur.execute(f"""
            SELECT "Id"
            FROM "{adapter_table}"
            WHERE "assemblyId" = %s
        """, (assembly_id,))
        
        adapter_result = cur.fetchone()

        cur.close()
        conn.close()

        if not adapter_result:
            return jsonify({"error": f"No {adapter_type} found for assembly {assembly_name}"}), 404

        return jsonify({
            "sequenceAdapterId": adapter_result[0],
            "sequenceAdapterType": adapter_type
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@routes.route('/insert_bam', methods=['POST'])
def insert_bam():
    """Insert a BAM track into the database."""
    data = request.get_json()
    default_display = data.get('default_display')


    if not data:
        return jsonify({"error": "No JSON data received"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        bam_uri = data['adapter']['bamLocation']['uri']
        cur.execute('SELECT 1 FROM "BamAdapter" WHERE "bamLocation" = %s', (bam_uri,))
        if cur.fetchone():
            return jsonify({"error": f"BAM file '{bam_uri}' already exists."}), 400

        # Insert into Tracks table
        cur.execute("""
            INSERT INTO "Tracks" ("trackId", "type", "name", "assemblyNames", "category", "adapterType")
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            data['trackId'],
            data['type'],
            data['name'],
            data.get('assemblyNames', []),
            data.get('category', []),
            data['adapter']['type']
        ))

        track_id = cur.fetchone()[0]
        print(f" Inserted BAM Track ID: {track_id}")

        # Insert into BamAdapter table
        cur.execute("""
            INSERT INTO "BamAdapter" ("trackId", "bamLocation", "indexLocation", "sequenceAdapterId", "sequenceAdapterType")
            VALUES (%s, %s, %s, %s, %s)
        """, (
            track_id,
            data['adapter']['bamLocation']['uri'],
            data['adapter']['indexLocation']['uri'],
            data['adapter']['sequenceAdapterId'],  # Retrieved from DB
            data['adapter']['sequenceAdapterType']  # Retrieved from DB
        ))
        print(f" Inserted BamAdapter for Track ID: {track_id}")


        if default_display:
            default = next((d for d in data['displays'] if d['type'] == default_display), None)
            others = [d for d in data['displays'] if d['type'] != default_display]
            if default:
                data['displays'] = [default] + others


        # Insert displays
        for display in data['displays']:
            display_id = f"{data['trackId']}-{display['type']}"  # 🔹 Format: trackId-displayType
            cur.execute("""
                INSERT INTO "Displays" ("displayId", "parentId", "parentType", "type")
                VALUES (%s, %s, 'Track', %s)
            """, (
                display_id,
                track_id,
                display["type"],
            ))
            print(f" Inserted Display: {display['type']}")

        conn.commit()

        # Trigger config update with the newly inserted track ID
        try:
            print("🚀 Running update_config_tracks.py")
            subprocess.run(
                ["python3", "/scripts/update_config_tracks.py", data['trackId']],
                check=True
            )
            print(f" Synced track '{data['trackId']}' to config.")
        except subprocess.CalledProcessError as e:
            print(f" Failed to sync track to config: {e}")

        cur.close()
        conn.close()

        return jsonify({"success": True, "track_id": track_id})

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    

@routes.route('/insert_cram', methods=['POST'])
def insert_cram():
    """Insert a CRAM track into the database."""
    data = request.get_json()
    default_display = data.get("default_display")


    if not data:
        return jsonify({"error": "No JSON data received"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cram_uri = data['adapter']['cramLocation']['uri']
        cur.execute('SELECT 1 FROM "CramAdapter" WHERE "cramLocation" = %s', (cram_uri,))
        if cur.fetchone():
            return jsonify({"error": f"CRAM file '{cram_uri}' already exists."}), 400

        # Insert into Tracks table
        cur.execute("""
            INSERT INTO "Tracks" ("trackId", "type", "name", "assemblyNames", "category", "adapterType")
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            data['trackId'],
            data['type'],
            data['name'],
            data.get('assemblyNames', []),
            data.get('category', []),
            data['adapter']['type']
        ))

        track_id = cur.fetchone()[0]
        print(f" Inserted CRAM Track ID: {track_id}")

        # Insert into CramAdapter table
        adapter = data['adapter']
        cur.execute("""
            INSERT INTO "CramAdapter" ("trackId", "cramLocation", "craiLocation", "sequenceAdapterId", "sequenceAdapterType")
            VALUES (%s, %s, %s, %s, %s)
        """, (
            track_id,
            adapter.get('cramLocation', {}).get('uri'),
            adapter.get('craiLocation', {}).get('uri'),
            adapter.get('sequenceAdapterId'),
            adapter.get('sequenceAdapterType')
        ))

        print(f" Inserted CramAdapter for Track ID: {track_id}")

        if default_display:
            default = next((d for d in data['displays'] if d['type'] == default_display), None)
            others = [d for d in data['displays'] if d['type'] != default_display]
            if default:
                data['displays'] = [default] + others


        # Insert displays
        for display in data['displays']:
            display_id = f"{data['trackId']}-{display['type']}"  # 🔹 Format: trackId-displayType
            cur.execute("""
                INSERT INTO "Displays" ("displayId", "parentId", "parentType", "type")
                VALUES (%s, %s, 'Track', %s)
            """, (
                display_id,
                track_id,
                display["type"]
            ))
            print(f" Inserted Display: {display['type']}")

        conn.commit()

        # Trigger config update with the newly inserted track ID
        try:
            print("🚀 Running update_config_tracks.py")
            subprocess.run(
                ["python3", "/scripts/update_config_tracks.py", data['trackId']],
                check=True
            )
            print(f" Synced track '{data['trackId']}' to config.")
        except subprocess.CalledProcessError as e:
            print(f" Failed to sync track to config: {e}")

        cur.close()
        conn.close()

        return jsonify({"success": True, "track_id": track_id})

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500


@routes.route('/insert_bed', methods=['POST'])
def insert_bed():
    """Insert a BED track into the database."""
    data = request.get_json()
    default_display = data.get("default_display")


    if not data:
        return jsonify({"error": "No JSON data received"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        bed_uri = data['adapter']['bedGzLocation']['uri']
        cur.execute('SELECT 1 FROM "BedTabixAdapter" WHERE "bedGzLocation" = %s', (bed_uri,))
        if cur.fetchone():
            return jsonify({"error": f"BED file '{bed_uri}' already exists."}), 400

        # Insert into Tracks table
        cur.execute("""
            INSERT INTO "Tracks" ("trackId", "type", "name", "assemblyNames", "category", "adapterType")
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            data['trackId'],
            data['type'],
            data['name'],
            data.get('assemblyNames', []),
            data.get('category', []),
            data['adapter']['type']
        ))

        track_id = cur.fetchone()[0]
        print(f" Inserted BED Track ID: {track_id}")

        # Insert into BedTabixAdapter table
        adapter = data['adapter']
        cur.execute("""
            INSERT INTO "BedTabixAdapter" ("trackId", "bedGzLocation", "indexLocation")
            VALUES (%s, %s, %s)
        """, (
            track_id,
            adapter.get('bedGzLocation', {}).get('uri'),
            adapter.get('indexLocation', {}).get('uri')
        ))
        print(f" Inserted BedTabixAdapter for Track ID: {track_id}")


        if default_display:
            default = next((d for d in data["displays"] if d["type"] == default_display), None)
            others = [d for d in data["displays"] if d["type"] != default_display]
            if default:
                data["displays"] = [default] + others


        # Insert displays
        for display in data['displays']:
            display_id = f"{data['trackId']}-{display['type']}"  # 🔹 Format: trackId-displayType
            cur.execute("""
                INSERT INTO "Displays" ("displayId", "parentId", "parentType", "type")
                VALUES (%s, %s, 'Track', %s)
            """, (
                display_id,
                track_id,
                display["type"],
            ))
            print(f" Inserted Display: {display['type']}")

        conn.commit()

        # Trigger config update with the newly inserted track ID
        try:
            print("🚀 Running update_config_tracks.py")
            subprocess.run(
                ["python3", "/scripts/update_config_tracks.py", data['trackId']],
                check=True
            )
            print(f" Synced track '{data['trackId']}' to config.")
        except subprocess.CalledProcessError as e:
            print(f" Failed to sync track to config: {e}")

        cur.close()
        conn.close()

        return jsonify({"success": True, "track_id": track_id})

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    

@routes.route('/insert_paf', methods=['POST'])
def insert_paf():
    """Insert a PAF track into the database."""
    data = request.get_json()
    default_display = data.get("default_display")

    if not data:
        return jsonify({"error": "No JSON data received"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        paf_uri = data['adapter']['pafLocation']['uri']
        cur.execute('SELECT 1 FROM "PAFAdapter" WHERE "pafLocation" = %s', (paf_uri,))
        if cur.fetchone():
            return jsonify({"error": f"PAF file '{paf_uri}' already exists."}), 400

        # Insert into Tracks table
        cur.execute("""
            INSERT INTO "Tracks" ("trackId", "type", "name", "assemblyNames", "category", "adapterType")
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            data['trackId'],
            data['type'],
            data['name'],
            data.get('assemblyNames', []),  # Convert to JSON
            data.get('category', []),  # Convert to JSON
            data['adapter']['type']
        ))


        track_id = cur.fetchone()[0]
        print(f" Inserted PAF Track ID: {track_id}")

        # Insert into PAFAdapter table
        adapter = data['adapter']
        cur.execute("""
            INSERT INTO "PAFAdapter" ("trackId", "pafLocation", "assemblyNames")
            VALUES (%s, %s, %s)
        """, (
            track_id,
            adapter.get('pafLocation', {}).get('uri'),
            data.get('assemblyNames', [])
        ))
        print(f" Inserted PAFAdapter for Track ID: {track_id}")

        if default_display:
            default = next((d for d in data["displays"] if d["type"] == default_display), None)
            others = [d for d in data["displays"] if d["type"] != default_display]
            if default:
                data["displays"] = [default] + others


        # Insert displays
        for display in data['displays']:
            display_id = f"{data['trackId']}-{display['type']}"  # 🔹 Format: trackId-displayType
            cur.execute("""
                INSERT INTO "Displays" ("displayId", "parentId", "parentType", "type")
                VALUES (%s, %s, 'Track', %s)
            """, (
                display_id,
                track_id,
                display["type"],
            ))
            print(f" Inserted Display: {display['type']}")

        conn.commit()

        # Trigger config update with the newly inserted track ID
        try:
            print("🚀 Running update_config_tracks.py")
            subprocess.run(
                ["python3", "/scripts/update_config_tracks.py", data['trackId']],
                check=True
            )
            print(f" Synced track '{data['trackId']}' to config.")
        except subprocess.CalledProcessError as e:
            print(f" Failed to sync track to config: {e}")

        cur.close()
        conn.close()

        return jsonify({"success": True, "track_id": track_id})

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    

@routes.route('/insert_delta', methods=['POST'])
def insert_delta():
    """Insert a Delta track into the database."""
    data = request.get_json()
    default_display = data.get("default_display")

    if not data:
        return jsonify({"error": "No JSON data received"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        delta_uri = data['adapter']['deltaLocation']['uri']
        cur.execute('SELECT 1 FROM "DeltaAdapter" WHERE "deltaLocation" = %s', (delta_uri,))
        if cur.fetchone():
            return jsonify({"error": f"Delta file '{delta_uri}' already exists."}), 400

        # Insert into Tracks table
        cur.execute("""
            INSERT INTO "Tracks" ("trackId", "type", "name", "assemblyNames", "category", "adapterType")
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            data['trackId'],
            data['type'],
            data['name'],
            data.get('assemblyNames', []),
            data.get('category', []),
            data['adapter']['type']
        ))

        track_id = cur.fetchone()[0]
        print(f"Inserted Delta Track ID: {track_id}")

        # Insert into DeltaAdapter table
        adapter = data['adapter']
        cur.execute("""
            INSERT INTO "DeltaAdapter" ("trackId", "deltaLocation", "assemblyNames")
            VALUES (%s, %s, %s)
        """, (
            track_id,
            adapter.get('deltaLocation', {}).get('uri'),
            data.get('assemblyNames', [])
        ))
        print(f"Inserted DeltaAdapter for Track ID: {track_id}")

        print(json.dumps(data, indent=2))

        # Reorder displays so the default is first
        default_display = data.get('default_display')
        if default_display:
            default = next((d for d in data['displays'] if d['type'] == default_display), None)
            others = [d for d in data['displays'] if d['type'] != default_display]
            if default:
                data['displays'] = [default] + others

        # Insert displays
        for display in data['displays']:
            display_id = f"{data['trackId']}-{display['type']}"
            cur.execute("""
                INSERT INTO "Displays" ("displayId", "parentId", "parentType", "type")
                VALUES (%s, %s, 'Track', %s)
            """, (
                display_id,
                track_id,
                display["type"]
            ))
            print(f"Inserted Display: {display['type']}")

        conn.commit()

        # Trigger config update with the newly inserted track ID
        try:
            print("🚀 Running update_config_tracks.py")
            subprocess.run(
                ["python3", "/scripts/update_config_tracks.py", data['trackId']],
                check=True
            )
            print(f" Synced track '{data['trackId']}' to config.")
        except subprocess.CalledProcessError as e:
            print(f" Failed to sync track to config: {e}")

        cur.close()
        conn.close()

        return jsonify({"success": True, "track_id": track_id})

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    

@routes.route('/insert_gff', methods=['POST'])
def insert_gff():
    """Insert a GFF track into the database."""
    data = request.get_json()
    default_display = data.get("default_display")


    if not data:
        return jsonify({"error": "No JSON data received"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        gff_uri = data['adapter']['gffGzLocation']['uri']
        cur.execute('SELECT 1 FROM "Gff3TabixAdapter" WHERE "gffGzLocation" = %s', (gff_uri,))
        if cur.fetchone():
            return jsonify({"error": f"GFF file '{gff_uri}' already exists."}), 400

        # Insert into Tracks table
        cur.execute("""
            INSERT INTO "Tracks" ("trackId", "type", "name", "assemblyNames", "category", "adapterType")
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            data['trackId'],
            data['type'],
            data['name'],
            data.get('assemblyNames', []),
            data.get('category', []),
            data['adapter']['type']
        ))

        track_id = cur.fetchone()[0]
        print(f"Inserted GFF Track ID: {track_id}")

        # Insert into Gff3TabixAdapter table
        adapter = data['adapter']
        cur.execute("""
            INSERT INTO "Gff3TabixAdapter" ("trackId", "gffGzLocation", "indexLocation")
            VALUES (%s, %s, %s)
        """, (
            track_id,
            adapter.get('gffGzLocation', {}).get('uri'),
            adapter.get('indexLocation', {}).get('uri')
        ))
        print(f"Inserted GFF Adapter for Track ID: {track_id}")

        if default_display:
            default = next((d for d in data["displays"] if d["type"] == default_display), None)
            others = [d for d in data["displays"] if d["type"] != default_display]
            if default:
                data["displays"] = [default] + others

        # Insert displays
        for display in data['displays']:
            display_id = f"{data['trackId']}-{display['type']}"
            cur.execute("""
                INSERT INTO "Displays" ("displayId", "parentId", "parentType", "type")
                VALUES (%s, %s, 'Track', %s)
            """, (
                display_id,
                track_id,
                display["type"]
            ))
            print(f"Inserted Display: {display['type']}")

        conn.commit()

        # Trigger config update with the newly inserted track ID
        try:
            print("🚀 Running update_config_tracks.py")
            subprocess.run(
                ["python3", "/scripts/update_config_tracks.py", data['trackId']],
                check=True
            )
            print(f" Synced track '{data['trackId']}' to config.")
        except subprocess.CalledProcessError as e:
            print(f" Failed to sync track to config: {e}")

        cur.close()
        conn.close()

        return jsonify({"success": True, "track_id": track_id})

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500






