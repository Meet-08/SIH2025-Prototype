from datetime import date

from pydantic import BaseModel


class ScholarshipBase(BaseModel):
    scholarship_name: str
    starting_date: date
    ending_date: date
    amount: float
    eligibility: list[str]
    required_documents: list[str]


class ScholarshipCreate(ScholarshipBase):
    pass


class ScholarshipOut(ScholarshipBase):
    scholarship_id: int
    model_config = {"from_attributes": True}
