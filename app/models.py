from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, func, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker

Base = declarative_base()
SessionLocal = sessionmaker()

class Url(Base):
    __tablename__ = "urls"
    id           = Column(Integer, primary_key=True)
    address      = Column(String(512), nullable=False, unique=True)
    date_added   = Column(DateTime, server_default=func.now())
    last_checked = Column(DateTime)
    last_status  = Column(String(50))
    history      = relationship("CheckHistory", back_populates="url")

class CheckHistory(Base):
    __tablename__ = "check_history"
    id         = Column(Integer, primary_key=True)
    url_id     = Column(Integer, ForeignKey("urls.id"))
    checked_at = Column(DateTime, server_default=func.now())
    status     = Column(String(50))
    url        = relationship("Url", back_populates="history")