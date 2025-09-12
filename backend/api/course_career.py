from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from db.deps import get_db
from mock_data import roadmaps
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


@router.get("/roadmaps/{career_field}", response_model=dict)
def get_roadmap_by_field(career_field: str):
    normalized_field = career_field.strip().lower()
    print(normalized_field)
    for r in roadmaps:
        roadmap_field = r.get("careerField", "").strip().lower()
        if roadmap_field == normalized_field:
            return r

    raise HTTPException(
        status_code=404, detail=f"No roadmap found for '{career_field}'"
    )
