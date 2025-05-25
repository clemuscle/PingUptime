# — builder stage —
FROM python:3.12-slim AS builder
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# — final stage —
FROM python:3.12-slim
WORKDIR /app

# Installer runtime et gunicorn
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY requirements.txt .
RUN pip install --no-cache-dir gunicorn

# Copier tout le code, y compris app.py à la racine
COPY . .

EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=5s CMD curl -f http://localhost:5000/ || exit 1

# Démarrer Gunicorn en pointant sur app.py
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
