#!/bin/bash

# ==============================================================================
# Claude Code -> Gemma 4 Setup Script (Enterprise v2.6)
# Description: Configures Claude Code to use Gemma 4 via Claude Code Router (CCR)
# ==============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}================================================================${NC}"
echo -e "${GREEN}     🚀 Claude Code -> Gemma 4 One-Click Setup Tool ${NC}"
echo -e "${GREEN}================================================================${NC}"

# 1. Interactive API Key Acquisition
echo -e "\n${YELLOW}Step 1: Authentication${NC}"
while [[ -z "$MY_API_KEY" ]]; do
    echo -n "🔑 Please enter your Google AI Studio API Key: "
    read MY_API_KEY < /dev/tty
    if [[ -z "$MY_API_KEY" ]]; then
        echo -e "${RED}❌ Error: API Key cannot be empty. Please try again!${NC}"
    fi
done

# 2. Model Version Selection
echo -e "\n${YELLOW}Step 2: Model Selection${NC}"
echo "Please select the model version you wish to use:"
echo "1) Gemma-4-31B-IT (Powerful, Recommended)"
echo "2) Gemma-4-26B-A4B-IT (Faster, Lightweight)"
read -p "Enter choice [1 or 2]: " MODEL_CHOICE < /dev/tty

if [[ "$MODEL_CHOICE" == "2" ]]; then
    MY_MODEL="models/gemma-4-26b-a4b-it"
    echo -e "✅ Selected: ${GREEN}Gemma-4-26B${NC}"
else
    MY_MODEL="models/gemma-4-31b-it"
    echo -e "✅ Selected: ${GREEN}Gemma-4-31B${NC}"
fi

# 3. Install Necessary Tools (Sudo-aware & Silenced)
echo -e "\n${YELLOW}Step 3: Installing Tools${NC}"
echo "Installing @anthropic-ai/claude-code and @musistudio/claude-code-router..."

npm install -g --engine-strict=false --no-fund --no-audit @anthropic-ai/claude-code @musistudio/claude-code-router 2>/dev/null

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}ℹ️ Normal installation failed. Requesting sudo privileges...${NC}"
    sudo npm install -g --engine-strict=false --no-fund --no-audit @anthropic-ai/claude-code @musistudio/claude-code-router 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Installation failed even with sudo.${NC}"
        exit 1
    fi
fi
echo -e "✅ Tools installed successfully."

# 4. Create Config Directory and Write JSON
echo -e "\n${YELLOW}Step 4: Writing Configuration${NC}"
CONFIG_DIR="$HOME/.claude-code-router"
CONFIG_FILE="$CONFIG_DIR/config.json"

mkdir -p "$CONFIG_DIR"
cat <<EOF > "$CONFIG_FILE"
{
  "LOG": true,
  "LOG_LEVEL": "debug",
  "Providers": [
    {
      "name": "google",
      "api_base_url": "https://generativelanguage.googleapis.com/v1beta/models/",
      "api_key": "$MY_API_KEY",
      "models": ["$MY_MODEL"],
      "transformer": {
        "use": ["gemini"]
      }
    }
  ],
  "Router": {
    "default": "google,$MY_MODEL",
    "background": "google,$MY_MODEL",
    "think": "google,$MY_MODEL",
    "longContext": "google,$MY_MODEL"
  }
}
EOF
echo -e "✅ Config file written to: ${GREEN}$CONFIG_FILE${NC}"

# 5. Setup Shell Environment Variables (Forcing Bypass of Login Screen)
echo -e "\n${YELLOW}Step 5: Configuring Shell Environment${NC}"
SHELL_CONFIG=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    [ -f "$HOME/.zshrc" ] && SHELL_CONFIG="$HOME/.zshrc"
    [ -f "$HOME/.bashrc" ] && SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    # 1. Force Base URL to Local Proxy
    if ! grep -q "ANTHROPIC_BASE_URL" "$SHELL_CONFIG"; then
        echo 'export ANTHROPIC_BASE_URL="http://localhost:4000"' >> "$SHELL_CONFIG"
        echo -e "✅ Added ANTHROPIC_BASE_URL to ${GREEN}$SHELL_CONFIG${NC}"
    fi
    
    # 2. Inject Dummy API Key to bypass login screen entirely
    if ! grep -q "ANTHROPIC_API_KEY" "$SHELL_CONFIG"; then
        echo 'export ANTHROPIC_API_KEY="sk-ant-api03-dummy-key-12345"' >> "$SHELL_CONFIG"
        echo -e "✅ Added ANTHROPIC_API_KEY to ${GREEN}$SHELL_CONFIG${NC}"
    fi
    
    if ! grep -q "ccr activate" "$SHELL_CONFIG"; then
        echo 'eval "$(ccr activate)"' >> "$SHELL_CONFIG"
        echo -e "✅ Added ccr activation to ${GREEN}$SHELL_CONFIG${NC}"
    fi
else
    echo -e "${RED}⚠️ Could not find a suitable shell config file.${NC}"
fi

# 6. Activate Immediately
echo -e "\n${YELLOW}Step 6: Activating Environment${NC}"
export ANTHROPIC_BASE_URL="http://localhost:4000"
export ANTHROPIC_API_KEY="sk-ant-api03-dummy-key-12345"
eval "$(ccr activate)"

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}🎉 Setup Complete! You can now just type 'claude' to start!${NC}"
echo -e "${GREEN}================================================================${NC}"
echo -e "${YELLOW}🚀 The login screen has been bypassed automatically.${NC}"
