# Use the official uv image which includes the high-performance installer
FROM ghcr.io/astral-sh/uv:python3.14-bookworm-slim

# Set working directory
WORKDIR /app

# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy the project configuration files first to leverage Docker caching
COPY pyproject.toml uv.lock ./

# Install dependencies
# --frozen ensures we use the exact versions in uv.lock
RUN uv sync --frozen --no-dev

# Copy the rest of the application code
COPY . .

# Railway uses the PORT environment variable; we default to 8082 for local 
ENV PORT=8082
EXPOSE 8082

# Start the server using uv to ensure the 3.14 virtualenv is active
CMD ["uv", "run", "uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8082"]
