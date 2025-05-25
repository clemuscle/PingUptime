from flask import Blueprint, render_template, request
from .uptime_checker import check_urls, monitored_urls

bp = Blueprint("main", __name__)

@bp.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        url = request.form.get("url")
        if url and url not in monitored_urls:
            monitored_urls.append(url)
    statuses = check_urls()
    return render_template("index.html", statuses=statuses)
