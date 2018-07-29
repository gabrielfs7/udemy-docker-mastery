# Using image of nginx version 1.13
FROM nginx:1.13

# It is replacing existent Nginx configuration with 'nginx.conf'
COPY nginx.conf /etc/nginx/conf.d/default.conf