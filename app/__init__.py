# app/__init__.py

from flask import Flask
from .main import bp

def create_app():
    app = Flask(__name__, template_folder="template")
    app.register_blueprint(bp)
    return app

# Expose l'instance pour Gunicorn
app = create_app()
