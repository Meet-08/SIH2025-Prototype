from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from crud import student as crud_student
from db.deps import get_db
from schema.student import StudentCreate, StudentLogin, StudentOut
from utils.hashing import verify_password

router = APIRouter()


@router.post("/register", response_model=StudentOut, status_code=201)
def create_student(student: StudentCreate, db: Session = Depends(get_db)):
    print("Creating student:", student)
    db_student = crud_student.get_student_by_email(db, email=student.email)

    if db_student:
        raise HTTPException(status_code=400, detail="Student already exists")

    return crud_student.create_student(db, student)


@router.post("/login", response_model=StudentOut)
def login_student(student: StudentLogin, db: Session = Depends(get_db)):
    print("Logging in student:", student)
    db_student = crud_student.get_student_by_email(db, email=student.email)
    if not db_student:
        raise HTTPException(status_code=404, detail="Student not found")

    hashed_password = (
        db_student.password.value
        if hasattr(db_student.password, "value")
        else db_student.password
    )
    if not verify_password(student.password, str(hashed_password)):
        raise HTTPException(status_code=400, detail="Invalid email or password")
    return StudentOut.model_validate(db_student)
