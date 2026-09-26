FROM python:3.11-slim

RUN groupadd --gid 1000 liban && \
    useradd --uid 1000 --gid liban --create-home --shell /bin/bash liban

WORKDIR /home/liban/app

COPY --chown=liban:liban requirements.txt .

# Install MariaDB dev files (needed to compile the Python mariadb driver)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libmariadb-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=liban:liban app.py .
COPY --chown=liban:liban templates ./templates

USER liban

EXPOSE 5003
CMD ["python", "app.py"]
