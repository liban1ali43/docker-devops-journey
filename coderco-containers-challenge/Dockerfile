# Stage 1: Build & Dependencies
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Minimal Runtime Image
FROM python:3.11-slim AS runner

# Create non-root user
RUN groupadd --gid 1001 ali && \
    useradd --uid 1001 --gid ali --shell /bin/bash --create-home ali

WORKDIR /app

# Copy installed dependencies from builder
COPY --from=builder /install /usr/local

# Copy application code and templates with proper ownership
COPY --chown=ali:ali app.py .
COPY --chown=ali:ali templates ./templates
USER ali

EXPOSE 5004
CMD ["gunicorn", "--bind", "0.0.0.0:5004", "--workers", "2", "app:app"]

