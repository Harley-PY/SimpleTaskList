#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/Harley-PY/SimpleTaskList.git"
APP_NAME="simpletodo"
INSTALL_DIR="$HOME/.${APP_NAME}"
MAIN_SCRIPT="main.py"

echo "🚀 Starting installation for $APP_NAME..."

# --- Check for and install Git ---
install_git() {
  echo "🔍 Checking for Git..."
  if command -v git >/dev/null 2>&1; then
    echo "✅ Git is already installed."
  else
    echo "⚙️ Installing Git..."
    sudo apt update -y
    sudo apt install -y git
    echo "✅ Git installed."
  fi
}

# --- Check for and install Python ---
install_python() {
  echo "🔍 Checking for Python..."
  if command -v python3 >/dev/null 2>&1; then
    echo "✅ Python is already installed."
  else
    echo "⚙️ Installing Python..."
    sudo apt update -y
    sudo apt install -y python3 python3-pip
    echo "✅ Python installed."
  fi
}

install_git
install_python

# --- Clone or update repo ---
if [ -d "$INSTALL_DIR" ]; then
  echo "📦 Updating $APP_NAME..."
  git -C "$INSTALL_DIR" pull --quiet
else
  echo "⬇️ Cloning $APP_NAME..."
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

# --- Create launcher script ---
LAUNCHER_PATH="$INSTALL_DIR/$APP_NAME"
echo "#!/usr/bin/env bash" > "$LAUNCHER_PATH"
echo "python3 \"\$HOME/.${APP_NAME}/${MAIN_SCRIPT}\" \"\$@\"" >> "$LAUNCHER_PATH"
chmod +x "$LAUNCHER_PATH"
echo "✅ Created launcher: $LAUNCHER_PATH"

# --- Add install folder to PATH if not already ---
SHELL_RC="$HOME/.bashrc"
[ -n "$ZSH_VERSION" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q "$INSTALL_DIR" "$SHELL_RC" 2>/dev/null; then
  echo "" >> "$SHELL_RC"
  echo "# Added by $APP_NAME installer" >> "$SHELL_RC"
  echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
  echo "✅ Added $APP_NAME to PATH in $SHELL_RC"
else
  echo "ℹ️ $APP_NAME already in PATH."
fi

echo ""
echo "🎉 Installation complete!"
echo "➡️ Restart your terminal, then run: $APP_NAME"
