from typing import List, Optional

from pydantic import BaseModel


class DegreeInfo(BaseModel):
    degree_name: str
    cutoff: Optional[int] = None
    cutoff_stream: Optional[str] = None


class CollegeBase(BaseModel):
    college_name: str
    location: str
    district: str
    state: str
    facilities: List[str]
    degrees: List[DegreeInfo]


class CollegeCreate(CollegeBase):
    pass


class CollegeOut(CollegeBase):
    college_id: int

    model_config = {"from_attributes": True}
