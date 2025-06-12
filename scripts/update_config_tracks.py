import psycopg2.extras
import json
import sys
import os

DB_CONFIG = {
    'dbname': 'jbrowse_config',
    'user': 'swen',
    'password': 'cremers',
    'host': 'postgres',
    'port': 5432
}

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CONFIG_PATH = os.path.join(BASE_DIR, 'config', 'config.json')

def connect_db():
    return psycopg2.connect(**DB_CONFIG, cursor_factory=psycopg2.extras.DictCursor)

def load_config():
    if not os.path.exists(CONFIG_PATH):
        return {"assemblies": [], "tracks": []}
    with open(CONFIG_PATH) as f:
        return json.load(f)

def save_config(config):
    with open(CONFIG_PATH, "w") as f:
        json.dump(config, f, indent=4)

def fetch_all_tracks(cursor):
    cursor.execute("""
        SELECT
            t."trackId", t."type", t."name", t."assemblyNames", t."category", t."adapterType",
            d."type" AS display_type,
            d."displayId",
            v."vcfGzLocation", v."indexLocation" AS "vcfIndex",
            b."bamLocation", b."indexLocation" AS "bamIndex", b."sequenceAdapterId", b."sequenceAdapterType",
            c."cramLocation", c."craiLocation", c."sequenceAdapterId" AS "sequenceAdapterId_cram", c."sequenceAdapterType" AS "sequenceAdapterType_cram",
            g."gffGzLocation", g."indexLocation" AS "gffIndex",
            bed."bedGzLocation", bed."indexLocation" AS "bedIndex",
            p."pafLocation",
            dlt."deltaLocation"
        FROM "Tracks" t
        LEFT JOIN "Displays" d ON d."parentId" = t."Id" AND d."parentType" = 'Track'
        LEFT JOIN "VcfTabixAdapter" v ON v."trackId" = t."Id"
        LEFT JOIN "BamAdapter" b ON b."trackId" = t."Id"
        LEFT JOIN "CramAdapter" c ON c."trackId" = t."Id"
        LEFT JOIN "Gff3TabixAdapter" g ON g."trackId" = t."Id"
        LEFT JOIN "BedTabixAdapter" bed ON bed."trackId" = t."Id"
        LEFT JOIN "PAFAdapter" p ON p."trackId" = t."Id"
        LEFT JOIN "DeltaAdapter" dlt ON dlt."trackId" = t."Id"
    """)
    return cursor.fetchall()

def build_track_map(rows, cursor):
    tracks = {}
    for row in rows:
        tid = row["trackId"]
        if tid not in tracks:
            base = {
                "type": row["type"],
                "trackId": tid,
                "name": row["name"],
                "assemblyNames": row["assemblyNames"] or [],
                "category": row["category"] or [],
                "adapter": {
                    "type": row["adapterType"]
                },
                "displays": []
            }

            # Adapter-specific fields
            if row["adapterType"] == "VcfTabixAdapter":
                base["adapter"]["vcfGzLocation"] = {
                    "locationType": "UriLocation",
                    "uri": row.get("vcfGzLocation")
                }
                base["adapter"]["index"] = {
                    "location": {
                        "locationType": "UriLocation",
                        "uri": row.get("vcfIndex")
                    }
                }

            elif row["adapterType"] == "BamAdapter":
                base["adapter"]["bamLocation"] = {
                    "locationType": "UriLocation",
                    "uri": row.get("bamLocation")
                }
                base["adapter"]["index"] = {
                    "location": {
                        "locationType": "UriLocation",
                        "uri": row.get("bamIndex")
                    }
                }
                
                seq_adapter_type = row.get("sequenceAdapterType")
                seq_adapter = {}

                if seq_adapter_type == "IndexedFastaAdapter":
                    cursor.execute("""
                        SELECT "fastaLocation", "faiLocation", "metadataLocation"
                        FROM "IndexedFastaAdapter"
                        WHERE "Id" = %s
                    """, (row.get("sequenceAdapterId"),))
                    adapter_row = cursor.fetchone()
                    if adapter_row:
                        seq_adapter = {
                            "type": "IndexedFastaAdapter",
                            "fastaLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[0]
                            },
                            "faiLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[1]
                            },
                            "metadataLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[2]
                            }
                        }

                elif seq_adapter_type == "BgzipFastaAdapter":
                    cursor.execute("""
                        SELECT "fastaLocation", "faiLocation", "gziLocation", "metadataLocation"
                        FROM "BgzipFastaAdapter"
                        WHERE "Id" = %s
                    """, (row.get("sequenceAdapterId"),))
                    adapter_row = cursor.fetchone()
                    if adapter_row:
                        seq_adapter = {
                            "type": "BgzipFastaAdapter",
                            "fastaLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[0]
                            },
                            "faiLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[1]
                            },
                            "gziLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[2]
                            },
                            "metadataLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[3]
                            }
                        }

                # Embed this fully in the config
                if seq_adapter:
                    base["adapter"]["sequenceAdapter"] = seq_adapter


            elif row["adapterType"] == "CramAdapter":
                base["adapter"]["cramLocation"] = {
                    "locationType": "UriLocation",
                    "uri": row.get("cramLocation")
                }
                base["adapter"]["craiLocation"] = {
                    "locationType": "UriLocation",
                    "uri": row.get("craiLocation")
                }

                seq_adapter_type = row.get("sequenceAdapterType_cram")
                seq_adapter = {}

                if seq_adapter_type == "IndexedFastaAdapter":
                    cursor.execute("""
                        SELECT "fastaLocation", "faiLocation", "metadataLocation"
                        FROM "IndexedFastaAdapter"
                        WHERE "Id" = %s
                    """, (row.get("sequenceAdapterId_cram"),))
                    adapter_row = cursor.fetchone()
                    if adapter_row:
                        seq_adapter = {
                            "type": "IndexedFastaAdapter",
                            "fastaLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[0]
                            },
                            "faiLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[1]
                            },
                            "metadataLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[2]
                            }
                        }

                elif seq_adapter_type == "BgzipFastaAdapter":
                    cursor.execute("""
                        SELECT "fastaLocation", "faiLocation", "gziLocation", "metadataLocation"
                        FROM "BgzipFastaAdapter"
                        WHERE "Id" = %s
                    """, (row.get("sequenceAdapterId_cram"),))
                    adapter_row = cursor.fetchone()
                    if adapter_row:
                        seq_adapter = {
                            "type": "BgzipFastaAdapter",
                            "fastaLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[0]
                            },
                            "faiLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[1]
                            },
                            "gziLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[2]
                            },
                            "metadataLocation": {
                                "locationType": "UriLocation",
                                "uri": adapter_row[3]
                            }
                        }

                # Embed this fully in the config
                if seq_adapter:
                    base["adapter"]["sequenceAdapter"] = seq_adapter

            elif row["adapterType"] == "Gff3TabixAdapter":
                base["adapter"]["gffGzLocation"] = {
                    "locationType": "UriLocation",
                    "uri": row.get("gffGzLocation")
                }
                base["adapter"]["index"] = {
                    "location": {
                        "locationType": "UriLocation",
                        "uri": row.get("gffIndex")
                    }
                }

            elif row["adapterType"] == "BedTabixAdapter":
                base["adapter"]["bedGzLocation"] = {
                    "locationType": "UriLocation",
                    "uri": row.get("bedGzLocation")
                }
                base["adapter"]["index"] = {
                    "location": {
                        "locationType": "UriLocation",
                        "uri": row.get("bedIndex")
                    }
                }

            elif row["adapterType"] == "PAFAdapter":
                base["adapter"]["assemblyNames"] = row.get("assemblyNames", [])
                base["adapter"]["pafLocation"] = {
                    "locationType": "UriLocation",
                    "uri": row.get("pafLocation")
                }


            elif row["adapterType"] == "DeltaAdapter":
                base["adapter"]["assemblyNames"] = row.get("assemblyNames", [])
                base["adapter"]["deltaLocation"] = {
                    "locationType": "UriLocation",
                    "uri": row.get("deltaLocation")
                }

            tracks[tid] = base

        if row["display_type"] and row["displayId"]:
            tracks[tid]["displays"].append({
                "type": row.get("display_type"),
                "displayId": row.get("displayId")
            })

    # Reorder displays so the default is first
    for track in tracks.values():
        default_type = None

        # Get default display type from the Displays table
        cursor.execute("""
            SELECT "type"
            FROM "Displays"
            WHERE "parentId" = (
                SELECT "Id" FROM "Tracks" WHERE "trackId" = %s
            )
            ORDER BY "Id" ASC
            LIMIT 1
        """, (track["trackId"],))

        result = cursor.fetchone()
        if result:
            default_type = result["type"]

        if default_type:
            track["displays"].sort(key=lambda d: 0 if d["type"] == default_type else 1)


    return list(tracks.values())

def update_config(new_track_id):
    print("Loading config from:", CONFIG_PATH)
    conn = connect_db()
    cur = conn.cursor()
    db_rows = fetch_all_tracks(cur)

    db_track_ids = {row["trackId"] for row in db_rows}
    track_objs = build_track_map(db_rows, cur)

    config = load_config()
    config["tracks"] = [
        t for t in config.get("tracks", [])
        if t["trackId"] in db_track_ids and t["trackId"] != new_track_id
    ]

    for t in track_objs:
        if t["trackId"] == new_track_id:
            config["tracks"].append(t)
            break

    save_config(config)
    cur.close()
    conn.close()
    print("Config updated with track:", new_track_id)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python update_config_tracks.py <trackId>")
        sys.exit(1)

    update_config(sys.argv[1])
