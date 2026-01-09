#!/bin/bash

# Script to generate a minimal .env file with a random JWT secret

echo "Generating .env file..."

# Generate JWT secret
JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(32).toString('base64'))")

cat > .env << EOF
# Database Configuration
# Format: mysql://username:password@host:port/database_name
# Example: mysql://root:password@localhost:3306/yt_slides
DATABASE_URL=mysql://root:password@localhost:3306/yt_slides

# JWT Secret (auto-generated)
JWT_SECRET=$JWT_SECRET

# OAuth Configuration (optional - leave empty if not using auth)
# If you have an OAuth provider, fill these in:
VITE_APP_ID=
OAUTH_SERVER_URL=
VITE_OAUTH_PORTAL_URL=

# Forge API Configuration (optional - leave empty if not using AI features)
# If you have Forge API access, fill these in:
BUILT_IN_FORGE_API_URL=
BUILT_IN_FORGE_API_KEY=

# Optional
OWNER_OPEN_ID=
PORT=3000
EOF

echo "✅ .env file created!"
echo ""
echo "⚠️  IMPORTANT: Update DATABASE_URL with your actual database credentials"
echo "⚠️  The JWT_SECRET has been auto-generated: $JWT_SECRET"
echo ""
echo "Next steps:"
echo "1. Update DATABASE_URL with your MySQL connection string"
echo "2. If using OAuth, fill in the OAuth variables"
echo "3. If using AI features, fill in the Forge API variables"
