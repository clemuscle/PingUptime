from flask import Flask, render_template, request
from uptime_checker import check_urls, monitored_urls

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        url = request.form.get("url")
        if url and url not in monitored_urls:
            monitored_urls.append(url)
    statuses = check_urls()
    return render_template("index.html", statuses=statuses)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
