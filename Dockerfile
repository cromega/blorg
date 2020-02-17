FROM alpine:latest

RUN apk update && \
    apk add nginx && \
    mkdir -p /run/nginx

COPY _site/ /var/www/localhost/htdocs/
COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]

