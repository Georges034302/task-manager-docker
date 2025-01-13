# Use an official Python runtime as a base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the entire repository into the container
COPY . /app

# Install any required Python packages (you can list them in a requirements.txt if needed)
# RUN pip install --no-cache-dir -r requirements.txt

# Make sure the entrypoint script is executable
RUN chmod +x .github/scripts/entrypoint.sh

# Set the entry point for the container
ENTRYPOINT ["/bin/bash", ".github/scripts/entrypoint.sh"]
