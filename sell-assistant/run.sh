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
EXTERNAL_URL=$(bashio::config 'external_url')
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

# Create .env.local file from variables
bashio::log.info "Creating .env.local file..."
cat <<EOF > .env.local
GOOGLE_CLIENT_EMAIL="${GOOGLE_CLIENT_EMAIL}"
GOOGLE_PRIVATE_KEY="${GOOGLE_PRIVATE_KEY}"
GOOGLE_SPREADSHEET_ID="${GOOGLE_SPREADSHEET_ID}"
GOOGLE_DRIVE_FOLDER_ID="${GOOGLE_DRIVE_FOLDER_ID}"
GEMINI_API_KEY="${GEMINI_API_KEY}"
NEXT_PUBLIC_BASE_URL="${EXTERNAL_URL}"
EOF

# Set up persistent upload directory
export UPLOAD_DIR="/data/uploads"
mkdir -p "$UPLOAD_DIR"
echo "UPLOAD_DIR=${UPLOAD_DIR}" >> .env.local
bashio::log.info "Using persistent upload directory: ${UPLOAD_DIR}"

# Debug: List available models
bashio::log.info "Checking available Gemini models..."
curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=${GEMINI_API_KEY}" > /tmp/models.json
if [ -s /tmp/models.json ]; then
    cat /tmp/models.json | grep "\"name\": \"models/gemini" || bashio::log.warning "Could not parse models list"
    cat /tmp/models.json # Print full output if grep fails or just to be safe in logs
else
    bashio::log.error "Failed to fetch models list"
fi

# Install dependencies
bashio::log.info "Installing dependencies..."
npm install

# Build the app
bashio::log.info "Building the Next.js app..."
npm run build

# Start the app
bashio::log.info "Starting the Sell Assistant app..."
npm run start
