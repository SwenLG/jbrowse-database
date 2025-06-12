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
        return {"assemblies": []}
    with open(CONFIG_PATH) as f:
        return json.load(f)

def save_config(config):
    with open(CONFIG_PATH, "w") as f:
        json.dump(config, f, indent=4)


def fetch_all_assemblies(cursor):
    cursor.execute("""
        SELECT 
            a.name, a.aliases, a."displayName", a."sequence_trackId", a."adapterType",
            COALESCE(i."fastaLocation", b."fastaLocation") AS fasta,
            COALESCE(i."faiLocation", b."faiLocation") AS fai,
            COALESCE(i."metadataLocation", b."metadataLocation") AS metadata,
            b."gziLocation",
            d."type" AS display_type,
            d."displayId"
        FROM "Assemblies" a
        LEFT JOIN "IndexedFastaAdapter" i ON a."Id" = i."assemblyId"
        LEFT JOIN "BgzipFastaAdapter" b ON a."Id" = b."assemblyId"
        LEFT JOIN "Displays" d ON d."parentId" = a."Id" AND d."parentType" = 'Assembly'
    """)
    return cursor.fetchall()

def build_assembly_map(rows):
    assemblies = {}
    for row in rows:
        name = row["name"]
        if name not in assemblies:
            assemblies[name] = {
                "name": name,
                "aliases": row["aliases"] or [],
                "sequence": {
                    "type": "ReferenceSequenceTrack",
                    "trackId": row["sequence_trackId"],
                    "adapter": {
                        "type": row["adapterType"],
                        "fastaLocation": {
                            "locationType": "UriLocation",
                            "uri": row["fasta"]
                        },
                        "faiLocation": {
                            "locationType": "UriLocation",
                            "uri": row["fai"]
                        },
                        "metadataLocation": {
                            "locationType": "UriLocation",
                            "uri": row["metadata"]
                        }
                    },
                    "displays": []
                },
                "displayName": row["displayName"]
            }

            if row["adapterType"] == "BgzipFastaAdapter" and row["gziLocation"]:
                assemblies[name]["sequence"]["adapter"]["gziLocation"] = {
                    "locationType": "UriLocation",
                    "uri": row["gziLocation"]
                }

        if row["display_type"] and row["displayId"]:
            assemblies[name]["sequence"]["displays"].append({
                "type": row["display_type"],
                "displayId": row["displayId"]
            })

    return list(assemblies.values())


def update_config(new_name):
    print("📁 Loading config from:", CONFIG_PATH)
    conn = connect_db()
    cur = conn.cursor()
    db_rows = fetch_all_assemblies(cur)

    db_names = {row["name"] for row in db_rows}
    assembly_objs = build_assembly_map(db_rows)

    config = load_config()
    config["assemblies"] = [
        asm for asm in config.get("assemblies", [])
        if asm["name"] in db_names and asm["name"] != new_name
    ]

    for asm in assembly_objs:
        if asm["name"] == new_name:
            config["assemblies"].append(asm)
            break

    # 🧹 De-duplicate fallback displayIds (JBrowse auto-generates some of these)
    for asm in config["assemblies"]:
        seen = set()
        unique_displays = []
        for disp in asm["sequence"]["displays"]:
            if disp["displayId"] not in seen:
                unique_displays.append(disp)
                seen.add(disp["displayId"])
        asm["sequence"]["displays"] = unique_displays

    save_config(config)
    cur.close()
    conn.close()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python update_config_assemblies.py <assembly_name>")
        sys.exit(1)

    update_config(sys.argv[1])
    print("✅ Config updated.")
