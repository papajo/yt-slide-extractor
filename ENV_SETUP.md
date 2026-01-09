# Environment Variables Setup Guide

This guide explains what each environment variable does, whether it's required, and how to configure it.

## Required vs Optional Variables

### 🔴 Required (App won't start without these)
- `JWT_SECRET` - Session management
- `DATABASE_URL` - Database connection

### 🟡 Conditionally Required (Required for specific features)
- OAuth variables - Only needed if using authentication
- Forge API variables - Only needed for AI/ML features

### 🟢 Optional
- `OWNER_OPEN_ID` - Only for admin features
- `PORT` - Defaults to 3000

## Variable Details

### 1. DATABASE_URL
**Required:** Yes (for database operations)

**Format:**
```
mysql://username:password@host:port/database_name
```

**Example:**
```env
DATABASE_URL=mysql://root:mypassword@localhost:3306/yt_slides
```

**How to get it:**
- If using local MySQL: `mysql://root:yourpassword@localhost:3306/yt_slides`
- If using a cloud database (AWS RDS, PlanetScale, etc.), get the connection string from your provider
- Create the database first: `CREATE DATABASE yt_slides;`

**For development/testing:**
You can use a local MySQL instance or a Docker container:
```bash
docker run --name mysql-yt -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=yt_slides -p 3306:3306 -d mysql:8
DATABASE_URL=mysql://root:rootpassword@localhost:3306/yt_slides
```

---

### 2. JWT_SECRET
**Required:** Yes (for session cookies)

**What it is:** A secret key used to sign JWT tokens for user sessions

**How to generate:**
```bash
# Generate a random secret (32+ characters recommended)
openssl rand -base64 32
# or
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
```

**Example:**
```env
JWT_SECRET=your_super_secret_key_here_at_least_32_characters_long
```

**Important:** Keep this secret! Never commit it to version control.

---

### 3. OAuth Configuration Variables

These are required if you want user authentication. If you're building a prototype or don't need auth yet, you can skip these (but some features won't work).

#### VITE_APP_ID
**Required:** Only if using OAuth

**What it is:** Your application ID from the OAuth provider

**Note:** This appears to be for a custom OAuth service. You have a few options:

**Option A: Use a standard OAuth provider (Google, GitHub, etc.)**
- You'll need to modify the OAuth code to use standard OAuth2
- Get client ID from your provider

**Option B: Disable authentication temporarily**
- Set empty values
- Authentication features will be disabled

**Option C: Set up your own OAuth server**
- Use a service like Auth0, Clerk, or Supabase Auth
- Or build your own OAuth2 server

#### OAUTH_SERVER_URL
**Required:** Only if using OAuth

**What it is:** Base URL of your OAuth server

**Example:**
```env
OAUTH_SERVER_URL=https://auth.example.com
```

#### VITE_OAUTH_PORTAL_URL
**Required:** Only if using OAuth

**What it is:** URL where users go to log in

**Example:**
```env
VITE_OAUTH_PORTAL_URL=https://auth.example.com/app-auth
```

---

### 4. Forge API Variables

These are used for multiple features:
- AI/LLM chat (`server/_core/llm.ts`)
- Image generation (`server/_core/imageGeneration.ts`)
- Voice transcription (`server/_core/voiceTranscription.ts`)
- Google Maps (`server/_core/map.ts`)
- Storage (`server/storage.ts`)
- Notifications (`server/_core/notification.ts`)

#### BUILT_IN_FORGE_API_URL
**Required:** Only if using AI/ML features

**What it is:** Base URL for the Forge API service

**Options:**
1. **If you have a Forge API account:** Use your API URL
2. **If using OpenAI directly:** You'd need to modify the code to use OpenAI's API
3. **For development:** You can mock these services or disable features

#### BUILT_IN_FORGE_API_KEY
**Required:** Only if using AI/ML features

**What it is:** API key for authenticating with Forge API

**Example:**
```env
BUILT_IN_FORGE_API_KEY=sk-your-api-key-here
```

---

### 5. OWNER_OPEN_ID
**Required:** No (optional)

**What it is:** OpenID of the application owner (for admin features)

**Example:**
```env
OWNER_OPEN_ID=user123
```

---

### 6. PORT
**Required:** No (defaults to 3000)

**What it is:** Port number for the server

**Example:**
```env
PORT=3000
```

---

## Quick Start Configurations

### Minimal Setup (No Auth, No AI Features)
```env
# Required
DATABASE_URL=mysql://root:password@localhost:3306/yt_slides
JWT_SECRET=generate_a_random_secret_here

# Optional
PORT=3000
```

### Full Setup (All Features)
```env
# Required
DATABASE_URL=mysql://root:password@localhost:3306/yt_slides
JWT_SECRET=generate_a_random_secret_here

# OAuth (if you have an OAuth provider)
VITE_APP_ID=your_app_id
OAUTH_SERVER_URL=https://your-oauth-server.com
VITE_OAUTH_PORTAL_URL=https://your-oauth-server.com/app-auth

# Forge API (if you have Forge API access)
BUILT_IN_FORGE_API_URL=https://api.forge.example.com
BUILT_IN_FORGE_API_KEY=your_api_key

# Optional
OWNER_OPEN_ID=your_open_id
PORT=3000
```

---

## Making Features Optional

If you want to disable certain features, you can:

1. **Disable OAuth:** Leave OAuth variables empty (some routes may fail, but app will start)
2. **Disable AI features:** Leave Forge API variables empty (AI features will error when used)
3. **Use local storage:** Modify storage.ts to use local filesystem instead of Forge API

---

## Testing Your Configuration

1. **Check database connection:**
```bash
pnpm run db:push
```

2. **Start the server:**
```bash
pnpm run dev
```

3. **Check for errors:** Look for missing environment variable warnings in the console

---

## Next Steps

1. **Set up MySQL database** (if not already done)
2. **Generate JWT_SECRET** using the command above
3. **Decide which features you need:**
   - Need authentication? Set up OAuth
   - Need AI features? Get Forge API credentials or modify code to use alternatives
4. **Update .env file** with your values
5. **Test the application**
