import psycopg2

# ✅ Centralized database connection
DB_CONFIG = {
    "dbname": "jbrowse_config",
    "user": "swen",
    "password": "cremers",
    "host": "postgres",
    "port": 5432
}

def get_db_connection():
    """Establish a database connection."""
    return psycopg2.connect(**DB_CONFIG)
