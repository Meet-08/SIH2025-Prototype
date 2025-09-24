from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from crud import student as crud_student
from db.deps import get_db
from schema.student import StudentCreate, StudentLogin, StudentOut
from utils.hashing import verify_password

router = APIRouter(prefix="/v1/api/student")


@router.post("/register", response_model=StudentOut, status_code=201)
def create_student(student: StudentCreate, db: Session = Depends(get_db)):
    existing = crud_student.get_student_by_email(db, email=student.email)
    if existing:
        raise HTTPException(status_code=400, detail="Student already exists")

    db_student = crud_student.create_student(db, student)
    return StudentOut.model_validate(db_student)


@router.post("/login", response_model=StudentOut)
def login_student(student: StudentLogin, db: Session = Depends(get_db)):
    db_student = crud_student.get_student_by_email(db, email=student.email)
    if not db_student:
        raise HTTPException(status_code=404, detail="Student not found")

    raw_pw = getattr(db_student, "password", None)

    if not verify_password(student.password, str(raw_pw)):
        raise HTTPException(status_code=400, detail="Invalid email or password")

    return StudentOut.model_validate(db_student)


@router.get("/me/{email}", response_model=StudentOut)
def get_student(email: str, db: Session = Depends(get_db)):
    db_student = crud_student.get_student_by_email(db, email=email)
    if not db_student:
        raise HTTPException(status_code=404, detail="Student not found")
    return StudentOut.model_validate(db_student)
