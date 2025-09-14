from sqlalchemy.orm import Session

from models import college as models_college
from schema.college import CollegeCreate


def create_college_bulk(db: Session, colleges: list[CollegeCreate]):
    db_colleges = [
        models_college.College(**college.model_dump()) for college in colleges
    ]
    db.add_all(db_colleges)
    db.commit()
    return db_colleges


def create_college(db: Session, college: CollegeCreate):
    db_college = models_college.College(**college.model_dump())
    db.add(db_college)
    db.commit()
    db.refresh(db_college)
    return db_college


def get_all_colleges(db: Session):
    return db.query(models_college.College).all()


def search_college(db: Session, name: str):
    return (
        db.query(models_college.College)
        .filter(models_college.College.name.ilike(f"%{name}%"))
        .all()
    )


def filter_college(db: Session, city: str | None = None, state: str | None = None):
    query = db.query(models_college.College)
    if city:
        query = query.filter(models_college.College.location == city)
    if state:
        query = query.filter(models_college.College.state == state)
    return query.all()
