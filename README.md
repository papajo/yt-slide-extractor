# YouTube Slide Extractor

A web application for extracting slides and content from YouTube videos. This application allows users to download YouTube videos, extract frames, transcribe audio, and process video content.

## Features

- **YouTube Video Processing**: Download and process YouTube videos using `yt-dlp`
- **Frame Extraction**: Extract frames and slides from video content
- **Audio Transcription**: Transcribe audio from videos using speech-to-text services
- **Image Generation**: Generate and process images using AI services
- **User Authentication**: OAuth-based authentication system
- **Modern UI**: Built with React, TypeScript, and Tailwind CSS

## Tech Stack

### Frontend
- **React 19** with TypeScript
- **Vite** for build tooling
- **tRPC** for type-safe API calls
- **Tailwind CSS** for styling
- **Radix UI** components
- **Wouter** for routing

### Backend
- **Node.js** with Express
- **tRPC** for API layer
- **TypeScript** throughout
- **Drizzle ORM** with MySQL
- **JWT** for session management

### Tools & Services
- **yt-dlp** for YouTube video downloading
- **ffmpeg** for video processing
- **Python 3** for video processing scripts

## Prerequisites

- Node.js 18+
- pnpm (package manager)
- MySQL database
- Python 3 with pip
- ffmpeg

## Installation

1. Clone the repository:
```bash
git clone https://github.com/papajo/yt-slide-extractor.git
cd yt-slide-extractor
```

2. Install dependencies:
```bash
pnpm install
```

3. Set up environment variables. Create a `.env` file in the root directory:
```env
# Database
DATABASE_URL=mysql://user:password@localhost:3306/dbname

# OAuth Configuration
VITE_APP_ID=your_app_id
OAUTH_SERVER_URL=your_oauth_server_url
VITE_OAUTH_PORTAL_URL=your_oauth_portal_url

# JWT Secret
JWT_SECRET=your_jwt_secret

# API Services
BUILT_IN_FORGE_API_URL=your_forge_api_url
BUILT_IN_FORGE_API_KEY=your_forge_api_key

# Optional
OWNER_OPEN_ID=your_owner_open_id
```

4. Set up the database:
```bash
pnpm run db:push
```

5. Install Python dependencies (for yt-dlp):
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install yt-dlp
```

## Development

Start the development server:
```bash
pnpm run dev
```

The application will be available at `http://localhost:3000`

## Building for Production

Build the application:
```bash
pnpm run build
```

Start the production server:
```bash
pnpm run start
```

## Docker

Build and run with Docker:
```bash
docker build -t yt-slide-extractor .
docker run -p 3000:3000 yt-slide-extractor
```

## Scripts

- `pnpm run dev` - Start development server
- `pnpm run build` - Build for production
- `pnpm run start` - Start production server
- `pnpm run check` - Type check with TypeScript
- `pnpm run format` - Format code with Prettier
- `pnpm run test` - Run tests
- `pnpm run db:push` - Push database schema changes

## Project Structure

```
yt-slide-extractor/
├── client/              # Frontend React application
│   ├── src/
│   │   ├── components/  # React components
│   │   ├── pages/      # Page components
│   │   └── ...
│   └── ...
├── server/              # Backend Express application
│   ├── _core/          # Core server utilities
│   └── ...
├── shared/              # Shared types and constants
├── drizzle/             # Database schema and migrations
└── ...
```

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
