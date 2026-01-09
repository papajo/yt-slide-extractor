# Use official Node.js Alpine image
FROM node:18-alpine

# Install ffmpeg, python3, pip (yt-dlp dependency)
RUN apk add --no-cache ffmpeg python3 py3-pip

# Install pnpm
RUN corepack enable && corepack prepare pnpm@10.4.1 --activate

# Create Python virtual environment and install yt-dlp inside it
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install yt-dlp

# Add virtualenv binaries to PATH
ENV PATH="/opt/venv/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy package.json, pnpm-lock.yaml, and patches directory
COPY package.json pnpm-lock.yaml ./
COPY patches ./patches

# Install node dependencies
# Note: Using --no-frozen-lockfile to allow lockfile updates if package.json changed
RUN pnpm install --no-frozen-lockfile

# Copy all source files
COPY . .

# Build the app (frontend + backend)
RUN pnpm run build

# Expose backend port (adjust if your backend uses a different port)
EXPOSE 3000

# Start the backend server
CMD ["pnpm", "run", "start"]
