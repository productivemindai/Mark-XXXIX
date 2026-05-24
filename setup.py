import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent

print("Installing requirements...")
subprocess.run([sys.executable, "-m", "pip", "install", "-r", str(ROOT / "requirements.txt")], check=True)

print("Installing Playwright browsers...")
subprocess.run([sys.executable, "-m", "playwright", "install"], check=True)

print("\nSetup complete. Run 'python main.py' to start your personal JARVIS system.")
print("If this is your first run, the app will ask for your Gemini API key and OS.")
