FROM alpine:latest

RUN apk update && apk add nginx && mkdir -p /run/nginx

COPY _site/ /var/www/thethings/
COPY nginx.conf /etc/nginx/conf.d/thething.conf

CMD ["nginx", "-g", "daemon off;"]

