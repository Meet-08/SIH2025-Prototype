from typing import Dict

from pydantic import BaseModel


class RecommendationRequest(BaseModel):
    answers: Dict[str, int]


class RecommendationResult(BaseModel):
    recommended_stream: str
    ai_reasoning: str
