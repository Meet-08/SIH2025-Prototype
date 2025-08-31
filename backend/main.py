from fastapi import FastAPI

from api import student
from db.database import Base, engine

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(student.router, prefix="/student", tags=["students"])
