#!/bin/bash

# This script moves specific project files to a versioned directory.

# Stop script on any error
set -e

# --- Configuration ---
# List of files to be moved. Edit this array to change the files.
FILES_TO_MOVE=(
  "lib.typ"
  "LICENSE"
  "README.md"
  "typst.toml"
)

# --- Script Logic ---

# 1. Extract the version number from the typst.toml file.
# It finds the line starting with 'version =', and extracts the value between the quotes.
VERSION=$(grep -E '^version\s*=' typst.toml | sed -E 's/version = "([^"]+)"/\1/')

# Verify that a version was actually found.
if [ -z "$VERSION" ]; then
    echo "Error: Could not find 'version' in typst.toml" >&2
    exit 1
fi

echo "Found version: $VERSION"

# 2. Define the destination directory path.
# It uses the user's home directory and the extracted version.
DEST_DIR="../packages/packages/preview/keepsake/$VERSION"

echo "Destination directory: $DEST_DIR"

# 3. Create the destination directory.
# The '-p' flag ensures that the parent directories are also created if they don't exist.
echo "Creating destination directory (if it doesn't exist)..."
mkdir -p "$DEST_DIR"

# 4. Copy the specified files to the destination.
echo "Copying project files..."
for file in "${FILES_TO_MOVE[@]}"; do
  # Check if the file exists before trying to copy it.
  if [ -f "$file" ]; then
    cp "$file" "$DEST_DIR/"
    echo "  - Copied $file"
  else
    # Print a warning if a file in the list is not found.
    echo "  - Warning: File not found, skipping: $file" >&2
  fi
done

echo "File move complete."
