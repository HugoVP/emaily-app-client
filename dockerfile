FROM mhart/alpine-node:10.11.0

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn

COPY public/ public/
COPY src/ src/
COPY .env.example .env.production

RUN yarn build


FROM nginxinc/nginx-unprivileged:alpine

WORKDIR /app

COPY --from=0 --chown=nginx:nginx /app/build /usr/share/nginx/html
COPY --chown=nginx:nginx nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --chown=nginx:nginx command.sh .
COPY .env.example .env.production

RUN chmod +x command.sh

CMD [ "./command.sh" ]
