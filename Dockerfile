# builder stage
FROM python:3.12-alpine AS builder
RUN apk add --no-cache gcc musl-dev libffi-dev
WORKDIR /app
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt

# final stage
FROM python:3.12-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .
RUN chown -R app:app /app
USER app

EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=5s CMD wget -qO- http://localhost:5000/ || exit 1
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]