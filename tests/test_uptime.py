import pytest
from app.uptime_checker import check_urls, monitored_urls

def test_monitored_urls_initial():
    # La liste initiale contient au moins google.com
    assert "https://google.com" in monitored_urls

def test_check_urls_returns_statuses_list():
    statuses = check_urls()
    # Doit renvoyer une liste de tuples (url, statut)
    assert isinstance(statuses, list)
    assert all(isinstance(item, tuple) and len(item) == 2 for item in statuses)
