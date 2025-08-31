from datetime import datetime

from pydantic import BaseModel, EmailStr


class StudentBase(BaseModel):
    name: str
    email: EmailStr
    age: int | None = None
    class_name: str | None = None
    city: str | None = None


class StudentCreate(StudentBase):
    password: str


class StudentOut(StudentBase):
    student_id: int
    created_at: datetime

    model_config = {"from_attributes": True}


class StudentLogin(BaseModel):
    email: EmailStr
    password: str
