from collections import defaultdict

from google import genai
from google.genai import types

from core.config import settings
from mock_data import QUESTION_SET
from utils.scoring_rules import scoring_rules

client = genai.Client(api_key=settings.gemini_api_key)


def build_system_prompt(user_answers: dict, recommended_stream: str) -> str:
    readable_qa = []
    for q_index, option_index in user_answers.items():
        question_text = QUESTION_SET.get(int(q_index), "Unknown question")
        readable_qa.append(
            f"{int(q_index) + 1}. {question_text} → Selected Option: {option_index}"
        )

    answers_text = "\n".join(readable_qa)

    prompt = f"""
You are an expert career counselor.

A student completed an aptitude test consisting of 15 questions. Below are the questions and the selected answers:

{answers_text}

Based on these answers, the recommended career stream is: '{recommended_stream}'.

Your task is to explain in simple and friendly language:
- Why this stream is a good fit for the student.
- What are some typical career opportunities the student can explore in this stream.
- Provide encouragement and highlight key strengths inferred from the answers.

Keep the explanation concise (under 200 words) and easy to understand by a student.
"""

    return prompt


def recommend_stream(user_answers: dict) -> str:
    stream_scores = defaultdict(int)

    for q_index, selected_option in user_answers.items():
        q_index = int(q_index)
        selected_option = int(selected_option)

        score_map = scoring_rules.get(q_index, {}).get(selected_option, {})

        for stream, score in score_map.items():
            stream_scores[stream] += score

    if not stream_scores:
        return "Unknown"

    recommended_stream = max(stream_scores, key=stream_scores.get)  # type: ignore
    return recommended_stream


def generate_career_explanation(user_answers: dict):
    recommended_stream = recommend_stream(user_answers)
    system_prompt = build_system_prompt(user_answers, recommended_stream)

    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=system_prompt,
        config=types.GenerateContentConfig(
            thinking_config=types.ThinkingConfig(thinking_budget=0)  # Disables thinking
        ),
    )
    explanation = response.candidates[0].content.parts[0].text.strip()  # type: ignore
    return recommended_stream, explanation
