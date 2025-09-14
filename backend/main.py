from fastapi import FastAPI

from api import (
    career,
    college,
    course,
    course_career,
    recommendation,
    scholarship,
    student,
)
from db.database import Base, engine

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(student.router, prefix="/v1/api/student", tags=["students"])
app.include_router(course.router, prefix="/v1/api/course", tags=["courses"])
app.include_router(career.router, prefix="/v1/api/career", tags=["careers"])
app.include_router(
    course_career.router, prefix="/v1/api/course_career", tags=["course_career"]
)
app.include_router(recommendation.router, prefix="/v1/api", tags=["recommendation"])
app.include_router(college.router, prefix="/v1/api/college", tags=["colleges"])
app.include_router(
    scholarship.router, prefix="/v1/api/scholarship", tags=["scholarships"]
)
