from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

import crud.career as crud_career
from db.deps import get_db
from schema.career import CareerBase

router = APIRouter()


@router.post("/", response_model=CareerBase)
def create_career(career: CareerBase, db: Session = Depends(get_db)):
    return crud_career.create_career(db=db, career=career)


@router.get("/", response_model=list[CareerBase])
def get_all_careers(db: Session = Depends(get_db)):
    return crud_career.get_all_careers(db=db)


def get_career_by_id(career_id: int, db: Session = Depends(get_db)):
    return crud_career.get_career_by_id(db=db, career_id=career_id)
