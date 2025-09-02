from pydantic import BaseModel

from schema.course import CourseResponse


class CareerBase(BaseModel):
    career_name: str
    sector: str
    higher_study_options: list[str]
    exam_options: list[str]


class CareerResponse(CareerBase):
    career_id: int
    courses: list[CourseResponse] = []

    model_config = {"from_attributes": True}
