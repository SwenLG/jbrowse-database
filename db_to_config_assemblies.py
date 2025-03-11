import psycopg2.extras
import json
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
    return psycopg2.connect(**DB_CONFIG, cursor_factory=psycopg2.extras.DictCursor)


def fetch_assemblies(cursor):
    """Fetch assemblies and related data."""
    cursor.execute("""
        WITH assembly_data AS (
            SELECT 
                a."Id" AS assembly_id,
                a.name,
                a.aliases,
                a.sequence_type,
                a."sequence_trackId",
                a."displayName",
                a."adapterType",
                COALESCE(i."fastaLocation", b."fastaLocation") AS adapter_fastaLocation,
                COALESCE(i."faiLocation", b."faiLocation") AS adapter_faiLocation,
                COALESCE(i."metadataLocation", b."metadataLocation") AS adapter_metadataLocation,
                b."gziLocation" AS adapter_gziLocation  -- Specific to BgzipFastaAdapter
            FROM "Assemblies" a
            LEFT JOIN "IndexedFastaAdapter" i ON a."Id" = i."assemblyId"
            LEFT JOIN "BgzipFastaAdapter" b ON a."Id" = b."assemblyId"
        ),
        distinct_displays AS (
            SELECT DISTINCT 
                d."parentId" AS assembly_id,
                d.type,
                d."displayId",
                r.type AS renderer_type,
                r.height,
                r.labels_description,
                r."showLabels",
                r."showDescriptions",
                r.color1
            FROM "Displays" d
            LEFT JOIN "Renderer" r ON d."Id" = r."DisplaysId"
        ),
        refnamealias_features AS (
            SELECT 
                rna."assemblyId" AS assembly_id,
                rna."adapterType",
                rna."adapterId",
                json_agg(
                    json_build_object(
                        'refName', f."refName",
                        'uniqueId', f."uniqueId",
                        'aliases', f.aliases
                    )
                ) AS features
            FROM "RefNameAlias" rna
            LEFT JOIN features f ON rna."Id" = f."RefNameAliasId"
            GROUP BY rna."assemblyId", rna."adapterType", rna."adapterId"
        )
        SELECT
            ad.*,
            json_agg(
                json_build_object(
                    'type', dd.type,
                    'displayId', dd."displayId",
                    'renderer', json_build_object(
                        'type', dd.renderer_type,
                        'height', dd.height,
                        'labels_description', dd.labels_description,
                        'showLabels', dd."showLabels",
                        'showDescriptions', dd."showDescriptions",
                        'color1', dd.color1
                    )
                )
            ) AS displays,
            json_agg(
                json_build_object(
                    'type', rf."adapterType",
                    'adapterId', rf."adapterId",
                    'features', rf.features
                )
            ) AS refNameAliases
        FROM assembly_data ad
        LEFT JOIN distinct_displays dd ON ad.assembly_id = dd.assembly_id
        LEFT JOIN refnamealias_features rf ON ad.assembly_id = rf.assembly_id
        GROUP BY ad.assembly_id, ad.name, ad.aliases, ad.sequence_type, ad."sequence_trackId", ad."displayName", ad."adapterType", ad.adapter_fastaLocation, ad.adapter_faiLocation, ad.adapter_metadataLocation, ad.adapter_gziLocation;
    """)

    return cursor.fetchall()






def transform_to_json(rows):
    """Transform database rows into JSON format."""
    assemblies = []
    for idx, row in enumerate(rows):
        # Construct the adapter
        adapter = {
            "type": row[6],  # 'adapterType' from the database
            "fastaLocation": {"locationType": "UriLocation", "uri": row[7]},  # 'fastaLocation'
            "faiLocation": {"locationType": "UriLocation", "uri": row[8]},  # 'faiLocation'
            "metadataLocation": {"locationType": "UriLocation", "uri": row[9]},  # 'metadataLocation'
        }

        # Add gziLocation for BgzipFastaAdapter
        if row[6] == "BgzipFastaAdapter" and row[10]:  # 'gziLocation'
            adapter["gziLocation"] = {"locationType": "UriLocation", "uri": row[10]}

        # Construct the sequence section
        sequence = {
            "type": "ReferenceSequenceTrack",  # Always the same
            "trackId": row[4],  # 'sequence_trackId'
            "adapter": adapter,
        }

        # Process displays
        displays = []
        if row[11]:  # Assuming row[11] contains JSON for displays
            for display in row[11]:  # Iterate through display objects
                renderer = display.get("renderer", {})
                renderer = {k: v for k, v in renderer.items() if v is not None}  # Remove null fields
                display_obj = {
                    "type": display.get("type"),
                    "displayId": display.get("displayId"),
                }
                if renderer:  # Only include renderer if it's not empty
                    display_obj["renderer"] = renderer
                displays.append(display_obj)

        # Process the refNameAliases section
        ref_name_aliases = None
        if (
            row[12]  # Ensure refNameAliases data exists
            and isinstance(row[12], list)
            and row[12][0]  # Ensure the first item exists
        ):
            first_alias = row[12][0]
            if "adapterId" in first_alias and "features" in first_alias:
                features = [
                    {
                        "refName": feature.get("refName"),
                        "uniqueId": feature.get("uniqueId"),
                        "aliases": feature.get("aliases", []),
                    }
                    for feature in (first_alias["features"] or [])  # Ensure features is iterable
                ]

                # Only add refNameAliases if features are not empty
                if features:
                    ref_name_aliases = {
                        "adapter": {
                            "type": "FromConfigAdapter",
                            "adapterId": first_alias["adapterId"],
                            "features": features,
                        }
                    }

        # Construct the assembly object
        assembly = {
            "name": row[1],  # 'name'
            "aliases": row[2] if row[2] else [],  # 'aliases' or empty list
            "sequence": sequence,  # Constructed sequence section
            "displays": displays,  # Processed displays section
            "refNameAliases": ref_name_aliases if ref_name_aliases else {},  # Add only if not empty
            "displayName": row[5],  # 'displayName'
        }

        # Remove the refNameAliases field entirely if it's empty
        if not ref_name_aliases:
            del assembly["refNameAliases"]

        assemblies.append(assembly)

    return {"assemblies": assemblies}






def main():
    """Main function to fetch and transform data into JSON."""
    conn = connect_db()
    cur = conn.cursor()

    try:
        rows = fetch_assemblies(cur)
        json_data = transform_to_json(rows)

        # Write JSON to a file
        with open('output.json', 'w') as f:
            json.dump(json_data, f, indent=4)

    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    main()
