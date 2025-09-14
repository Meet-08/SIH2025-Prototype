from datetime import datetime, timezone

from sqlalchemy import JSON, Column, DateTime, Integer, String

from db.database import Base


class College(Base):
    __tablename__ = "colleges"

    college_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    college_name = Column(String, nullable=False, index=True)
    location = Column(String, nullable=True)
    district = Column(String, nullable=True)
    state = Column(String, nullable=True)
    degrees = Column(JSON, nullable=True)
    facilities = Column(JSON, nullable=True)
    created_at = Column(DateTime, default=datetime.now(timezone.utc))
