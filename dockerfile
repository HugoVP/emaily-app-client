FROM node:10.11.0-alpine AS build-phase
COPY ./ /app/
RUN cd /app/ \
  && yarn install \
  && yarn build

FROM nginx:alpine
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build-phase /app/build /usr/share/nginx/html
