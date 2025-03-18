import json
import psycopg2
import os

# Database connection information
DB_CONFIG = {
    'dbname': 'jbrowse_config',
    'user': 'swen',
    'password': 'cremers',
    'host': 'localhost',
    'port': 5432
}

def connect_db():
    """Establish a database connection."""
    return psycopg2.connect(**DB_CONFIG)

def get_sequence_adapter_id(sequence_adapter_type, assembly_name, cursor):
    """Retrieve the sequence adapter ID for a given type and assembly name."""
    adapter_table = "BgzipFastaAdapter" if sequence_adapter_type == "BgzipFastaAdapter" else "IndexedFastaAdapter"
    cursor.execute(f"""
        SELECT a."Id"
        FROM "{adapter_table}" a
        JOIN "Assemblies" asm ON a."assemblyId" = asm."Id"
        WHERE asm."name" = %s
    """, (assembly_name,))
    result = cursor.fetchone()
    if result:
        return result[0]
    else:
        print(f"No {sequence_adapter_type} found for assembly: {assembly_name}")
        return None


def insert_bam_adapter(adapter_data, track_id, cursor):
    """Insert BamAdapter data into the database."""
    # Extract bamLocation and index.location
    bam_location = adapter_data.get('bamLocation', {}).get('uri')
    index_location = adapter_data.get('index', {}).get('location', {}).get('uri')
    sequence_adapter = adapter_data.get('sequenceAdapter')

    # Validate assemblyNames
    assembly_names = adapter_data.get('assemblyNames')
    if not assembly_names or not isinstance(assembly_names, list) or not assembly_names[0]:
        raise ValueError(f"Missing or invalid assemblyNames in adapterData for track ID: {track_id}")

    if sequence_adapter:
        sequence_adapter_type = sequence_adapter['type']
        sequence_adapter_id = get_sequence_adapter_id(sequence_adapter['type'], assembly_names[0], cursor)
        if not sequence_adapter_id:
            print(f"Failed to find sequence adapter for BamAdapter in assembly: {assembly_names[0]}")
            return

        # Insert BamAdapter
        cursor.execute("""
            INSERT INTO "BamAdapter" ("trackId", "bamLocation", "indexLocation", "sequenceAdapterId", "sequenceAdapterType")
            VALUES (%s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            track_id,
            bam_location,
            index_location,
            sequence_adapter_id,
            sequence_adapter_type
        ))
        bam_adapter_id = cursor.fetchone()[0]
        print(f"Inserted BamAdapter ID: {bam_adapter_id}")
        return bam_adapter_id
    else:
        print("No sequenceAdapter provided for BamAdapter.")
        return None
    
def insert_cram_adapter(adapter_data, track_id, cursor):
    """Insert CramAdapter data into the database."""
    # Extract cramLocation and craiLocation
    cram_location = adapter_data.get('cramLocation', {}).get('uri')
    crai_location = adapter_data.get('craiLocation', {}).get('uri')
    sequence_adapter = adapter_data.get('sequenceAdapter')

    # Validate assemblyNames
    assembly_names = adapter_data.get('assemblyNames')
    if not assembly_names or not isinstance(assembly_names, list) or not assembly_names[0]:
        raise ValueError(f"Missing or invalid assemblyNames in adapterData for track ID: {track_id}")

    if sequence_adapter:
        sequence_adapter_type = sequence_adapter['type']
        sequence_adapter_id = get_sequence_adapter_id(sequence_adapter['type'], assembly_names[0], cursor)
        if not sequence_adapter_id:
            print(f"Failed to find sequence adapter for CramAdapter in assembly: {assembly_names[0]}")
            return

        # Insert CramAdapter
        cursor.execute("""
            INSERT INTO "CramAdapter" ("trackId", "cramLocation", "craiLocation", "sequenceAdapterId", "sequenceAdapterType")
            VALUES (%s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            track_id,
            cram_location,
            crai_location,  # Correctly referencing craiLocation
            sequence_adapter_id,
            sequence_adapter_type
        ))
        cram_adapter_id = cursor.fetchone()[0]
        print(f"Inserted CramAdapter ID: {cram_adapter_id}")
        return cram_adapter_id
    else:
        print("No sequenceAdapter provided for CramAdapter.")
        return None



def insert_gff3_tabix_adapter(adapter_data, track_id, cursor):
    """Insert Gff3TabixAdapter data into the database."""
    # Extract gffGzLocation and index.location
    gffGzLocation = adapter_data.get('gffGzLocation', {}).get('uri')
    index_location = adapter_data.get('index', {}).get('location', {}).get('uri')

    # Insert into the database
    cursor.execute("""
        INSERT INTO "Gff3TabixAdapter" ("trackId", "gffGzLocation", "indexLocation")
        VALUES (%s, %s, %s)
        RETURNING "Id"
    """, (
        track_id,
        gffGzLocation,
        index_location
    ))
    adapter_id = cursor.fetchone()[0]
    print(f"Inserted Gff3TabixAdapter ID: {adapter_id}")
    return adapter_id

def insert_bed_tabix_adapter(adapter_data, track_id, cursor):
    """Insert BedTabixAdapter data into the database."""
    # Extract bedGzLocation and index.location
    bed_gz_location = adapter_data.get('bedGzLocation', {}).get('uri')
    index_location = adapter_data.get('index', {}).get('location', {}).get('uri')

    # Insert into the database
    cursor.execute("""
        INSERT INTO "BedTabixAdapter" ("trackId", "bedGzLocation", "indexLocation")
        VALUES (%s, %s, %s)
        RETURNING "Id"
    """, (
        track_id,
        bed_gz_location,
        index_location
    ))
    adapter_id = cursor.fetchone()[0]
    print(f"Inserted BedTabixAdapter ID: {adapter_id}")
    return adapter_id

def insert_vcf_tabix_adapter(adapter_data, track_id, cursor):
    """Insert VcfTabixAdapter data into the database."""
    # Extract vcfGzLocation and index.location
    vcf_gz_location = adapter_data.get('vcfGzLocation', {}).get('uri')
    index_location = adapter_data.get('index', {}).get('location', {}).get('uri')

    # Insert into the database
    cursor.execute("""
        INSERT INTO "VcfTabixAdapter" ("trackId", "vcfGzLocation", "indexLocation")
        VALUES (%s, %s, %s)
        RETURNING "Id"
    """, (
        track_id,
        vcf_gz_location,
        index_location
    ))
    adapter_id = cursor.fetchone()[0]
    print(f"Inserted VcfTabixAdapter ID: {adapter_id}")
    return adapter_id

def insert_paf_adapter(adapter_data, track_id, cursor):
    """Insert PAFAdapter data into the database."""
    # Extract pafLocation and assemblyNames
    paf_location = adapter_data.get('pafLocation', {}).get('uri')
    assembly_names = adapter_data.get('assemblyNames')

    # Validate assemblyNames
    if not assembly_names or not isinstance(assembly_names, list) or len(assembly_names) < 2:
        raise ValueError(f"PAFAdapter requires at least two assemblyNames for track ID: {track_id}")

    # Insert PAFAdapter
    cursor.execute("""
        INSERT INTO "PAFAdapter" ("trackId", "pafLocation", "assemblyNames")
        VALUES (%s, %s, %s)
        RETURNING "Id"
    """, (
        track_id,
        paf_location,
        assembly_names
    ))
    paf_adapter_id = cursor.fetchone()[0]
    print(f"Inserted PAFAdapter ID: {paf_adapter_id}")
    return paf_adapter_id

def insert_delta_adapter(adapter_data, track_id, cursor):
    """Insert DeltaAdapter data into the database."""
    # Extract deltaLocation and assemblyNames
    delta_location = adapter_data.get('deltaLocation', {}).get('uri')
    assembly_names = adapter_data.get('assemblyNames')

    # Validate assemblyNames
    if not assembly_names or not isinstance(assembly_names, list) or len(assembly_names) < 2:
        raise ValueError(f"DeltaAdapter requires at least two assemblyNames for track ID: {track_id}")

    # Insert DeltaAdapter
    cursor.execute("""
        INSERT INTO "DeltaAdapter" ("trackId", "deltaLocation", "assemblyNames")
        VALUES (%s, %s, %s)
        RETURNING "Id"
    """, (
        track_id,
        delta_location,
        assembly_names
    ))
    delta_adapter_id = cursor.fetchone()[0]
    print(f"Inserted DeltaAdapter ID: {delta_adapter_id}")
    return delta_adapter_id



def insert_displays(displays, track_id, cursor):
    """Insert displays for a track."""
    for display in displays:
        cursor.execute("""
            INSERT INTO "Displays" ("displayId", "parentId", "parentType", "type")
            VALUES (%s, %s, 'Track', %s)
            RETURNING "Id"
        """, (
            display['displayId'],
            track_id,
            display['type']
        ))
        display_id = cursor.fetchone()[0]

        # Insert the renderer(s) if they exist
        if 'renderer' in display:  # Single renderer case
            insert_renderer(display['renderer'], display_id, cursor)
        elif 'renderers' in display:  # Nested renderers case
            for renderer_key, renderer_data in display['renderers'].items():
                # Pass only renderer data without adding "key" to rendererDetails
                insert_renderer(renderer_data, display_id, cursor, renderer_key=renderer_key)


def insert_renderer(renderer, display_id, cursor, renderer_key="renderer"):
    """Insert renderer data into the Renderer table."""
    renderer_type = renderer.get("type")
    # Remove the 'key' if it's accidentally included in renderer data
    renderer_details = renderer.copy()
    renderer_details.pop("key", None)
    renderer_json = json.dumps(renderer_details)  # Convert cleaned renderer data to JSON

    cursor.execute("""
        INSERT INTO "Renderer" ("DisplaysId", "rendererKey", "type", "rendererDetails")
        VALUES (%s, %s, %s, %s)
        RETURNING "id"
    """, (
        display_id,
        renderer_key,
        renderer_type,
        renderer_json
    ))
    renderer_id = cursor.fetchone()[0]
    print(f"Inserted Renderer with ID: {renderer_id} for Display ID: {display_id}")


def insert_tracks(data, cursor):
    """Insert track data into the database."""
    for track in data:
        cursor.execute("""
            INSERT INTO "Tracks" ("trackId", "type", "name", "assemblyNames", "category", "adapterType")
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            track['trackId'],
            track['type'],
            track['name'],
            track.get('assemblyNames', []),
            track.get('category', []),
            track['adapter']['type']
        ))
        track_id = cursor.fetchone()[0]
        print(f"Inserted Track ID: {track_id}")

        # Insert the adapter
        adapter_type = track['adapter']['type']
        if adapter_type == 'Gff3TabixAdapter':
            insert_gff3_tabix_adapter(track['adapter'], track_id, cursor)
        elif adapter_type == 'BamAdapter':
            # Ensure assemblyNames are passed to BamAdapter
            track['adapter']['assemblyNames'] = track['assemblyNames']
            insert_bam_adapter(track['adapter'], track_id, cursor)
        elif adapter_type == 'BedTabixAdapter':
            insert_bed_tabix_adapter(track['adapter'], track_id, cursor)
        elif adapter_type == 'VcfTabixAdapter':
            insert_vcf_tabix_adapter(track['adapter'], track_id, cursor)
        elif adapter_type == 'CramAdapter':
            track['adapter']['assemblyNames'] = track['assemblyNames']
            insert_cram_adapter(track['adapter'], track_id, cursor)
        elif adapter_type == 'PAFAdapter':
            insert_paf_adapter(track['adapter'], track_id, cursor)
        elif adapter_type == 'DeltaAdapter':
            insert_delta_adapter(track['adapter'], track_id, cursor)
        else:
            print(f"Unsupported adapter type: {adapter_type}")

        # Insert displays
        insert_displays(track['displays'], track_id, cursor)




def main():
    """Main function to parse config.json and insert track data."""
    config_path = os.path.join(os.path.dirname(__file__), '../config/config.json')
    with open(config_path, 'r') as f:
        config = json.load(f)

    conn = connect_db()
    cur = conn.cursor()

    try:
        # Insert tracks
        tracks_data = config.get('tracks', [])
        insert_tracks(tracks_data, cur)

        # Commit changes
        conn.commit()

    except Exception as e:
        conn.rollback()
        print(f"Error: {e}")

    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    main()
