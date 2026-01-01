# Stage 1: Build frontend
FROM node:18-alpine AS frontend-build
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Build backend
FROM node:18-alpine AS backend-build
WORKDIR /app
COPY backend/package*.json ./
RUN npm install
COPY backend/ ./

# Copy frontend build into backend public folder (optional)
COPY --from=frontend-build /app/dist ./frontend/dist

# Expose backend port
EXPOSE 5000

# Start backend
CMD ["node", "server.js"]
