FROM nginx:latest

WORKDIR /tmp/jbrowse

# Install curl & unzip, download JBrowse, and extract to /tmp/jbrowse
RUN apt-get update && apt-get install -y curl unzip && \
    curl -fsSL https://github.com/GMOD/jbrowse-components/releases/download/v3.0.5/jbrowse-web-v3.0.5.zip -o jbrowse-web.zip && \
    unzip -o jbrowse-web.zip && rm jbrowse-web.zip

# Copy a custom startup script into the container
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Use our script as the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80



