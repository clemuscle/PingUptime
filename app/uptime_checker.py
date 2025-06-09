import requests
from sqlalchemy import func
from .models import Url, CheckHistory

# Fonction appelée par le scheduler
def perform_checks(db_session):
    urls = db_session.query(Url).all()
    for u in urls:
        try:
            r = requests.get(u.address, timeout=5)
            status = "UP" if r.status_code == 200 else f"DOWN ({r.status_code})"
        except Exception:
            status = "DOWN"
        u.last_checked = func.now()
        u.last_status  = status
        db_session.add(CheckHistory(url_id=u.id, status=status))
    db_session.commit()