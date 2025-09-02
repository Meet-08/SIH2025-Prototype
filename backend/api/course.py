from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

import crud.course as crud_course
from db.deps import get_db
from schema.course import CourseBase, CourseResponse

router = APIRouter()


@router.post("/", response_model=CourseResponse)
def create_course(course: CourseBase, db: Session = Depends(get_db)):
    return crud_course.create_course(db, course)


@router.get("/", response_model=list[CourseResponse])
def get_all_courses(db: Session = Depends(get_db)):
    return crud_course.get_all_courses(db)


@router.get("/{course_id}", response_model=CourseResponse)
def get_course_by_id(course_id: int, db: Session = Depends(get_db)):
    return crud_course.get_course_by_id(db, course_id)
