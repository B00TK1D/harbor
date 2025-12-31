#!/bin/bash

set -e
# This script installs necessary dependencies for the project.
# It should be run in a Unix-like environment.

docker build -t harbor:latest .
echo "Docker image 'harbor:latest' built successfully."

# Copy harbor script to /usr/local/bin
cp ./harbor /usr/local/bin/harbor
chmod +x /usr/local/bin/harbor
echo "Harbor script copied to /usr/local/bin and made executable."

echo "Installation completed successfully, you can now use the 'harbor' command."
