#!/bin/bash

# Check for a JBrowse-specific file instead of index.html
if [ ! -f /usr/share/nginx/html/manifest.json ]; then
  echo "Copying JBrowse files to volume..."
  cp -r /tmp/jbrowse/* /usr/share/nginx/html/
else
  echo "JBrowse already present in volume"
fi

nginx -g "daemon off;"

