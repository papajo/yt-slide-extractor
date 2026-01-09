# How To: Run the YouTube Slide Extractor

Complete guide for running the application locally or with Docker.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Local Development](#local-development)
4. [Docker Setup](#docker-setup)
5. [Backend Setup](#backend-setup)
6. [Frontend Setup](#frontend-setup)
7. [Database Management](#database-management)
8. [Common Tasks](#common-tasks)
9. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required
- **Node.js** 18+ ([Download](https://nodejs.org/))
- **pnpm** package manager (installed via corepack)
- **Docker** (for Docker setup) ([Download](https://www.docker.com/))
- **MySQL** (or Docker for MySQL)

### Optional
- **Python 3** with pip (for yt-dlp)
- **ffmpeg** (for video processing)

---

## Quick Start

### Option 1: Local Development (Recommended for Development)

```bash
# 1. Clone the repository
git clone https://github.com/papajo/yt-slide-extractor.git
cd yt-slide-extractor

# 2. Install pnpm (if not already installed)
corepack enable
corepack prepare pnpm@10.4.1 --activate

# 3. Install dependencies
pnpm install

# 4. Set up MySQL (using Docker)
docker run --name mysql-yt-slides \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=yt_slides \
  -p 3306:3306 \
  -d mysql:8

# 5. Configure environment variables
# Edit .env file or use the helper script
./scripts/generate-env.sh
# Then update DATABASE_URL in .env:
# DATABASE_URL=mysql://root:rootpassword@localhost:3306/yt_slides

# 6. Set up database
pnpm run db:push

# 7. Start development server
pnpm run dev
```

The app will be available at `http://localhost:3000`

### Option 2: Docker (Recommended for Production)

```bash
# 1. Clone the repository
git clone https://github.com/papajo/yt-slide-extractor.git
cd yt-slide-extractor

# 2. Configure environment variables
# Edit .env file with your settings
# See ENV_SETUP.md for details

# 3. Build and run with docker-compose
docker-compose up --build

# Or build and run manually
docker build -t yt-slide-extractor .
docker run -p 3000:3000 --env-file .env yt-slide-extractor
```

---

## Local Development

### Initial Setup

1. **Install pnpm:**
   ```bash
   corepack enable
   corepack prepare pnpm@10.4.1 --activate
   ```

2. **Install dependencies:**
   ```bash
   pnpm install
   ```

3. **Set up MySQL:**
   ```bash
   # Using Docker (easiest)
   docker run --name mysql-yt-slides \
     -e MYSQL_ROOT_PASSWORD=rootpassword \
     -e MYSQL_DATABASE=yt_slides \
     -p 3306:3306 \
     -d mysql:8
   
   # Or use existing MySQL installation
   # Create database: CREATE DATABASE yt_slides;
   ```

4. **Configure environment:**
   ```bash
   # Generate .env file
   ./scripts/generate-env.sh
   
   # Edit .env and update:
   # - DATABASE_URL with your MySQL connection string
   # - JWT_SECRET (auto-generated, but you can change it)
   # - Optional: OAuth and Forge API variables
   ```

5. **Initialize database:**
   ```bash
   pnpm run db:push
   ```

### Running the Application

#### Development Mode (Hot Reload)

```bash
# Start both frontend and backend with hot reload
pnpm run dev
```

This will:
- Start the Express backend server
- Start Vite dev server for the frontend
- Enable hot module replacement (HMR)
- Watch for file changes

**Access:** `http://localhost:3000`

#### Production Mode (Local)

```bash
# Build the application
pnpm run build

# Start production server
pnpm run start
```

**Access:** `http://localhost:3000`

### Available Scripts

```bash
# Development
pnpm run dev          # Start dev server with hot reload

# Building
pnpm run build        # Build for production (frontend + backend)

# Production
pnpm run start        # Start production server

# Code Quality
pnpm run check        # Type check with TypeScript
pnpm run format       # Format code with Prettier
pnpm run test         # Run tests

# Database
pnpm run db:push      # Generate and apply database migrations
```

---

## Docker Setup

### Using Docker Compose (Recommended)

1. **Configure environment:**
   ```bash
   # Edit .env file with your settings
   # See ENV_SETUP.md for required variables
   ```

2. **Build and run:**
   ```bash
   # Build and start
   docker-compose up --build
   
   # Run in background
   docker-compose up -d --build
   
   # View logs
   docker-compose logs -f
   
   # Stop
   docker-compose down
   ```

3. **Access the application:**
   - Frontend/Backend: `http://localhost:3000`

### Using Docker Directly

1. **Build the image:**
   ```bash
   docker build -t yt-slide-extractor .
   ```

2. **Run the container:**
   ```bash
   # With .env file
   docker run -p 3000:3000 --env-file .env yt-slide-extractor
   
   # With environment variables
   docker run -p 3000:3000 \
     -e DATABASE_URL="mysql://..." \
     -e JWT_SECRET="..." \
     yt-slide-extractor
   ```

3. **Run in background:**
   ```bash
   docker run -d -p 3000:3000 --env-file .env --name yt-slide-extractor yt-slide-extractor
   ```

4. **View logs:**
   ```bash
   docker logs -f yt-slide-extractor
   ```

5. **Stop container:**
   ```bash
   docker stop yt-slide-extractor
   docker rm yt-slide-extractor
   ```

### Docker with MySQL

If you want to run both the app and MySQL in Docker:

```bash
# Start MySQL
docker run --name mysql-yt-slides \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=yt_slides \
  -p 3306:3306 \
  -d mysql:8

# Update .env
DATABASE_URL=mysql://root:rootpassword@host.docker.internal:3306/yt_slides

# Start app
docker-compose up --build
```

**Note:** Use `host.docker.internal` instead of `localhost` when connecting from Docker container to host MySQL.

---

## Backend Setup

### Architecture

The backend is a **monorepo** structure:
- **Server code:** `server/` directory
- **Entry point:** `server/_core/index.ts`
- **API:** tRPC endpoints in `server/routers.ts`
- **Database:** Drizzle ORM with MySQL

### Backend Features

- **tRPC API:** Type-safe API layer
- **OAuth Authentication:** User authentication flow
- **Database:** MySQL with Drizzle ORM
- **File Storage:** S3-compatible storage
- **AI Services:** LLM, image generation, transcription
- **Maps:** Google Maps integration

### Running Backend Only

The backend and frontend run together in this monorepo. To run just the backend logic:

```bash
# Development (includes frontend via Vite)
pnpm run dev

# Production (serves built frontend)
pnpm run build
pnpm run start
```

### Backend API

- **tRPC Endpoint:** `/api/trpc`
- **OAuth Callback:** `/api/oauth/callback`
- **Static Files:** Served from `dist/public` in production

### Environment Variables for Backend

See `ENV_SETUP.md` for complete list. Key variables:

```env
DATABASE_URL=mysql://...
JWT_SECRET=...
OAUTH_SERVER_URL=...
BUILT_IN_FORGE_API_URL=...
BUILT_IN_FORGE_API_KEY=...
```

---

## Frontend Setup

### Architecture

The frontend is built with:
- **React 19** with TypeScript
- **Vite** for build tooling
- **tRPC** for type-safe API calls
- **Tailwind CSS** for styling
- **Radix UI** components

### Frontend Location

- **Source:** `client/src/`
- **Entry:** `client/src/main.tsx`
- **Pages:** `client/src/pages/`
- **Components:** `client/src/components/`

### Development

The frontend is automatically served by Vite in development mode:

```bash
pnpm run dev
```

Vite will:
- Serve the React app
- Enable hot module replacement
- Proxy API requests to the backend

### Building Frontend

```bash
# Build frontend (part of full build)
pnpm run build

# Output: dist/public/
```

### Frontend Environment Variables

Frontend uses `VITE_` prefixed variables:

```env
VITE_APP_ID=...
VITE_OAUTH_PORTAL_URL=...
```

These are embedded at build time.

---

## Database Management

### Finding MySQL Root Password

**For Docker MySQL Container:**

The MySQL root password is set when you **create** the container. It's whatever you specify in the `-e MYSQL_ROOT_PASSWORD=` parameter.

**To find your current password:**

1. **Check the command you used to create the container:**
   ```bash
   # If you used the command from the docs, the password is "rootpassword"
   docker run --name mysql-yt-slides \
     -e MYSQL_ROOT_PASSWORD=rootpassword \  # <-- This is your password
     ...
   ```

2. **Check container environment variables:**
   ```bash
   docker inspect mysql-yt-slides | grep -i MYSQL_ROOT_PASSWORD
   ```

3. **Check your .env file:**
   ```bash
   # The password in DATABASE_URL should match
   cat .env | grep DATABASE_URL
   # Example: mysql://root:rootpassword@localhost:3306/yt_slides
   #                                    ^^^^^^^^^^^^ this is the password
   ```

**If you forgot the password:**

You can reset it or create a new container:

```bash
# Option 1: Reset password in existing container
docker exec -it mysql-yt-slides mysql -u root -p
# Enter current password (or try common ones: rootpassword, root, password)

# If you can't access, create new container:
docker stop mysql-yt-slides
docker rm mysql-yt-slides
docker run --name mysql-yt-slides \
  -e MYSQL_ROOT_PASSWORD=your_new_password \  # Choose your password
  -e MYSQL_DATABASE=yt_slides \
  -p 3306:3306 \
  -d mysql:8

# Update .env file
DATABASE_URL=mysql://root:your_new_password@localhost:3306/yt_slides
```

**For Local MySQL Installation:**

If you installed MySQL locally (not Docker), the password was set during installation:
- **macOS (Homebrew):** Usually no password by default, or check installation notes
- **Linux:** Set during `mysql_secure_installation`
- **Windows:** Set during MySQL installation wizard

To reset local MySQL root password:
```bash
# Stop MySQL service
sudo systemctl stop mysql  # Linux
brew services stop mysql   # macOS

# Start MySQL in safe mode and reset password
# (See MySQL documentation for your OS)
```

### Initial Setup

```bash
# Create database (if using local MySQL)
mysql -u root -p
# Enter your MySQL root password when prompted
CREATE DATABASE yt_slides;

# Or use Docker MySQL (see Quick Start)
# Password is set when creating container: -e MYSQL_ROOT_PASSWORD=your_password

# Run migrations
pnpm run db:push
```

### Database Migrations

```bash
# Generate and apply migrations
pnpm run db:push

# This runs:
# - drizzle-kit generate (creates migration files)
# - drizzle-kit migrate (applies migrations)
```

### Database Schema

- **Location:** `drizzle/schema.ts`
- **Migrations:** `drizzle/migrations/`
- **Current tables:** `users`

### MySQL Container Management

```bash
# Start MySQL
docker start mysql-yt-slides

# Stop MySQL
docker stop mysql-yt-slides

# View logs
docker logs mysql-yt-slides

# Connect to MySQL
docker exec -it mysql-yt-slides mysql -uroot -prootpassword

# Remove container (⚠️ deletes data)
docker rm -f mysql-yt-slides
```

### Backup Database

```bash
# Export database
docker exec mysql-yt-slides mysqldump -uroot -prootpassword yt_slides > backup.sql

# Import database
docker exec -i mysql-yt-slides mysql -uroot -prootpassword yt_slides < backup.sql
```

---

## Common Tasks

### Update Dependencies

```bash
# Update all dependencies
pnpm update

# Update specific package
pnpm update package-name

# Add new dependency
pnpm add package-name

# Add dev dependency
pnpm add -D package-name
```

### Regenerate Lockfile

```bash
# Remove lockfile and node_modules
rm -rf node_modules pnpm-lock.yaml

# Reinstall
pnpm install
```

### Clear Build Cache

```bash
# Remove build artifacts
rm -rf dist node_modules/.vite

# Rebuild
pnpm run build
```

### View Logs

```bash
# Development (terminal output)
pnpm run dev

# Docker
docker-compose logs -f

# Docker container
docker logs -f yt-slide-extractor
```

### Restart Services

```bash
# Local development
# Stop: Ctrl+C
# Start: pnpm run dev

# Docker Compose
docker-compose restart

# Docker container
docker restart yt-slide-extractor
```

---

## Troubleshooting

### Port Already in Use

```bash
# Find process using port 3000
lsof -i :3000

# Kill process
kill -9 <PID>

# Or change port in .env
PORT=3001
```

### Database Connection Failed

```bash
# Check MySQL is running
docker ps | grep mysql

# Test connection
mysql -h localhost -u root -p

# Check DATABASE_URL in .env
cat .env | grep DATABASE_URL

# Verify MySQL container
docker logs mysql-yt-slides
```

### pnpm Command Not Found

```bash
# Enable corepack
corepack enable

# Prepare pnpm
corepack prepare pnpm@10.4.1 --activate

# Verify
pnpm --version
```

### Docker Build Fails

```bash
# Clean Docker cache
docker system prune -a

# Rebuild without cache
docker build --no-cache -t yt-slide-extractor .

# Check Dockerfile syntax
docker build -t yt-slide-extractor . 2>&1 | head -20
```

### Environment Variables Not Loading

```bash
# Verify .env file exists
ls -la .env

# Check file format (no spaces around =)
cat .env

# Restart server after changing .env
# Development: Ctrl+C and pnpm run dev
# Docker: docker-compose restart
```

### TypeScript Errors

```bash
# Type check
pnpm run check

# Clear TypeScript cache
rm -rf node_modules/.cache

# Reinstall types
pnpm install
```

### Frontend Not Loading

```bash
# Check if backend is running
curl http://localhost:3000

# Check browser console for errors
# Verify VITE_ variables are set
# Rebuild frontend
pnpm run build
```

### Database Migration Errors

```bash
# Check database connection
pnpm run db:push

# Verify schema file
cat drizzle/schema.ts

# Check migration files
ls -la drizzle/migrations/

# Reset database (⚠️ deletes data)
docker exec mysql-yt-slides mysql -uroot -prootpassword -e "DROP DATABASE yt_slides; CREATE DATABASE yt_slides;"
pnpm run db:push
```

### OAuth Not Working

```bash
# Check OAuth variables are set
cat .env | grep OAUTH

# Verify OAuth server is accessible
curl $OAUTH_SERVER_URL

# Check browser console for errors
# Verify redirect URI matches OAuth provider settings
```

---

## Production Deployment

### Building for Production

```bash
# Build everything
pnpm run build

# Output:
# - dist/index.js (backend)
# - dist/public/ (frontend)
```

### Environment Variables

Ensure all required variables are set in production:

```env
DATABASE_URL=...
JWT_SECRET=...
NODE_ENV=production
# ... other variables
```

### Docker Production

```bash
# Build production image
docker build -t yt-slide-extractor:latest .

# Run with production settings
docker run -d \
  -p 3000:3000 \
  --env-file .env.production \
  --name yt-slide-extractor \
  yt-slide-extractor:latest
```

### Health Checks

```bash
# Check if server is running
curl http://localhost:3000

# Check API
curl http://localhost:3000/api/trpc/system.health
```

---

## Additional Resources

- **Environment Setup:** See `ENV_SETUP.md`
- **Lessons Learned:** See `lessons.md`
- **README:** See `README.md`
- **Docker Compose:** See `docker-compose.yml`
- **Dockerfile:** See `Dockerfile`

---

## Getting Help

1. Check the troubleshooting section above
2. Review `lessons.md` for common issues
3. Check `ENV_SETUP.md` for environment variable issues
4. Review application logs
5. Check GitHub issues

---

**Last Updated:** 2025-01-09

## How to Find MySQL Root Password

### For Your Current Setup:

Your MySQL Docker container password is: **rootpassword**

You can verify this by running:
```bash
docker inspect mysql-yt-slides | grep MYSQL_ROOT_PASSWORD
```

Your .env file should have:
```
DATABASE_URL=mysql://root:rootpassword@localhost:3306/yt_slides
```

### Quick Commands:

**Check container password:**
```bash
docker inspect mysql-yt-slides | grep MYSQL_ROOT_PASSWORD
```

**Check .env password:**
```bash
cat .env | grep DATABASE_URL
```

**Test connection:**
```bash
docker exec -it mysql-yt-slides mysql -uroot -prootpassword
```

