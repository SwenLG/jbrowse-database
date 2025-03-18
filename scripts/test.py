import json
import os

# Define the path to the JSON file
config_path = os.path.join(os.path.dirname(__file__), '../config/config.json')

# Function to extract unique keys and their data types from all "renderer" objects
def get_renderer_keys_and_types(json_path):
    try:
        # Open and load the JSON file
        with open(json_path, 'r') as file:
            data = json.load(file)
        
        # Dictionary to store keys and their inferred data types
        keys_and_types = {}

        # Function to recursively find "renderer" keys and types
        def extract_renderer_keys_and_types(obj):
            if isinstance(obj, dict):
                # If the object has a "renderer" key
                if "renderer" in obj and isinstance(obj["renderer"], dict):
                    for key, value in obj["renderer"].items():
                        value_type = type(value).__name__  # Get the name of the data type
                        if key not in keys_and_types:
                            keys_and_types[key] = set()
                        keys_and_types[key].add(value_type)
                # Recurse into each value in the dictionary
                for key, value in obj.items():
                    extract_renderer_keys_and_types(value)
            elif isinstance(obj, list):
                # Recurse into each item in the list
                for item in obj:
                    extract_renderer_keys_and_types(item)

        # Extract all unique keys and their types
        extract_renderer_keys_and_types(data)

        # Print the unique keys with their types
        print("Renderer keys and their data types:")
        for key, types in keys_and_types.items():
            print(f"  {key}: {', '.join(types)}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Run the function
if __name__ == "__main__":
    get_renderer_keys_and_types(config_path)
