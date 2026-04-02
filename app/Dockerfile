FROM python:3.12-slim AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.13-slim AS final
WORKDIR /app

# Security
# Run as non-root 
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY --from=builder /root/.local /home/appuser/.local
COPY app.py .

RUN chown -R appuser:appgroup /app
USER appuser

ENV PATH=/home/appuser/.local/bin:$PATH
ENV APP_VERSION=1.0.0
ENV ENVIRONMENT=dev

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health/live')"

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--timeout", "30", "app:app"]