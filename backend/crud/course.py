from fastapi import HTTPException
from sqlalchemy.orm import Session

import models.course as model_course
from schema.course import CourseBase, CourseResponse


def create_course(
    db: Session,
    course: CourseBase,
) -> CourseResponse:
    try:
        db_course = model_course.Course(**course.model_dump())
        db.add(db_course)
        db.commit()
        db.refresh(db_course)
        return CourseResponse.model_validate(db_course)
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))


def get_all_courses(db: Session) -> list[CourseResponse]:
    try:
        courses = db.query(model_course.Course).all()
        return [CourseResponse.model_validate(course) for course in courses]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


def get_course_by_id(db: Session, course_id: int) -> CourseResponse:
    course = (
        db.query(model_course.Course)
        .filter(model_course.Course.id == course_id)
        .first()
    )
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    return CourseResponse.model_validate(course)
