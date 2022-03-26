FROM nginx

RUN rm /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
COPY nginx.conf /etc/nginx/nginx.conf
COPY domain.crt /etc/nginx/ssl/domain.crt
COPY int.crt /etc/nginx/ssl/int.crt
RUN cat /etc/nginx/ssl/int.crt >> /etc/nginx/ssl/domain.crt
COPY domain.key /etc/nginx/ssl/domain.key
