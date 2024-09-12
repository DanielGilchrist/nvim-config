#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install fd for telescope
if command_exists fd; then
  echo "fd is already installed."
else
  echo "Installing fd..."
  brew install fd
fi

# Install rg (ripgrep) for telescope
if command_exists rg; then
  echo "rg (ripgrep) is already installed."
else
  echo "Installing rg (ripgrep)..."
  brew install ripgrep
fi

# Install crystalline for Crystal
if command_exists crystalline; then
  echo "crystalline is already installed."
else
  echo "Installing crystalline..."
  brew install crystalline
fi

echo "Installation complete!"
