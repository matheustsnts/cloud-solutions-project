# Estágio 1: Build
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
# Instala dependências em um diretório isolado
RUN pip install --user --no-cache-dir -r requirements.txt

# Estágio 2: Runtime
FROM python:3.11-slim
WORKDIR /app

# Copia apenas as dependências instaladas do builder
COPY --from=builder /root/.local /root/.local
COPY . .

# Garante que o path do Python veja as libs instaladas
ENV PATH=/root/.local/bin:$PATH

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]