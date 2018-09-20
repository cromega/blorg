FROM alpine:latest

RUN apk update && apk add nginx && mkdir -p /run/nginx

COPY _site/ /var/www/alphaandcromega/
COPY nginx.conf /etc/nginx/conf.d/alphaandcromega.conf

CMD ["nginx", "-g", "daemon off;"]

