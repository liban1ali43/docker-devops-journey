FROM python:3.8-slim AS build
WORKDIR /app
COPY requirements.txt . 
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt
# -- Stage 2: production image
FROM python:3.8-slim
RUN groupadd --gid 1001 amira && \
    useradd --uid 1001 --gid amira --shell /bin/bash --create-home amira    
COPY  --from=build /install /usr/local
WORKDIR /home/amira/app
COPY --chown=amira:amira app.py .
USER amira    
EXPOSE 5004
CMD ["python", "app.py"]
