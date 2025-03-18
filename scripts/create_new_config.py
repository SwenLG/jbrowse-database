import json
import os

# Define file paths
BASE_CONFIG_FILE = "../empty_config.json"  # The original config file
ASSEMBLIES_FILE = "../assemblies_output.json"  # Generated assemblies data
TRACKS_FILE = "../tracks_output.json"  # Generated tracks data
NEW_CONFIG_FILE = "../config_updated.json"  # The new config file to be created

def load_json(file_path):
    """Load a JSON file."""
    if os.path.exists(file_path):
        with open(file_path, "r", encoding="utf-8") as file:
            return json.load(file)
    return {}

def merge_configurations():
    """Merge base config with assemblies and tracks."""
    
    # Load existing config, assemblies, and tracks
    base_config = load_json(BASE_CONFIG_FILE)
    assemblies_data = load_json(ASSEMBLIES_FILE)
    tracks_data = load_json(TRACKS_FILE)

    # Ensure the base config has "assemblies" and "tracks" keys
    if "assemblies" not in base_config:
        base_config["assemblies"] = []
    if "tracks" not in base_config:
        base_config["tracks"] = []

    # Extract assemblies and tracks from the provided JSON files
    new_assemblies = assemblies_data.get("assemblies", [])
    new_tracks = tracks_data.get("tracks", [])

    # Replace assemblies and tracks in base config
    base_config["assemblies"] = new_assemblies
    base_config["tracks"] = new_tracks

    # Write to a new config file
    with open(NEW_CONFIG_FILE, "w", encoding="utf-8") as file:
        json.dump(base_config, file, indent=4)

    print(f"✅ New config file created: {NEW_CONFIG_FILE}")

# Run the merge function
if __name__ == "__main__":
    merge_configurations()
