from __future__ import annotations

import json
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
PROFILE_PATH = BASE_DIR / "config" / "user_profile.json"

DEFAULT_PROFILE = {
    "assistant_name": "JARVIS",
    "assistant_full_name": "Just A Rather Very Intelligent System",
    "assistant_version": "MARK XXXIX",
    "operator_name": "Timothy",
    "operator_title": "Founder and Operator of ProductiveMind.Ai",
    "organization": "ProductiveMind.Ai",
    "tone": "calm, concise, practical, and supportive",
    "mission": "Help Timothy operate ProductiveMind.Ai, manage creative technology workflows, and complete computer tasks safely.",
    "footer_brand": "ProductiveMind.Ai · MARK XXXIX · PERSONAL ASSISTANT",
}


def load_profile() -> dict:
    """Load local assistant profile without requiring secrets."""
    profile = DEFAULT_PROFILE.copy()
    if PROFILE_PATH.exists():
        try:
            data = json.loads(PROFILE_PATH.read_text(encoding="utf-8-sig"))
            if isinstance(data, dict):
                for key, value in data.items():
                    if value not in (None, ""):
                        profile[key] = value
        except Exception as exc:
            print(f"[Profile] Failed to load {PROFILE_PATH}: {exc}")
    return profile


PROFILE = load_profile()
ASSISTANT_NAME = PROFILE["assistant_name"]
ASSISTANT_FULL_NAME = PROFILE["assistant_full_name"]
ASSISTANT_VERSION = PROFILE["assistant_version"]
OPERATOR_NAME = PROFILE["operator_name"]
ORGANIZATION = PROFILE["organization"]
FOOTER_BRAND = PROFILE["footer_brand"]


def system_identity_block() -> str:
    return f"""[PERSONAL ASSISTANT PROFILE]
Assistant name: {PROFILE['assistant_name']}
Full name: {PROFILE['assistant_full_name']}
Version: {PROFILE['assistant_version']}
Primary operator: {PROFILE['operator_name']}
Operator role: {PROFILE['operator_title']}
Organization: {PROFILE['organization']}
Tone: {PROFILE['tone']}
Mission: {PROFILE['mission']}
"""
