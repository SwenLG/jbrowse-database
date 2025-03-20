from flask import Flask, render_template, send_from_directory, jsonify
import psycopg2

app = Flask(__name__)

# Database connection details
DB_CONFIG = {
    "dbname": "jbrowse_config",
    "user": "swen",
    "password": "cremers",
    "host": "postgres",  # Container name in docker-compose.yml
    "port": 5432
}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/dynamic_fields.json')
def serve_json():
    return send_from_directory('static', 'dynamic_fields.json')

def get_db_connection():
    """Establish a connection to the PostgreSQL database."""
    return psycopg2.connect(**DB_CONFIG)

@app.route('/get_assemblies', methods=['GET'])
def get_assemblies():
    """Fetch assembly names from the database."""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT name FROM \"Assemblies\";")  # ✅ Fetch all assembly names
        assemblies = [row[0] for row in cur.fetchall()]  # ✅ Extract names
        cur.close()
        conn.close()
        return jsonify(assemblies)
    except Exception as e:
        return jsonify({"error": str(e)}), 500  # ✅ Handle errors
    
    # ✅ Fetch distinct categories
@app.route('/get_categories')
def get_categories():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        cur.execute('SELECT DISTINCT unnest("category") FROM "Tracks" WHERE "category" IS NOT NULL')
        categories = [row[0] for row in cur.fetchall()]
        cur.close()
        conn.close()
        return jsonify(categories)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

