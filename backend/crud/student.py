from fastapi import HTTPException
from sqlalchemy.orm import Session

import models.student as model_student
from schema.student import StudentCreate
from utils.hashing import hash_password


def get_student_by_email(db: Session, email: str):
    return (
        db.query(model_student.Student)
        .filter(model_student.Student.email == email)
        .first()
    )


def create_student(db: Session, student: StudentCreate):
    try:
        db_student = model_student.Student(
            name=student.name,
            email=student.email,
            age=student.age,
            class_name=student.class_name,
            city=student.city,
            password=hash_password(student.password),
        )
        db.add(db_student)
        db.commit()
        db.refresh(db_student)
        return db_student
    except Exception as e:
        db.rollback()
        print(f"Error creating student: {e}")
        raise HTTPException(status_code=500, detail="Failed to create student")
