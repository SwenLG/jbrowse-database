FROM python:3.9

# Set working directory inside the container
WORKDIR /scripts

# Copy all scripts into the container
COPY . .

# Install dependencies
RUN pip install --no-cache-dir psycopg2-binary

# Keep the container running so you can exec into it and run scripts manually
CMD ["tail", "-f", "/dev/null"]