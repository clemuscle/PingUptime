from flask import Blueprint, request, jsonify, current_app
from .models import Url

api = Blueprint("api", __name__, url_prefix="/api")

@api.route("/urls", methods=["GET"])
def list_urls():
    db = current_app.session()
    data = [{"id": u.id, "address": u.address, "status": u.last_status} for u in db.query(Url).all()]
    return jsonify(data)

@api.route("/urls", methods=["POST"])
def create_url():
    db = current_app.session()
    payload = request.get_json()
    u = Url(address=payload.get("address"))
    db.add(u); db.commit()
    return jsonify({"id": u.id}), 201

@api.route("/urls/<int:id>", methods=["DELETE"])
def delete_url_api(id):
    db = current_app.session()
    db.query(Url).filter_by(id=id).delete()
    db.commit()
    return '', 204