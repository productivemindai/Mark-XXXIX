from __future__ import annotations

import compileall
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REQUIRED_FILES = [
    "main.py",
    "ui.py",
    "app_profile.py",
    "core/prompt.txt",
    "config/user_profile.json",
    "config/api_keys.example.json",
    "requirements.txt",
    ".gitignore",
]


def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)


def check_required_files() -> None:
    for rel in REQUIRED_FILES:
        if not (ROOT / rel).exists():
            fail(f"Missing required file: {rel}")
    print("OK: required files present")


def check_json() -> None:
    for rel in ["config/user_profile.json", "config/api_keys.example.json"]:
        try:
            json.loads((ROOT / rel).read_text(encoding="utf-8-sig"))
        except Exception as exc:
            fail(f"Invalid JSON in {rel}: {exc}")
    print("OK: JSON config templates valid")


def check_no_example_secret() -> None:
    example = json.loads((ROOT / "config/api_keys.example.json").read_text(encoding="utf-8-sig"))
    key = example.get("gemini_api_key", "")
    if key and "PASTE_" not in key:
        fail("config/api_keys.example.json appears to contain a real key")
    real_config = ROOT / "config" / "api_keys.json"
    if real_config.exists():
        print("WARN: config/api_keys.json exists locally; .gitignore should prevent committing it")
    print("OK: example config does not contain a real API key")


def check_gitignore() -> None:
    text = (ROOT / ".gitignore").read_text(encoding="utf-8")
    for required in ["config/api_keys.json", "memory/long_term.json", ".venv/"]:
        if required not in text:
            fail(f".gitignore missing {required}")
    print("OK: private runtime files ignored")


def check_compile() -> None:
    ok = compileall.compile_dir(str(ROOT), quiet=1, maxlevels=10)
    if not ok:
        fail("Python syntax check failed")
    print("OK: Python syntax check passed")


def main() -> None:
    print(f"Validating project at {ROOT}")
    check_required_files()
    check_json()
    check_no_example_secret()
    check_gitignore()
    check_compile()
    print("Validation complete")


if __name__ == "__main__":
    main()
