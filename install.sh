#!/bin/bash

# =============================================================================
# VS Code AI Setup - Installation Script (macOS/Linux)
# =============================================================================

set -e

echo "🚀 VS Code AI Setup Installer"
echo "=============================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Check prerequisites
check_prerequisites() {
    info "Checking prerequisites..."
    
    # Node.js
    if ! command -v node &> /dev/null; then
        error "Node.js is not installed. Install it from https://nodejs.org/"
    fi
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        error "Node.js 18+ is required. Current version: $(node -v)"
    fi
    info "Node.js $(node -v) ✓"
    
    # npm
    if ! command -v npm &> /dev/null; then
        error "npm is not installed"
    fi
    info "npm $(npm -v) ✓"
    
    # Git
    if ! command -v git &> /dev/null; then
        error "Git is not installed"
    fi
    info "Git $(git --version | cut -d' ' -f3) ✓"
    
    echo ""
}

# Remove unwanted AI extensions from VS Code
cleanup_vscode() {
    info "Checking for unwanted VS Code extensions..."
    
    if command -v code &> /dev/null; then
        BLACKBOX=$(code --list-extensions 2>/dev/null | grep -i "blackbox" || true)
        if [ -n "$BLACKBOX" ]; then
            warn "Found Blackbox extension: $BLACKBOX"
            read -p "Do you want to uninstall it? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                code --uninstall-extension "$BLACKBOX"
                info "Blackbox uninstalled ✓"
            fi
        else
            info "No Blackbox extension found ✓"
        fi
    else
        warn "VS Code CLI not found. Skipping extension cleanup."
    fi
    
    echo ""
}

# Install Claude Code
install_claude_code() {
    info "Installing Claude Code..."
    
    if command -v claude &> /dev/null; then
        info "Claude Code already installed: $(claude --version)"
        read -p "Do you want to update it? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            npm update -g @anthropic-ai/claude-code
        fi
    else
        npm install -g @anthropic-ai/claude-code
        info "Claude Code installed ✓"
    fi
    
    echo ""
}

# Install Claude Code Router
install_ccr() {
    info "Installing Claude Code Router..."
    
    if command -v ccr &> /dev/null; then
        info "CCR already installed"
    else
        npm install -g @musistudio/claude-code-router
        info "Claude Code Router installed ✓"
    fi
    
    # Create config directory
    mkdir -p ~/.claude-code-router
    
    if [ ! -f ~/.claude-code-router/config.json ]; then
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        if [ -f "$SCRIPT_DIR/config/ccr-config.json" ]; then
            info "Copying CCR config template..."
            cp "$SCRIPT_DIR/config/ccr-config.json" ~/.claude-code-router/config.json
            warn "Edit ~/.claude-code-router/config.json with your API keys"
        fi
    else
        info "CCR config already exists"
    fi
    
    echo ""
}

# Install Ollama
install_ollama() {
    read -p "Do you want to install Ollama for local models? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info "Installing Ollama..."
        
        if command -v ollama &> /dev/null; then
            info "Ollama already installed"
        else
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS
                if command -v brew &> /dev/null; then
                    brew install ollama
                else
                    warn "Homebrew not found. Install Ollama from https://ollama.com/"
                fi
            else
                # Linux
                curl -fsSL https://ollama.com/install.sh | sh
            fi
            info "Ollama installed ✓"
        fi
        
        # Pull recommended model
        read -p "Do you want to download qwen2.5-coder:7b (~4.5GB)? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            info "Downloading qwen2.5-coder:7b..."
            ollama pull qwen2.5-coder:7b
            info "Model downloaded ✓"
        fi
    fi
    
    echo ""
}

# Setup shell configuration
setup_shell() {
    info "Setting up shell configuration..."
    
    SHELL_RC=""
    if [ -f ~/.zshrc ]; then
        SHELL_RC=~/.zshrc
    elif [ -f ~/.bashrc ]; then
        SHELL_RC=~/.bashrc
    fi
    
    if [ -n "$SHELL_RC" ]; then
        # Check if already configured
        if grep -q "ccr activate" "$SHELL_RC" 2>/dev/null; then
            info "Shell already configured ✓"
        else
            cat >> "$SHELL_RC" << 'EOF'

# VS Code AI Setup
# Uncomment and set your API keys:
# export ANTHROPIC_API_KEY="sk-ant-..."

# Claude Code Router activation (run 'ccr start' first)
# eval "$(ccr activate)"
EOF
            info "Added configuration to $SHELL_RC"
            warn "Edit $SHELL_RC to set your API keys"
        fi
    else
        warn "Could not find shell configuration file"
    fi
    
    echo ""
}

# Main
main() {
    check_prerequisites
    cleanup_vscode
    install_claude_code
    install_ccr
    install_ollama
    setup_shell
    
    echo ""
    echo "=============================="
    echo -e "${GREEN}✓ Installation complete!${NC}"
    echo "=============================="
    echo ""
    echo "Next steps:"
    echo "1. Edit ~/.claude-code-router/config.json with your API keys"
    echo "2. Edit your shell config file to set ANTHROPIC_API_KEY"
    echo "3. Run 'source ~/.zshrc' (or ~/.bashrc) to reload"
    echo "4. Run 'claude login' to authenticate Claude Code"
    echo "5. Run 'ollama serve' to start Ollama (in separate terminal)"
    echo "6. Run 'ccr start' to start the router"
    echo ""
    echo "To use in a project:"
    echo "  cp -r templates/frontend-nextjs/.claude your-project/"
    echo "  cp templates/frontend-nextjs/CLAUDE.md your-project/"
    echo "  cp -r templates/frontend-nextjs/docs your-project/"
    echo ""
}

main "$@"
