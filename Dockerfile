# Use an official Python runtime as a base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Install necessary dependencies including git
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*
    
# Copy only the repository directory into the container
COPY . /app/

# Make sure the entrypoint script is executable
RUN chmod +x /app/.github/scripts/entrypoint.sh

# Set the entry point for the container
ENTRYPOINT ["/bin/bash", "/app/.github/scripts/entrypoint.sh"]
