# MARK XXXIX — Personal JARVIS System

A personalized JARVIS-style desktop assistant for Timothy and ProductiveMind.Ai.

This project is based on the Mark-XXXIX assistant codebase and has been adapted into a safer personal starter system with local profile configuration, secret-safe setup, and clearer operating instructions.

## What it does

- Real-time voice conversation through Gemini Live
- Desktop-style PyQt6 control panel
- Typed command input
- Local file upload handling
- Persistent local memory
- Tool modules for browser control, files, screen/camera processing, reminders, weather, messages, code help, app launching, and computer control
- Personal profile config for operator name, organization, assistant identity, and tone

## Personalized defaults

The profile lives here:

```text
config/user_profile.json
```

Current defaults:

- Assistant: JARVIS
- Version: MARK XXXIX
- Operator: Timothy
- Organization: ProductiveMind.Ai
- Tone: calm, concise, practical, and supportive

You can edit that file any time without touching code.

## Secrets

Do not commit your real API key.

The real runtime file is ignored by git:

```text
config/api_keys.json
```

A safe template is included:

```text
config/api_keys.example.json
```

The app can create `config/api_keys.json` from the setup screen on first launch.

## Quick start

Python 3.11 or 3.12 is recommended.

```bash
python -m venv .venv
# Windows PowerShell:
.venv\Scripts\Activate.ps1
# macOS/Linux:
# source .venv/bin/activate

python -m pip install --upgrade pip
python setup.py
python main.py
```

On Linux you may need system audio/UI packages depending on your desktop environment. On Windows, the Windows-only packages are installed automatically from `requirements.txt` markers.

## Windows desktop shortcut

JARVIS no longer installs an automatic startup task. To launch it manually from your desktop, create a Windows shortcut:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows_create_desktop_shortcut.ps1
```

This creates `JARVIS MARK XXXIX.lnk` on the current user's Desktop. Double-click that shortcut whenever you want to start JARVIS.

## Gemini API key

You need a Gemini API key for the real-time voice model.

On first launch, enter it into the setup overlay. The app stores it locally in:

```text
config/api_keys.json
```

That file is ignored by git.

## Safety notes

This assistant can control your computer. Start with simple commands first:

- "What time is it?"
- "Open Notepad"
- "List files on my desktop"
- "Summarize this uploaded PDF"

Be careful with commands that delete files, send messages, change settings, or run code.

## Project layout

```text
main.py                  Main Gemini Live loop and tool router
ui.py                    PyQt6 desktop interface
app_profile.py           Personal profile loader
core/prompt.txt          Assistant behavior protocol
config/user_profile.json Personal non-secret profile
config/api_keys.json     Local secret config, ignored by git
actions/                 Tool/action modules
memory/                  Local long-term memory manager
scripts/validate_project.py  Local validation helper
scripts/windows_run.ps1     Windows manual launcher
scripts/windows_create_desktop_shortcut.ps1  Windows desktop shortcut creator
```

## Validate before committing

```bash
python scripts/validate_project.py
```

This checks Python syntax, required files, secret hygiene, and JSON config templates.

## GitHub publishing

Create a repository under your own GitHub account first, then publish with the helper script:

```bash
export GITHUB_REMOTE_URL="https://github.com/YOUR_USERNAME/Mark-XXXIX.git"
export GITHUB_TOKEN="YOUR_FINE_GRAINED_TOKEN"
python scripts/push_to_github.py
```

The helper keeps the token out of the git remote URL and removes its temporary credential helper after pushing.

If the remote is private, the token must have access to that specific repo.
