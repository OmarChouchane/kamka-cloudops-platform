FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:20-alpine AS runner
WORKDIR /app
RUN apk add --no-cache dumb-init
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder /app/node_modules ./node_modules
COPY src/ ./src/
COPY database/ ./database/
COPY package*.json ./
RUN chown -R appuser:appgroup /app
USER appuser
ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "src/server.js"]
