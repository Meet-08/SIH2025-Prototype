from sqlalchemy import JSON, Column, Date, Float, Integer, String

from db.database import Base


class Scholarship(Base):
    __tablename__ = "scholarships"

    scholarship_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    scholarship_name = Column(String, index=True)
    starting_date = Column(Date)
    ending_date = Column(Date)
    amount = Column(Float)
    eligibility = Column(JSON)
    required_documents = Column(JSON)
