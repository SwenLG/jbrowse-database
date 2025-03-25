from flask import Flask, render_template, send_from_directory
from routes.routes import routes  # ✅ Import routes

app = Flask(__name__)

# ✅ Register routes from routes.py
app.register_blueprint(routes)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/dynamic_fields.json')
def serve_json():
    return send_from_directory('static', 'dynamic_fields.json')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)


