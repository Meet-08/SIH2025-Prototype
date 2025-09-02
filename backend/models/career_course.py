from sqlalchemy import Column, ForeignKey, Integer, Table

from db.database import Base

career_courses = Table(
    "career_courses",
    Base.metadata,
    Column("career_id", Integer, ForeignKey("careers.career_id"), primary_key=True),
    Column("course_id", Integer, ForeignKey("courses.course_id"), primary_key=True),
)
