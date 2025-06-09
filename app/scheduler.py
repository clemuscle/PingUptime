from apscheduler.schedulers.background import BackgroundScheduler
from flask import current_app
from .uptime_checker import perform_checks

def start_scheduler(app):
    sched = BackgroundScheduler()
    sched.add_job(lambda: perform_checks(app.session()), "interval", minutes=1)
    sched.start()