#!/bin/sh

export react_app_env_vars=$(egrep '^REACT_APP_.*' .env.example | sed 's|^.*\=||g' | tr '\n' ',')
echo "React App Env Vars: $react_app_env_vars"

for f in $(find /usr/share/nginx/html -regex '.*\..*'); do
  if [ $(egrep -c -e '\$REACT_APP_.*' $f) -ge 1 ]; then
    echo "Replacing REACT APP env vars in file: $(basename $f)"
    envsubst $react_app_env_vars < $f > $f
  fi
done

echo "Replacing CONFIG env vars in the Nginx default.conf file"
envsubst '\$PORT,\$API_HOST,\$API_DNS' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf

echo "Starting up Nginx"
nginx -g 'daemon off;'