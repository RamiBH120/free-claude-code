# Use the official uv image
FROM ghcr.io/astral-sh/uv:python3.14-bookworm-slim

# Set working directory
WORKDIR /app

# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# COPY ALL metadata files needed for the build backend (Hatch)
# We include README.md because pyproject.toml references it
COPY pyproject.toml uv.lock README.md ./

# Install dependencies 
# We use --no-install-project to only install the libraries
# This avoids the "README not found" or "Source not found" errors during the lib install phase
RUN uv sync --frozen --no-dev --no-install-project

# Now copy the rest of the application code
COPY . .

# Final sync to include the local project code now that all files are present
RUN uv sync --frozen --no-dev

# Railway uses the PORT environment variable
ENV PORT=8082
EXPOSE 8082

# Start the server
CMD ["uv", "run", "uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8082"]
