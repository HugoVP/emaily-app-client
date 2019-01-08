#!/bin/sh

export react_app_env_vars=$(egrep '^REACT_APP_.*' .env.production | sed 's|^.*\=||g' | tr '\n' ',')
echo "REACT APP env vars: $react_app_env_vars"

for f in $(egrep -rwl /usr/share/nginx/html -e '\$REACT_APP_.*'); do
  envsubst $react_app_env_vars < $f > $f
  echo "REACT APP env vars replaced in file: $(basename $f)"
done  

envsubst '\$PORT,\$API_HOST,\$API_DNS' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf
echo "CONFIG env vars replaced in the Nginx default.conf file"

echo "Starting up Nginx"
nginx -g 'daemon off;'