# Use the official Nginx image as the base image
FROM nginx:alpine

# Create necessary directories
RUN mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled /etc/nginx/ssl

# Copy the build output to the Nginx html directory
COPY ./build/web /usr/share/nginx/html

# Copy configuration files
COPY ./cors_configs.conf /etc/nginx/snippets/cors_configs.conf
COPY ./nobi.pabloubeiracarramal.com.conf /etc/nginx/sites-available/nobi.pabloubeiracarramal.com.conf
COPY ./cors_sites.conf /etc/nginx/snippets/cors-sites.conf
COPY ./cors_map.conf /etc/nginx/snippets/cors_map.conf

# Copy SSL certificates
COPY ./ssl/nginx.crt /etc/nginx/ssl/nginx.crt
COPY ./ssl/nginx.key /etc/nginx/ssl/nginx.key

# Create a symbolic link for the site configuration
RUN ln -s /etc/nginx/sites-available/nobi.pabloubeiracarramal.com.conf /etc/nginx/sites-enabled/

# Ensure the main Nginx configuration file includes the snippets in the correct contexts
RUN sed -i '/http {/a \\tinclude /etc/nginx/snippets/cors_map.conf;' /etc/nginx/nginx.conf
RUN sed -i '/http {/a \\tinclude /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf

# Expose ports 80 and 443
EXPOSE 80 443

# Start Nginx when the container has started
CMD ["nginx", "-g", "daemon off;"]
