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


def fetch_tracks(cursor):
    """Fetch tracks and related data from the database."""
    cursor.execute("""
        WITH track_data AS (
            SELECT
                t."Id" AS track_id,
                t."trackId",
                t."type",
                t."name",
                t."assemblyNames",
                t."category"
            FROM "Tracks" t
        ),
        displays_with_renderers AS (
            SELECT
                d."parentId" AS track_id,
                d."displayId",
                d.type AS display_type,
                json_agg(
                    json_build_object(
                        'rendererKey', r."rendererKey",
                        'type', r."type",
                        'rendererDetails', r."rendererDetails"
                    )
                ) AS renderers
            FROM "Displays" d
            LEFT JOIN "Renderer" r ON d."Id" = r."DisplaysId"
            WHERE d."parentType" = 'Track'
            GROUP BY d."parentId", d."displayId", d.type
        )
        SELECT
            td.*,
            json_agg(
                json_build_object(
                    'type', dr.display_type,
                    'displayId', dr."displayId",
                    'renderers', dr.renderers
                )
            ) AS displays
        FROM track_data td
        LEFT JOIN displays_with_renderers dr ON td.track_id = dr.track_id
        GROUP BY td.track_id, td."trackId", td."type", td."name", td."assemblyNames", td."category";
    """)
    return cursor.fetchall()


def fetch_and_transform_bam_adapter(track_id, cursor):
    """Fetch and transform BamAdapter data for a given track ID."""
    cursor.execute("""
        SELECT
            b."bamLocation",
            b."indexLocation",
            b."sequenceAdapterId",
            b."sequenceAdapterType",
            CASE 
                WHEN b."sequenceAdapterType" = 'BgzipFastaAdapter' THEN bg."fastaLocation"
                WHEN b."sequenceAdapterType" = 'IndexedFastaAdapter' THEN i."fastaLocation"
            END AS "fastaLocation",
            CASE 
                WHEN b."sequenceAdapterType" = 'BgzipFastaAdapter' THEN bg."faiLocation"
                WHEN b."sequenceAdapterType" = 'IndexedFastaAdapter' THEN i."faiLocation"
            END AS "faiLocation",
            CASE 
                WHEN b."sequenceAdapterType" = 'BgzipFastaAdapter' THEN bg."gziLocation"
            END AS "gziLocation"
        FROM "BamAdapter" b
        LEFT JOIN "BgzipFastaAdapter" bg ON b."sequenceAdapterId" = bg."Id" AND b."sequenceAdapterType" = 'BgzipFastaAdapter'
        LEFT JOIN "IndexedFastaAdapter" i ON b."sequenceAdapterId" = i."Id" AND b."sequenceAdapterType" = 'IndexedFastaAdapter'
        WHERE b."trackId" = (
            SELECT "Id" FROM "Tracks" WHERE "trackId" = %s
        );
    """, (track_id,))
    adapter_row = cursor.fetchone()

    if not adapter_row:
        return None

    # Transform sequence adapter
    sequence_adapter = {
        "type": adapter_row["sequenceAdapterType"],
        "fastaLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["fastaLocation"]
        },
        "faiLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["faiLocation"]
        },
    }
    if adapter_row["sequenceAdapterType"] == "BgzipFastaAdapter" and adapter_row["gziLocation"]:
        sequence_adapter["gziLocation"] = {
            "locationType": "UriLocation",
            "uri": adapter_row["gziLocation"]
        }

    # Return BamAdapter JSON
    return {
        "type": "BamAdapter",
        "bamLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["bamLocation"]
        },
        "index": {
            "location": {
                "locationType": "UriLocation",
                "uri": adapter_row["indexLocation"]
            }
        },
        "sequenceAdapter": sequence_adapter
    }

def fetch_and_transform_cram_adapter(track_id, cursor):
    """Fetch and transform CramAdapter data for a given track ID."""
    cursor.execute("""
        SELECT
            c."cramLocation",
            c."craiLocation",
            c."sequenceAdapterId",
            c."sequenceAdapterType",
            CASE 
                WHEN c."sequenceAdapterType" = 'BgzipFastaAdapter' THEN bg."fastaLocation"
                WHEN c."sequenceAdapterType" = 'IndexedFastaAdapter' THEN i."fastaLocation"
            END AS "fastaLocation",
            CASE 
                WHEN c."sequenceAdapterType" = 'BgzipFastaAdapter' THEN bg."faiLocation"
                WHEN c."sequenceAdapterType" = 'IndexedFastaAdapter' THEN i."faiLocation"
            END AS "faiLocation",
            CASE 
                WHEN c."sequenceAdapterType" = 'BgzipFastaAdapter' THEN bg."gziLocation"
            END AS "gziLocation"
        FROM "CramAdapter" c
        LEFT JOIN "BgzipFastaAdapter" bg ON c."sequenceAdapterId" = bg."Id" AND c."sequenceAdapterType" = 'BgzipFastaAdapter'
        LEFT JOIN "IndexedFastaAdapter" i ON c."sequenceAdapterId" = i."Id" AND c."sequenceAdapterType" = 'IndexedFastaAdapter'
        WHERE c."trackId" = (
            SELECT "Id" FROM "Tracks" WHERE "trackId" = %s
        );
    """, (track_id,))
    adapter_row = cursor.fetchone()

    if not adapter_row:
        return None

    # Transform sequence adapter
    sequence_adapter = {
        "type": adapter_row["sequenceAdapterType"],
        "fastaLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["fastaLocation"]
        },
        "faiLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["faiLocation"]
        },
    }
    if adapter_row["sequenceAdapterType"] == "BgzipFastaAdapter" and adapter_row["gziLocation"]:
        sequence_adapter["gziLocation"] = {
            "locationType": "UriLocation",
            "uri": adapter_row["gziLocation"]
        }

    # Return CramAdapter JSON
    return {
        "type": "CramAdapter",
        "cramLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["cramLocation"]
        },
        "craiLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["craiLocation"]
        },
        "sequenceAdapter": sequence_adapter
    }

def fetch_and_transform_gff3_tabix_adapter(track_id, cursor):
    """Fetch and transform Gff3TabixAdapter data for a given track ID."""
    cursor.execute("""
        SELECT
            "gffGzLocation",
            "indexLocation"
        FROM "Gff3TabixAdapter"
        WHERE "trackId" = (
            SELECT "Id" FROM "Tracks" WHERE "trackId" = %s
        );
    """, (track_id,))
    
    adapter_row = cursor.fetchone()

    if not adapter_row:
        return None  # No adapter found for this track ID

    # Return Gff3TabixAdapter JSON
    return {
        "type": "Gff3TabixAdapter",
        "gffGzLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["gffGzLocation"]
        },
        "index": {
            "location": {
                "locationType": "UriLocation",
                "uri": adapter_row["indexLocation"]
            }
        }
    }

def fetch_and_transform_vcf_tabix_adapter(track_id, cursor):
    """Fetch and transform VcfTabixAdapter data for a given track ID."""
    cursor.execute("""
        SELECT
            "vcfGzLocation",
            "indexLocation"
        FROM "VcfTabixAdapter"
        WHERE "trackId" = (
            SELECT "Id" FROM "Tracks" WHERE "trackId" = %s
        );
    """, (track_id,))
    
    adapter_row = cursor.fetchone()

    if not adapter_row:
        return None  # No adapter found for this track ID

    # Return VcfTabixAdapter JSON
    return {
        "type": "VcfTabixAdapter",
        "vcfGzLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["vcfGzLocation"]
        },
        "index": {
            "location": {
                "locationType": "UriLocation",
                "uri": adapter_row["indexLocation"]
            }
        }
    }

def fetch_and_transform_bed_tabix_adapter(track_id, cursor):
    """Fetch and transform BedTabixAdapter data for a given track ID."""
    cursor.execute("""
        SELECT
            "bedGzLocation",
            "indexLocation"
        FROM "BedTabixAdapter"
        WHERE "trackId" = (
            SELECT "Id" FROM "Tracks" WHERE "trackId" = %s
        );
    """, (track_id,))
    
    adapter_row = cursor.fetchone()

    if not adapter_row:
        return None  # No adapter found for this track ID

    # Return BedTabixAdapter JSON
    return {
        "type": "BedTabixAdapter",
        "bedGzLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["bedGzLocation"]
        },
        "index": {
            "location": {
                "locationType": "UriLocation",
                "uri": adapter_row["indexLocation"]
            }
        }
    }

def fetch_and_transform_paf_adapter(track_id, cursor):
    """Fetch and transform PAFAdapter data for a given track ID."""
    cursor.execute("""
        SELECT
            "pafLocation",
            "assemblyNames"
        FROM "PAFAdapter"
        WHERE "trackId" = (
            SELECT "Id" FROM "Tracks" WHERE "trackId" = %s
        );
    """, (track_id,))
    
    adapter_row = cursor.fetchone()

    if not adapter_row:
        return None  # No adapter found for this track ID

    # Return PAFAdapter JSON
    return {
        "type": "PAFAdapter",
        "assemblyNames": adapter_row["assemblyNames"],
        "pafLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["pafLocation"]
        }
    }

def fetch_and_transform_delta_adapter(track_id, cursor):
    """Fetch and transform DeltaAdapter data for a given track ID."""
    cursor.execute("""
        SELECT
            "deltaLocation",
            "assemblyNames"
        FROM "DeltaAdapter"
        WHERE "trackId" = (
            SELECT "Id" FROM "Tracks" WHERE "trackId" = %s
        );
    """, (track_id,))
    
    adapter_row = cursor.fetchone()

    if not adapter_row:
        return None  # No adapter found for this track ID

    # Return DeltaAdapter JSON
    return {
        "type": "DeltaAdapter",
        "assemblyNames": adapter_row["assemblyNames"],
        "deltaLocation": {
            "locationType": "UriLocation",
            "uri": adapter_row["deltaLocation"]
        }
    }


def fetch_and_transform_adapter(track_id, cursor):
    """Fetch the adapterType for a track and delegate to the appropriate adapter function."""
    # Fetch the adapterType for the given trackId
    cursor.execute("""
        SELECT "adapterType"
        FROM "Tracks"
        WHERE "trackId" = %s;
    """, (track_id,))
    result = cursor.fetchone()

    if not result or not result["adapterType"]:
        return None  # No adapterType found for the track

    adapter_type = result["adapterType"]

    # Delegate to the appropriate adapter function
    if adapter_type == "BamAdapter":
        return fetch_and_transform_bam_adapter(track_id, cursor)
    elif adapter_type == "CramAdapter":
        return fetch_and_transform_cram_adapter(track_id, cursor)
    elif adapter_type == "Gff3TabixAdapter":
        return fetch_and_transform_gff3_tabix_adapter(track_id, cursor)
    elif adapter_type == "VcfTabixAdapter":
        return fetch_and_transform_vcf_tabix_adapter(track_id, cursor)
    elif adapter_type == "BedTabixAdapter":
        return fetch_and_transform_bed_tabix_adapter(track_id, cursor)
    elif adapter_type == "PAFAdapter":
        return fetch_and_transform_paf_adapter(track_id, cursor)
    elif adapter_type == "DeltaAdapter":
        return fetch_and_transform_delta_adapter(track_id, cursor)
    else:
        print(f"Unknown adapterType '{adapter_type}' for trackId '{track_id}'.")
        return None


def transform_tracks_to_json(rows, cursor):
    """Transform database rows into JSON format."""
    tracks = []
    for row in rows:
        # Process displays
        displays = []
        if row['displays']:
            for display in row['displays']:
                display_obj = {
                    "type": display.get("type"),
                    "displayId": display.get("displayId"),
                }

                # Process renderers
                renderers = display.get("renderers")
                if renderers:
                    valid_renderers = [r for r in renderers if r.get("type") is not None]
                    for renderer in valid_renderers:
                        renderer_key = renderer.get("rendererKey", "renderer")
                        renderer_details = renderer.get("rendererDetails", {})
                        renderer_details = {k: v for k, v in renderer_details.items() if k != "rendererKey"}
                        renderer_type = renderer.get("type")

                        if renderer_key == "renderer":
                            display_obj["renderer"] = {
                                "type": renderer_type,
                                **renderer_details
                            }
                        else:
                            if "renderers" not in display_obj:
                                display_obj["renderers"] = {}
                            display_obj["renderers"][renderer_key] = {
                                "type": renderer_type,
                                **renderer_details
                            }

                displays.append(display_obj)

        # Construct the track object
        track = {
            "type": row["type"],
            "trackId": row["trackId"],
            "name": row["name"],
            "assemblyNames": row["assemblyNames"] if row["assemblyNames"] else []
        }

        # Add category if present
        if row["category"]:
            track["category"] = row["category"]

        # Add adapter dynamically
        adapter = fetch_and_transform_adapter(row["trackId"], cursor)
        if adapter:
            track["adapter"] = adapter

        # Add displays
        track["displays"] = displays

        tracks.append(track)

    return {"tracks": tracks}



def main():
    """Main function to fetch and transform track data into JSON."""
    conn = connect_db()
    cur = conn.cursor()

    try:
        # Fetch tracks
        tracks = fetch_tracks(cur)

        # Transform tracks into JSON
        json_data = transform_tracks_to_json(tracks, cur)

        # Write JSON to a file
        with open('tracks_output.json', 'w') as f:
            json.dump(json_data, f, indent=4)

    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    main()
