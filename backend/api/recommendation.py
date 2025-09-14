from fastapi import APIRouter

from schema.recommendation import RecommendationRequest, RecommendationResult
from utils.gemini import generate_career_explanation

router = APIRouter()


@router.post("/recommendation", response_model=RecommendationResult, status_code=200)
async def get_recommendation(payload: RecommendationRequest):
    recommended_stream, explanation = generate_career_explanation(payload.answers)
    return RecommendationResult(
        recommended_stream=recommended_stream,
        ai_reasoning=explanation,
    )
