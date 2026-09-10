<h1>Development</h1>

- [First time...](#first-time)
  - [Setup](#setup)
  - [Startup](#startup)
- [Debugging the backend (VSC)](#debugging-the-backend-vsc)
- [Deploy changes](#deploy-changes)
  - [Frontend](#frontend)
  - [Backend](#backend)

# First time...

## Setup
Checkout the repository and navigate to the `youtubedl-material` directory.
```bash
vim ./src/assets/default.json # Only used by `ng serve` to bootstrap the frontend's config preview in dev mode; the backend always reads/writes its own config at ./backend/appdata/default.json (gitignored, auto-created on first run)
npm -g install pm2 # Install pm2
npm install # Install dependencies for the frontend
cd ./backend
npm install # Install dependencies for the backend
cd ..
npm run build # Build the frontend
```
This step have to be done only once.

## Startup
Navigate to the `youtubedl-material/backend` directory and run `npm start`.

# Debugging the backend (VSC)
Open the `youtubedl-material` directory in Visual Studio Code and run the launch configuration `Dev: Debug Backend`.

This runs `npm run dev` from `./backend`, which sets `YTDL_MODE=dev` and starts the backend with `node app.js` directly (no pm2). Works on Linux/macOS/WSL out of the box. On native Windows (cmd/PowerShell), prefix the command with `cross-env` or set the environment variable separately before running `node app.js`.

In this mode the backend's config, local DB and secrets (e.g. the auto-generated bootstrap API key) live entirely under `./backend/appdata/` (gitignored) — isolated from any tracked file, so nothing generated locally can end up committed.

# Deploy changes

## Frontend
Navigate to the `youtubedl-material` directory and run `npm run build`. Restart the backend.

## Backend
Simply restart the backend.