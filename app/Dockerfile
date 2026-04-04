# Multi-stage build — fixed for non-root + read-only fs
FROM python:3.12-slim AS builder
WORKDIR /build

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.12-slim AS final
WORKDIR /app

# Create non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Copy installed packages — explicitly add to known system path
COPY --from=builder /install/lib /usr/local/lib
COPY --from=builder /install/bin /usr/local/bin

# Copy app code
COPY app.py .

# Set ownership
RUN chown -R appuser:appgroup /app

USER appuser

ENV APP_VERSION=1.1.0
ENV ENVIRONMENT=dev
# Explicitly set PATH so gunicorn is found by non-root user
ENV PATH="/usr/local/bin:$PATH"
# Tell Python where to find the installed packages
ENV PYTHONPATH="/usr/local/lib/python3.12/site-packages"
# Prevent Python from writing .pyc files (fixes read-only fs)
ENV PYTHONDONTWRITEBYTECODE=1
# Prevent Python from buffering stdout (better logs in K8s)
ENV PYTHONUNBUFFERED=1

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health/live')"

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--timeout", "30", \
     "--worker-tmp-dir", "/tmp", "app:app"]