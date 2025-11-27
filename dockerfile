# ------------------------------------------------------
# 1. Build stage
# ------------------------------------------------------
FROM node:18-alpine AS build

# Install OS packages needed by Strapi
RUN apk add --no-cache python3 make g++ git

# Set working directory
WORKDIR /app

# Copy package files first (for better caching)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy all project files
COPY . .

# Build Strapi admin panel (production build)
RUN npm run build

# ------------------------------------------------------
# 2. Production stage
# ------------------------------------------------------
FROM node:18-alpine

# Install OS packages needed at runtime
RUN apk add --no-cache --virtual .gyp python3 make g++ && \
    apk add --no-cache bash && \
    npm install -g pm2 && \
    apk del .gyp

WORKDIR /app

# Copy node_modules + build output from previous stage
COPY --from=build /app ./

# Expose Strapi port
EXPOSE 1337

# Start Strapi in production
CMD ["npm", "run", "start"]
