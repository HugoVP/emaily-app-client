FROM node:10.11.0-alpine
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn
COPY . .
CMD ["yarn", "start"]
