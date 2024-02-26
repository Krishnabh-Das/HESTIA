# Stage 1: Build the Node.js application
FROM node:20.11.1-bullseye-slim AS build

WORKDIR /app
COPY package.json .
RUN npm install

COPY . .
CMD npm run dev --port=8000

# Stage 2: Serve the built application using NGINX
# FROM nginx:1.22

# COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
# COPY ./dist /usr/share/nginx/html