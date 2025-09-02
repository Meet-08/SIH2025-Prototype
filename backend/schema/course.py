from pydantic import BaseModel


class CourseBase(BaseModel):
    course_name: str
    stream: str
    description: str


class CourseResponse(CourseBase):
    course_id: int

    model_config = {"from_attributes": True}
