from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

import crud.scholarship as crud_scholarship
from db.deps import get_db
from schema.scholarship import ScholarshipCreate, ScholarshipOut

router = APIRouter()


@router.post("/bulk", response_model=list[ScholarshipOut])
def create_scholarship_bulk(
    scholarships: list[ScholarshipCreate], db: Session = Depends(get_db)
):
    return crud_scholarship.create_scholarship_bulk(db, scholarships)


@router.post("/", response_model=ScholarshipOut)
def create_scholarship(scholarship: ScholarshipCreate, db: Session = Depends(get_db)):
    return crud_scholarship.create_scholarship(db, scholarship)


@router.get("/", response_model=list[ScholarshipOut])
def get_all_scholarships(db: Session = Depends(get_db)):
    return crud_scholarship.get_all_scholarships(db)


@router.get("/search/", response_model=list[ScholarshipOut])
def search_scholarship(name: str, db: Session = Depends(get_db)):
    return crud_scholarship.search_scholarship(db, name)


@router.get("/filter/", response_model=list[ScholarshipOut])
def filter_scholarship(
    eligibility: str | None = None,
    start_after: str | None = None,
    end_before: str | None = None,
    db: Session = Depends(get_db),
):
    return crud_scholarship.filter_scholarship(db, eligibility, start_after, end_before)
