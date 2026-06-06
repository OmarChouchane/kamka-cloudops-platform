FROM node:16.15.0-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:16.15.0-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:16.15.0-alpine AS runner
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
ENV NODE_ENV=production
ENV PORT=3000
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 3000
CMD ["node", "server.js"]
