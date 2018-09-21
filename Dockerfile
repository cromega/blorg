FROM alpine:latest

RUN apk update && \
    apk add nginx && \
    mkdir -p /run/nginx && \
    rm /etc/nginx/conf.d/default.conf

COPY _site/ /var/www/
COPY nginx.conf /etc/nginx/conf.d/blog.conf

CMD ["nginx", "-g", "daemon off;"]

