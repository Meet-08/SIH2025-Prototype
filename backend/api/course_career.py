from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from db.deps import get_db
from models.career import Career
from models.course import Course

router = APIRouter()


@router.post("/map")
def map_course_to_career(
    career_name: str, course_name: str, db: Session = Depends(get_db)
):
    career = db.query(Career).filter(Career.career_name == career_name).first()
    course = db.query(Course).filter(Course.course_name == course_name).first()
    if career and course:
        career.courses.append(course)
        db.commit()
        db.refresh(career)
        return career


@router.get("/roadmap/{stream}")
def get_stream_roadmap(stream: str, db: Session = Depends(get_db)):
    courses = db.query(Course).filter(Course.stream == stream).all()
    return {
        "stream": stream,
        "courses": [
            {
                "course_id": course.course_id,
                "course_name": course.course_name,
                "description": course.description,
                "careers": [
                    {
                        "career_id": career.career_id,
                        "career_name": career.career_name,
                        "sector": career.sector,
                        "higher_study_options": career.higher_study_options,
                        "exam_options": career.exam_options,
                    }
                    for career in course.careers
                ],
            }
            for course in courses
        ],
    }
