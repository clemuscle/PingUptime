import os
from flask import Flask
from .main import bp as main_bp
from .api import api as api_bp
from .models import Base, SessionLocal, create_engine
from .scheduler import start_scheduler


def create_app():
    app = Flask(__name__, template_folder="template")

    # Configuration de la base via VARIABLE D'ENV
    database_url = os.getenv("DATABASE_URL")
    engine = create_engine(database_url, echo=False)
    Base.metadata.create_all(bind=engine)
    SessionLocal.configure(bind=engine)
    app.session = SessionLocal

    # Enregistrement des blueprints
    app.register_blueprint(main_bp)
    app.register_blueprint(api_bp)

    # Démarrage du scheduler
    start_scheduler(app)

    return app


# Expose pour Gunicorn
app = create_app()