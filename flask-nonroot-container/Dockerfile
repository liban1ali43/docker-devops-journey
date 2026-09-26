FROM python:3.8-slim
# Create the user with a home directory (/home/appuser)
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --create-home --shell /bin/bash appuser
# Create the app dir owned by appuser, BEFORE switching user
RUN mkdir -p /home/appuser/app && \
    chown -R appuser:appuser /home/appuser/app
# Set working directory directly inside the user's home directory  
WORKDIR /home/appuser/app
# Install dependencies
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir  -r requirements.txt
# Copy files and transfer ownership
COPY --chown=appuser:appuser app.py .
# Switch to non-root user
USER appuser
EXPOSE 5001
CMD ["python", "app.py"]
