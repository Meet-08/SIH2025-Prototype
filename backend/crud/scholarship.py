from sqlalchemy.orm import Session

from models import scholarship as scholarship_model
from schema.scholarship import ScholarshipCreate


def create_scholarship_bulk(db: Session, scholarships: list[ScholarshipCreate]):
    db_scholarships = [
        scholarship_model.Scholarship(**scholarship.model_dump())
        for scholarship in scholarships
    ]
    db.add_all(db_scholarships)
    db.commit()
    for scholarship in db_scholarships:
        db.refresh(scholarship)
    return db_scholarships


def create_scholarship(db: Session, scholarship: ScholarshipCreate):
    db_scholarship = scholarship_model.Scholarship(**scholarship.model_dump())
    db.add(db_scholarship)
    db.commit()
    db.refresh(db_scholarship)
    return db_scholarship


def get_all_scholarships(db: Session):
    return db.query(scholarship_model.Scholarship).all()


def search_scholarship(db: Session, name: str):
    return (
        db.query(scholarship_model.Scholarship)
        .filter(scholarship_model.Scholarship.scholarship_name.ilike(f"%{name}%"))
        .all()
    )


def filter_scholarship(
    db: Session,
    eligibility: str | None = None,
    start_after: str | None = None,
    end_before: str | None = None,
):
    query = db.query(scholarship_model.Scholarship)
    if eligibility:
        query = query.filter(
            scholarship_model.Scholarship.eligibility.ilike(f"%{eligibility}%")
        )
    if start_after:
        query = query.filter(scholarship_model.Scholarship.starting_date >= start_after)
    if end_before:
        query = query.filter(scholarship_model.Scholarship.ending_date <= end_before)
    return query.all()
