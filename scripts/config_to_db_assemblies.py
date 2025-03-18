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

def insert_bgzip_fasta_adapter(adapter_data, assembly_id, cursor):
    """Insert BgzipFastaAdapter data into the database."""
    cursor.execute("""
        INSERT INTO "BgzipFastaAdapter" ("fastaLocation", "faiLocation", "gziLocation", "metadataLocation", "assemblyId")
        VALUES (%s, %s, %s, %s, %s)
        RETURNING "Id"
    """, (
        adapter_data.get('fastaLocation', {}).get('uri'),
        adapter_data.get('faiLocation', {}).get('uri'),
        adapter_data.get('gziLocation', {}).get('uri'),
        adapter_data.get('metadataLocation', {}).get('uri'),
        assembly_id
    ))
    adapter_id = cursor.fetchone()[0]
    print(f"Inserted BgzipFastaAdapter ID: {adapter_id}")
    return adapter_id

def insert_indexed_fasta_adapter(adapter_data, assembly_id, cursor):
    """Insert IndexedFastaAdapter data into the database."""
    cursor.execute("""
        INSERT INTO "IndexedFastaAdapter" ("fastaLocation", "faiLocation", "metadataLocation", "assemblyId")
        VALUES (%s, %s, %s, %s)
        RETURNING "Id"
    """, (
        adapter_data.get('fastaLocation', {}).get('uri'),
        adapter_data.get('faiLocation', {}).get('uri'),
        adapter_data.get('metadataLocation', {}).get('uri'),
        assembly_id
    ))
    adapter_id = cursor.fetchone()[0]
    print(f"Inserted IndexedFastaAdapter ID: {adapter_id}")
    return adapter_id

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


def insert_refnamealias(RefNameAlias, assembly_id, cursor):
    """Insert RefNameAlias into the RefNameAlias table."""
    if not RefNameAlias or 'adapter' not in RefNameAlias:
        print(f"No refNameAliases data for Assembly ID: {assembly_id}. Skipping.")
        return
    
    adapter = RefNameAlias['adapter']
    cursor.execute("""
        INSERT INTO "RefNameAlias" ("assemblyId", "adapterType", "adapterId")
        VALUES (%s, %s, %s)
        RETURNING "Id"
    """, (
        assembly_id,
        adapter['type'],
        adapter.get('adapterId')
    ))
    refnamealias_id = cursor.fetchone()
    if not refnamealias_id:
        return
    refnamealias_id = refnamealias_id[0]
    print(f"Inserted RefNameAlias {refnamealias_id} for Assembly ID: {assembly_id}")

    # Insert features if present
    features = adapter.get('features', [])
    insert_features(features, refnamealias_id, cursor)


def insert_features(features, refnamealias_id, cursor):
    """Insert feature aliases into the features table."""
    if not isinstance(features, list):
        print(f"Features for RefNameAlias ID {refnamealias_id} is not a list. Skipping.")
        return

    if not features:
        print(f"No features for RefNameAlias ID: {refnamealias_id}. Skipping.")
        return

    for feature in features:
        ref_name = feature.get('refName')
        unique_id = feature.get('uniqueId')
        aliases = feature.get('aliases', [])
        
        # Debugging: Print extracted data
        print(f"Inserting feature with refName: {ref_name}, uniqueId: {unique_id}, aliases: {aliases}")
        
        cursor.execute("""
            INSERT INTO "features" ("RefNameAliasId", "refName", "uniqueId", "aliases")
            VALUES (%s, %s, %s, %s)
            RETURNING "Id"
        """, (
            refnamealias_id,
            ref_name,
            unique_id,
            aliases
        ))
        feature_id = cursor.fetchone()
        if feature_id:
            print(f"Inserted feature {feature_id[0]} for RefNameAlias ID: {refnamealias_id}")

def insert_assemblies(data, cursor):
    """Insert assembly data into the database."""
    for assembly in data:
        cursor.execute("""
            INSERT INTO "Assemblies" ("name", "displayName", "aliases", "sequence_trackId", "sequence_type", "adapterType")
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING "Id"
        """, (
            assembly['name'],
            assembly['displayName'],
            assembly.get('aliases', []),
            assembly['sequence']['trackId'],
            assembly['sequence']['type'],
            assembly['sequence']['adapter']['type']
        ))
        assembly_id = cursor.fetchone()[0]
        print(f"Inserted Assembly ID: {assembly_id}")

        # Insert into the correct adapter table
        if assembly['sequence']['adapter']['type'] == 'BgzipFastaAdapter':
            insert_bgzip_fasta_adapter(assembly['sequence']['adapter'], assembly_id, cursor)
        elif assembly['sequence']['adapter']['type'] == 'IndexedFastaAdapter':
            insert_indexed_fasta_adapter(assembly['sequence']['adapter'], assembly_id, cursor)
        else:
            print(f"Unsupported adapter type: {assembly['sequence']['adapter']['type']}")

        # Insert displays
        insert_displays(assembly['sequence']['displays'], assembly_id, cursor)

        # Check for and insert refNameAliases if present
        ref_name_aliases = assembly.get('refNameAliases')
        if ref_name_aliases:
            insert_refnamealias(ref_name_aliases, assembly_id, cursor)
        else:
            print(f"No refNameAliases data for Assembly ID: {assembly_id}. Skipping.")

def main():
    """Main function to parse config.json and insert assemblies data."""
    config_path = os.path.join(os.path.dirname(__file__), '../config/config.json')
    with open(config_path, 'r') as f:
        config = json.load(f)

    conn = connect_db()
    cur = conn.cursor()
    
    try:
        # Insert assemblies
        assemblies_data = config.get('assemblies', [])
        insert_assemblies(assemblies_data, cur)

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
