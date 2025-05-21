import requests

monitored_urls = ["https://google.com", "https://github.com"]

def check_urls():
    statuses = []
    for url in monitored_urls:
        try:
            r = requests.get(url, timeout=3)
            statuses.append((url, "UP" if r.status_code == 200 else f"DOWN ({r.status_code})"))
        except Exception:
            statuses.append((url, "DOWN"))
    return statuses
