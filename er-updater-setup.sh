#!/bin/bash
set -e

# Ensure running as root or with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo)."
  exit 1
fi

# Install prerequisites
apt-get update
apt-get install -y curl git

# Install GitHub CLI
if ! command -v gh &> /dev/null; then
  echo "[+] Installing GitHub CLI..."
  type -p curl >/dev/null || apt install curl -y
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  apt update
  apt install gh -y
else
  echo "[+] GitHub CLI already installed."
fi

# Run GitHub authentication with SSH
echo "[+] Starting GitHub authentication (SSH)..."
echo "gh auth login will now run. Please follow the prompts."
gh auth login --hostname github.com --git-protocol ssh

echo "[+] Authentication complete."
