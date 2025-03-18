# Use an official lightweight web server
FROM nginx:latest

# Set working directory
WORKDIR /usr/share/nginx/html

# Install dependencies, download JBrowse, extract, and clean up in one step
RUN apt-get update && apt-get install -y curl unzip && \
    curl -fsSL https://github.com/GMOD/jbrowse-components/releases/download/v3.0.5/jbrowse-web-v3.0.5.zip -o jbrowse-web.zip && \
    ls -lh && df -h && \
    unzip -o jbrowse-web.zip && \
    ls -lh && \
    rm jbrowse-web.zip

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the default web port
EXPOSE 80


