#!/usr/bin/env python3
from __future__ import annotations

import getpass
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REMOTE = "https://github.com/FaithMakes/Mark-XXXIX.git"
OWNER = "FaithMakes"
REPO = "Mark-XXXIX"


def run(cmd: list[str], *, env: dict | None = None, check: bool = True) -> subprocess.CompletedProcess:
    print("$ " + " ".join(cmd if cmd[0] != "git" else cmd))
    result = subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True, env=env)
    if result.stdout:
        print(result.stdout, end="")
    if result.stderr:
        print(result.stderr, end="", file=sys.stderr)
    if check and result.returncode != 0:
        raise SystemExit(result.returncode)
    return result


def main() -> None:
    print(f"Publishing {ROOT} to {OWNER}/{REPO}")
    token = os.environ.get("GITHUB_TOKEN") or getpass.getpass("GitHub token: ").strip()
    if not token:
        raise SystemExit("No token provided.")

    run(["git", "branch", "-M", "main"])
    remotes = run(["git", "remote"], check=False).stdout.split()
    if "origin" not in remotes:
        run(["git", "remote", "add", "origin", REMOTE])
    else:
        run(["git", "remote", "set-url", "origin", REMOTE])

    # Use an askpass helper so the token is not embedded in the remote URL or printed.
    askpass = ROOT / ".git" / "github_askpass.sh"
    askpass.write_text(
        "#!/usr/bin/env bash\n"
        "case \"$1\" in\n"
        "  *Username*) echo x-access-token ;;\n"
        "  *Password*) printf '%s' \"$GITHUB_TOKEN\" ;;\n"
        "  *) echo ;;\n"
        "esac\n",
        encoding="utf-8",
    )
    askpass.chmod(0o700)

    env = os.environ.copy()
    env["GITHUB_TOKEN"] = token
    env["GIT_ASKPASS"] = str(askpass)
    env["GIT_TERMINAL_PROMPT"] = "0"

    try:
        run(["git", "status", "--short", "--branch"])
        run(["git", "push", "-u", "origin", "main"], env=env)
        print("Publish complete.")
    finally:
        try:
            askpass.unlink()
        except FileNotFoundError:
            pass


if __name__ == "__main__":
    main()
