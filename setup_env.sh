#!/bin/bash
echo "🚀 Iniciando setup do ambiente de desenvolvimento..."

# Criar redes do docker se não existirem
docker network create cloud-network || true

# Subir banco de dados primeiro
docker-compose up -d postgres

echo "⏳ Aguardando banco de dados estabilizar..."
sleep 5

# Rodar os serviços
docker-compose up -d --build

echo "✅ Ambiente pronto! Order Service em http://localhost:8080"
echo "✅ Payment Service em http://localhost:8000"