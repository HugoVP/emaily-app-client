FROM node:10.11.0-alpine AS build-phase
COPY ./ /app/
RUN cd /app/ \
  && yarn install \
  && yarn build

FROM nginx:alpine AS run-phase
COPY --from=build-phase /app/build /usr/share/nginx/html
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
CMD /bin/sh -c "envsubst '\$PORT\$API_HOST\$API_DNS' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf" \
  && nginx -g 'daemon off;'
