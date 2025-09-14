from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

import crud.college as crud_college
from db.deps import get_db
from schema.college import CollegeCreate, CollegeOut

router = APIRouter()


@router.post("/bulk/", response_model=list[CollegeOut], status_code=201)
def create_college_bulk(colleges: list[CollegeCreate], db: Session = Depends(get_db)):
    return crud_college.create_college_bulk(db, colleges)


@router.post("/", response_model=CollegeOut, status_code=201)
def create_college(college: CollegeCreate, db: Session = Depends(get_db)):
    return crud_college.create_college(db, college)


@router.get("/", response_model=list[CollegeOut])
def get_all_colleges(db: Session = Depends(get_db)):
    return crud_college.get_all_colleges(db)


@router.get("/search/", response_model=list[CollegeOut])
def search_college(name: str, db: Session = Depends(get_db)):
    return crud_college.search_college(db, name)


@router.get("/filter/", response_model=list[CollegeOut])
def filter_college(
    city: str | None = None, state: str | None = None, db: Session = Depends(get_db)
):
    return crud_college.filter_college(db, city, state)
