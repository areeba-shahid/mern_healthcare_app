# Stage 1: Build frontend
FROM node:18-alpine AS frontend-build
WORKDIR /app
COPY frontend/package*.json ./frontend/
RUN npm install --prefix frontend
COPY frontend/ ./frontend/
# Fix: Use npx to run vite or set proper permissions
RUN npm run --prefix frontend build || \
    (cd frontend && npx vite build)

# Stage 2: Setup backend
FROM node:18-alpine
WORKDIR /app
COPY backend/package*.json ./backend/
RUN npm install --prefix backend --only=production
COPY backend/ ./backend/
COPY --from=frontend-build /app/frontend/dist ./frontend/dist

# Set port dynamically
ENV PORT=5000
EXPOSE 5000
CMD ["node", "backend/server.js"]