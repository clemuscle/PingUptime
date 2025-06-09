from flask import Blueprint, render_template, request, current_app, redirect, url_for
from .models import Url

bp = Blueprint("main", __name__)

@bp.route("/", methods=["GET", "POST"])
def index():
    db = current_app.session()
    if request.method == "POST":
        url = request.form.get("url")
        if url:
            # Créer si inexistant
            if not db.query(Url).filter_by(address=url).first():
                db.add(Url(address=url))
                db.commit()
        return redirect(url_for("main.index"))

    urls = db.query(Url).all()
    return render_template("index.html", urls=urls)

@bp.route("/url/<int:id>", methods=["POST"])
def delete_url(id):
    db = current_app.session()
    db.query(Url).filter_by(id=id).delete()
    db.commit()
    return redirect(url_for("main.index"))