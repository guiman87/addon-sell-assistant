#!/usr/bin/env bash
set -e

# Load bashio library
source /usr/lib/bashio/bashio.sh

# Read add-on options using bashio
GOOGLE_CLIENT_EMAIL=$(bashio::config 'google_client_email')
GOOGLE_PRIVATE_KEY=$(bashio::config 'google_private_key')
GOOGLE_SPREADSHEET_ID=$(bashio::config 'google_spreadsheet_id')
GOOGLE_DRIVE_FOLDER_ID=$(bashio::config 'google_drive_folder_id')
GEMINI_API_KEY=$(bashio::config 'gemini_api_key')
REPOSITORY_URL=$(bashio::config 'repository_url')

# Check if REPOSITORY_URL is provided
if [ -z "${REPOSITORY_URL}" ]; then
  bashio::log.fatal "REPOSITORY_URL is not set. Please provide the repository URL in the add-on options."
  exit 1
fi

# Clone the repository
bashio::log.info "Cloning repository from ${REPOSITORY_URL}..."
git clone "${REPOSITORY_URL}" /app/repo

# Navigate to the app directory
cd /app/repo

# Set ingress base path if available
INGRESS_ENTRY=$(bashio::addon.ingress_entry || echo "")
if [ -n "${INGRESS_ENTRY}" ]; then
    export NEXT_PUBLIC_BASE_PATH="${INGRESS_ENTRY}"
    bashio::log.info "Ingress enabled with base path: ${NEXT_PUBLIC_BASE_PATH}"
else
    export NEXT_PUBLIC_BASE_PATH=""
    bashio::log.info "Running without ingress (direct port access)"
fi

# Create .env.local file from variables
bashio::log.info "Creating .env.local file..."
echo "GOOGLE_CLIENT_EMAIL=${GOOGLE_CLIENT_EMAIL}" > .env.local
echo "GOOGLE_PRIVATE_KEY=${GOOGLE_PRIVATE_KEY}" >> .env.local
echo "GOOGLE_SPREADSHEET_ID=${GOOGLE_SPREADSHEET_ID}" >> .env.local
echo "GOOGLE_DRIVE_FOLDER_ID=${GOOGLE_DRIVE_FOLDER_ID}" >> .env.local
echo "GEMINI_API_KEY=${GEMINI_API_KEY}" >> .env.local

# Install dependencies
bashio::log.info "Installing dependencies..."
npm install

# Build the app
bashio::log.info "Building the Next.js app..."
npm run build

# Start the app
bashio::log.info "Starting the Sell Assistant app..."
npm run start
