from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uuid

app = FastAPI(title="Payment Service")

class PaymentRequest(BaseModel):
    order_id: str
    amount: float

@app.post("/process-payment")
async def process_payment(request: PaymentRequest):
    # Simulação de lógica de negócio
    if request.amount <= 0:
        raise HTTPException(status_code=400, detail="Invalid amount")
    
    return {
        "payment_id": str(uuid.uuid4()),
        "status": "APPROVED",
        "order_id": request.order_id
    }