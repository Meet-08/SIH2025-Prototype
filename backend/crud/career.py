from fastapi import HTTPException
from sqlalchemy.orm import Session

import models.career as model_career
from schema.career import CareerBase, CareerResponse


def create_career(db: Session, career: CareerBase) -> CareerResponse:
    db_career = model_career.Career(**career.model_dump())
    db.add(db_career)
    db.commit()
    db.refresh(db_career)
    return CareerResponse.model_validate(db_career)


def get_all_careers(db: Session) -> list[CareerResponse]:
    db_careers = db.query(model_career.Career).all()
    return [CareerResponse.model_validate(career) for career in db_careers]


def get_career_by_id(db: Session, career_id: int) -> CareerResponse:
    db_career = (
        db.query(model_career.Career)
        .filter(model_career.Career.id == career_id)
        .first()
    )
    if not db_career:
        raise HTTPException(status_code=404, detail="Career not found")
    return CareerResponse.model_validate(db_career)
