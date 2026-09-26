FROM python:3.8-slim

# Create the user with a home directory (/home/liban)
RUN groupadd --gid 1000 liban && \
    useradd --uid 1000 --gid liban --create-home --shell /bin/bash liban

# Create the app dir owned by liban, BEFORE switching user
RUN mkdir -p /home/liban/app && \
    chown -R liban:liban /home/liban/app

# Set working directory directly inside the user's home directory
WORKDIR /home/liban/app

# Install system dependencies (needed to compile mysqlclient)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY --chown=liban:liban requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app files with correct ownership
COPY --chown=liban:liban app.py .

# Switch to non-root user
USER liban

EXPOSE 5002
CMD ["python", "app.py"]
