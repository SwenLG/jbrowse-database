from flask import Blueprint, jsonify, request
import psycopg2
from db.db import get_db_connection  # Import the database connection function

routes = Blueprint('routes', __name__)

# ✅ Fetch assemblies
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

# ✅ Fetch distinct categories
@routes.route('/get_categories', methods=['GET'])
def get_categories():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT DISTINCT unnest("category") FROM "Tracks" WHERE "category" IS NOT NULL')
        categories = [row[0] for row in cur.fetchall()]
        cur.close()
        conn.close()
        return jsonify(categories)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    

@routes.route('/insert_assembly', methods=['POST'])
def insert_assembly():
    """Insert an assembly and its corresponding adapter into the database."""
    data = request.get_json()

    if not data:
        return jsonify({"error": "No JSON data received"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # ✅ Insert into Assemblies table
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
        print(f"✅ Inserted Assembly ID: {assembly_id}")

        # ✅ Insert into the correct adapter table
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
            print(f"✅ Inserted IndexedFastaAdapter for Assembly ID: {assembly_id}")

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
            print(f"✅ Inserted BgzipFastaAdapter for Assembly ID: {assembly_id}")

        # ✅ Insert displays
        for display in data['displays']:
            display_id = f"{data['sequence']['trackId']}-{display['type']}"  # 🔹 Format: sequence_trackId-displayType

            cur.execute("""
                INSERT INTO "Displays" ("displayId", "parentId", "parentType", "type")
                VALUES (%s, %s, 'Track', %s)
            """, (
                display_id,
                assembly_id,
                display["type"],
            ))
            print(f"✅ Inserted Display: {display['type']} with ID {display_id}")


        conn.commit()
        cur.close()
        conn.close()

        return jsonify({"success": True, "assembly_id": assembly_id})

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

