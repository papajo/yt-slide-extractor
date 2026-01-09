# Use official Node.js Alpine image
FROM node:18-alpine

# Install ffmpeg, python3, pip (yt-dlp dependency)
RUN apk add --no-cache ffmpeg python3 py3-pip

# Create Python virtual environment and install yt-dlp inside it
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install yt-dlp

# Add virtualenv binaries to PATH
ENV PATH="/opt/venv/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if exists)
COPY package*.json ./

# Install node dependencies
RUN npm install

# Copy all source files
COPY . .

# Build the app (frontend + backend)
RUN npm run build

# Expose backend port (adjust if your backend uses a different port)
EXPOSE 3000

# Start the backend server
CMD ["npm", "run", "start"]
