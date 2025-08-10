# Dockerfile for Production

# ---- Base Stage ----
FROM node:22-alpine AS base
WORKDIR /usr/src/app

# ---- Dependencies Stage ----
FROM base AS dependencies
COPY package.json package-lock.json ./
RUN npm install --omit=dev

# ---- Build Stage ----
FROM dependencies AS build
COPY . .
RUN npm run build

# ---- Production Stage ----
FROM base AS production
COPY --from=dependencies /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist
COPY package.json .

EXPOSE 3000
CMD [ "npm", "run", "start:prod" ]
