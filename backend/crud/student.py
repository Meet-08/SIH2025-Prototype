from fastapi import HTTPException
from sqlalchemy.orm import Session

import models.student as model_student
from schema.student import StudentCreate, StudentOut
from utils.hashing import hash_password


def get_student_by_email(db: Session, email: str):
    db_student = (
        db.query(model_student.Student)
        .filter(model_student.Student.email == email)
        .first()
    )
    if not db_student:
        raise HTTPException(status_code=404, detail="Student not found")
    return StudentOut.model_validate(db_student)


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
        return StudentOut.model_validate(db_student)
    except Exception as e:
        db.rollback()
        print(f"Error creating student: {e}")
        raise HTTPException(status_code=500, detail="Failed to create student")
