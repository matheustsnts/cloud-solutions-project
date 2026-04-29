from fastapi import FastAPI, Request
import logging
import json

app = FastAPI(title="Payment Service")

# Configuração de log em JSON simples
logger = logging.getLogger("payment_service")
logger.setLevel(logging.INFO)
handler = logging.StreamHandler()
logger.addHandler(handler)

@app.middleware("http")
async def log_requests(request: Request, call_next):
    # Captura o ID que o Java enviou
    correlation_id = request.headers.get("X-Correlation-ID", "unknown")
    
    response = await call_next(request)
    
    # Log estruturado em JSON
    log_data = {
        "app_name": "payment-service",
        "correlationId": correlation_id,
        "method": request.method,
        "path": request.url.path,
        "status": response.status_code
    }
    logger.info(json.dumps(log_data))
    
    return response

@app.post("/process-payment")
async def process_payment(order_id: str):
    return {"status": "APPROVED", "order_id": order_id}