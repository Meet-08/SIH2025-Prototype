from datetime import datetime, timezone

from sqlalchemy import JSON, Column, DateTime, Integer, String, Text
from sqlalchemy.orm import relationship

from db.database import Base
from models.career_course import career_courses


class Career(Base):
    __tablename__ = "careers"

    career_id = Column(Integer, primary_key=True, index=True)
    career_name = Column(String, index=True)
    sector = Column(Text)
    higher_study_options = Column(JSON)
    exam_options = Column(JSON)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    courses = relationship(
        "Course",
        secondary=career_courses,
        back_populates="careers",
    )
    updated_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )
