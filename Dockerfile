# --- builder stage ---
    FROM python:3.12-slim AS builder
    WORKDIR /app
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt
    
    # --- final stage ---
    FROM python:3.12-slim
    WORKDIR /app
    
    # Copier uniquement les paquets installés et le code
    COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
    COPY app ./app
    COPY --from=builder /app/requirements.txt .
    
    # Installer gunicorn
    RUN pip install --no-cache-dir gunicorn
    
    ENV FLASK_APP=app.main:create_app
    ENV PATH="/root/.local/bin:$PATH"
    EXPOSE 5000
    
    # Healthcheck Docker
    HEALTHCHECK --interval=30s --timeout=5s CMD curl -f http://localhost:5000/ || exit 1
    
    # Commande de démarrage
    CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app.main:create_app"]
    