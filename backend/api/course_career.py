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
