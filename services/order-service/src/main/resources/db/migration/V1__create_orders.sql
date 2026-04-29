CREATE TABLE orders (
    id UUID PRIMARY KEY,
    customer_email VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    -- Índice para performance em buscas frequentes
    INDEX idx_orders_customer (customer_email)
);