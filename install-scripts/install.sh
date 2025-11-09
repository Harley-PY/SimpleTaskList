#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/Harley-PY/SimpleTaskList.git"
APP_NAME="simpletodo"
INSTALL_DIR="$HOME/.${APP_NAME}"

# --- Function to install Python ---
install_python() {
  echo "🐍 Checking for Python..."
  if command -v python3 >/dev/null 2>&1; then
    echo "✅ Python is already installed."
    return
  fi
  echo "⚙️ Installing Python..."
  if [ "$(uname)" = "Darwin" ]; then
    # macOS
    if ! command -v brew >/dev/null 2>&1; then
      echo "🍺 Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
    fi
    brew install python
  else
    # Linux (Debian/Ubuntu-like)
    sudo apt update -y && sudo apt install -y python3 python3-pip
  fi
}

# --- Clone or update repo ---
if [ -d "$INSTALL_DIR" ]; then
  echo "📦 Updating $APP_NAME..."
  git -C "$INSTALL_DIR" pull --quiet
else
  echo "⬇️ Cloning $APP_NAME..."
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

# --- Ensure Python installed ---
install_python

# --- Run setup ---
cd "$INSTALL_DIR"
python3 setup.py

# --- Add to PATH if not already ---
SHELL_RC="$HOME/.bashrc"
[ -n "$ZSH_VERSION" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q "$INSTALL_DIR" "$SHELL_RC" 2>/dev/null; then
  echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
  echo "✅ Added $APP_NAME to PATH in $SHELL_RC"
fi

echo "🎉 Installation complete! Run '$APP_NAME' after restarting your terminal."
