# Lessons Learned & Knowledge Repository

This document tracks issues encountered, solutions implemented, and best practices discovered during development.

## Docker Build Issues

### Issue: npm vs pnpm
**Problem:** Dockerfile was using `npm install` but the project uses `pnpm`.

**Solution:**
- Installed pnpm using `corepack enable && corepack prepare pnpm@10.4.1 --activate`
- Changed all npm commands to pnpm
- Updated to copy `pnpm-lock.yaml` instead of `package-lock.json`
- Added `patches` directory to COPY commands before `pnpm install`

**Files Changed:**
- `Dockerfile`

### Issue: Outdated Lockfile
**Problem:** `pnpm-lock.yaml` was out of date after removing `vite-plugin-manus-runtime` from `package.json`.

**Solution:**
- Temporarily used `--no-frozen-lockfile` flag in Dockerfile
- **Note:** Should regenerate lockfile locally with `pnpm install` and commit it, then switch back to `--frozen-lockfile` for reproducible builds

**Files Changed:**
- `Dockerfile`

## Path Resolution Issues

### Issue: import.meta.dirname undefined in bundled code
**Problem:** When code is bundled with esbuild for production, `import.meta.dirname` becomes undefined, causing `TypeError: paths[0] must be of type string. Received undefined`.

**Solution:**
- Added safe fallback logic to check if `import.meta.dirname` exists
- Use `process.cwd()` as fallback in production mode
- Handle both ESM and bundled code paths

**Files Changed:**
- `server/_core/vite.ts`

**Code Pattern:**
```typescript
const currentDir = typeof import.meta.dirname !== "undefined" 
  ? import.meta.dirname 
  : path.dirname(new URL(import.meta.url).pathname);
```

## Environment Configuration

### Issue: Missing .env file structure
**Problem:** `.env` file contained docker run command instead of environment variables.

**Solution:**
- Created proper `.env` file with all required variables
- Updated `docker-compose.yml` to use `env_file` directive

**Required Environment Variables:**
- `DATABASE_URL` - MySQL connection string
- `VITE_APP_ID` - OAuth app ID
- `OAUTH_SERVER_URL` - OAuth server URL
- `VITE_OAUTH_PORTAL_URL` - OAuth portal URL
- `JWT_SECRET` - JWT signing secret
- `BUILT_IN_FORGE_API_URL` - Forge API URL
- `BUILT_IN_FORGE_API_KEY` - Forge API key
- `OWNER_OPEN_ID` - (Optional) Owner OpenID
- `PORT` - (Optional) Server port, defaults to 3000

**Files Changed:**
- `.env`
- `docker-compose.yml`

## Docker Compose Configuration

### Issue: Outdated docker-compose.yml
**Problem:** `docker-compose.yml` referenced separate frontend/backend services and Dockerfiles that don't exist.

**Solution:**
- Updated to single `app` service matching monorepo structure
- Uses correct `Dockerfile` (not `Dockerfile.backend`)
- Loads environment from `.env` file
- Uses `pnpm` commands consistently

**Files Changed:**
- `docker-compose.yml`

## Code Cleanup

### Issue: Manus references throughout codebase
**Problem:** Project had references to "Manus" that needed to be removed.

**Solution:**
- Removed `vite-plugin-manus-runtime` from dependencies
- Removed Manus domains from vite.config.ts
- Deleted `ManusDialog.tsx` component
- Renamed `manusTypes.ts` to `oauthTypes.ts`
- Updated all comments and references
- Updated localStorage key from `manus-runtime-user-info` to `user-info`

**Files Changed:**
- `vite.config.ts`
- `package.json`
- `client/src/components/ManusDialog.tsx` (deleted)
- `server/_core/types/manusTypes.ts` → `oauthTypes.ts`
- `server/_core/sdk.ts`
- `server/storage.ts`
- `server/_core/map.ts`
- `server/_core/notification.ts`
- `server/_core/llm.ts`
- `server/_core/dataApi.ts`
- `drizzle/schema.ts`
- `client/src/_core/hooks/useAuth.ts`
- `server/auth.logout.test.ts`

## Best Practices

### Docker Builds
1. Always use the same package manager in Dockerfile as in local development
2. Copy lockfiles and patches before running install
3. Use `--frozen-lockfile` in production for reproducible builds
4. Regenerate lockfiles locally after dependency changes

### Path Resolution
1. Never assume `import.meta.dirname` exists in bundled code
2. Always provide fallbacks using `process.cwd()` for production
3. Test both development and production builds

### Environment Variables
1. Use `.env` files for local development
2. Use `env_file` in docker-compose for containerized environments
3. Never commit actual secrets to version control
4. Document all required environment variables in README

### Monorepo Structure
1. Single Dockerfile builds both frontend and backend
2. Build process: `pnpm run build` builds everything
3. Production serves static files from `dist/public`
4. Development uses Vite dev server

## Setting Up MySQL Database

### Issue: MySQL not installed locally
**Problem:** User tried to run `pnpm run db:push` but MySQL wasn't installed.

**Solution:**
- Set up MySQL using Docker container
- Created MySQL container with database pre-configured
- Updated .env with correct connection string

**Quick Setup:**
```bash
# Start MySQL in Docker
docker run --name mysql-yt-slides \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=yt_slides \
  -p 3306:3306 \
  -d mysql:8

# Update .env
DATABASE_URL=mysql://root:rootpassword@localhost:3306/yt_slides

# Run migrations
pnpm run db:push
```

**Container Management:**
```bash
# Stop container
docker stop mysql-yt-slides

# Start container
docker start mysql-yt-slides

# Remove container
docker rm mysql-yt-slides
```

## Common Commands

### Docker
```bash
# Build image
docker build -t yt-slide-extractor .

# Run with docker-compose
docker-compose up --build

# Run standalone
docker run -p 3000:3000 --env-file .env yt-slide-extractor
```

### Development
```bash
# Install dependencies
pnpm install

# Run development server
pnpm run dev

# Build for production
pnpm run build

# Start production server
pnpm run start
```

## Environment Variables Setup

### Issue: Unclear environment variable requirements
**Problem:** User didn't know what values to use for environment variables.

**Solution:**
- Created `ENV_SETUP.md` with detailed explanation of each variable
- Created `scripts/generate-env.sh` to auto-generate .env with JWT secret
- Categorized variables as Required, Conditionally Required, and Optional
- Provided examples and setup instructions

**Key Findings:**
- **Required:** `DATABASE_URL`, `JWT_SECRET`
- **Conditionally Required:** OAuth vars (only if using auth), Forge API vars (only if using AI features)
- **Optional:** `OWNER_OPEN_ID`, `PORT`

**Minimal Working Setup:**
```env
DATABASE_URL=mysql://root:password@localhost:3306/yt_slides
JWT_SECRET=<auto-generated-secret>
```

**Files Created:**
- `ENV_SETUP.md` - Comprehensive environment variable guide
- `scripts/generate-env.sh` - Helper script to generate .env file

## Future Improvements

1. [ ] Regenerate `pnpm-lock.yaml` and switch back to `--frozen-lockfile`
2. [ ] Add health check endpoint for Docker
3. [ ] Set up proper error handling for missing environment variables
4. [ ] Add Docker multi-stage build for smaller image size
5. [ ] Document API endpoints and usage
6. [ ] Add support for alternative OAuth providers (Google, GitHub, etc.)
7. [ ] Add support for alternative AI providers (OpenAI, Anthropic, etc.)