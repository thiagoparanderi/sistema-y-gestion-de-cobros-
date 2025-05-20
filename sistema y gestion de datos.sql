-- 1. Roles
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50)
    INSERT INTO roles (nombre) VALUES ('Administrador'), ('Operador');
);

-- 2. Usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    password TEXT,
    rol_id INT REFERENCES roles(id)
);

-- 3. Clientes
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20)
    UPDATE clientes SET telefono = '1234567890' WHERE id = 1;
    JOIN clientes c ON f.cliente_id = c.id;
    -- Clientes con facturas mayores a $1000
SELECT * FROM facturas WHERE total > 1000;
-- Clientes sin pagos registrados
SELECT * FROM clientes WHERE id NOT IN (
    SELECT DISTINCT cliente_id FROM facturas f JOIN pagos p ON p.factura_id = f.id
);

-- 4. Direcciones
CREATE TABLE direcciones (
    id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id),
    direccion TEXT,
    ciudad VARCHAR(50),
    pais VARCHAR(50)
);

-- 5. Productos
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    precio_unitario DECIMAL(10,2)
    DELETE FROM productos WHERE id = 5;
    -- Buscar productos que contienen 'servicio'
SELECT * FROM productos WHERE nombre ILIKE '%servicio%';
);

-- 6. Servicios
CREATE TABLE servicios (
    id SERIAL PRIMARY KEY,
    descripcion TEXT,
    precio_base DECIMAL(10,2)
);

-- 7. Impuestos
CREATE TABLE impuestos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    porcentaje DECIMAL(5,2)
);

-- 8. Descuentos
CREATE TABLE descuentos (
    id SERIAL PRIMARY KEY,
    descripcion TEXT,
    porcentaje DECIMAL(5,2)
);

-- 9. Monedas
CREATE TABLE monedas (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(3),
    descripcion VARCHAR(50)
);

-- 10. Métodos de Pago
CREATE TABLE metodos_pago (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(50)
    INSERT INTO metodos_pago (tipo) VALUES ('Efectivo'), ('Transferencia'), ('Tarjeta');
    INSERT INTO monedas (codigo, descripcion) VALUES ('USD', 'Dólar estadounidense');
    -- Total recaudado por método de pago
SELECT mp.tipo, SUM(p.monto)
FROM pagos p
JOIN metodos_pago mp ON p.metodo_pago_id = mp.id
GROUP BY mp.tipo;
);

-- 11. Facturas
CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id),
    usuario_id INT REFERENCES usuarios(id),
    fecha_emision DATE,
    estado_id INT,
    moneda_id INT REFERENCES monedas(id),
    descuento_id INT,
    impuesto_id INT,
    total DECIMAL(10,2),
    FOREIGN KEY (estado_id) REFERENCES estados_factura(id),
    FOREIGN KEY (descuento_id) REFERENCES descuentos(id),
    FOREIGN KEY (impuesto_id) REFERENCES impuestos(id)
    CREATE VIEW vista_facturas_completas AS
    -- Facturas emitidas entre dos fechas
SELECT * FROM facturas WHERE fecha_emision BETWEEN '2024-01-01' AND '2024-12-31';
);

-- 12. Estados de Factura
CREATE TABLE estados_factura (
    id SERIAL PRIMARY KEY,
    estado VARCHAR(30)
);

-- 13. Detalles de Factura
CREATE TABLE detalles_factura (
    id SERIAL PRIMARY KEY,
    factura_id INT REFERENCES facturas(id),
    producto_id INT,
    servicio_id INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (servicio_id) REFERENCES servicios(id)
);

-- 14. Pagos
CREATE TABLE pagos (
    id SERIAL PRIMARY KEY,
    factura_id INT REFERENCES facturas(id),
    metodo_pago_id INT REFERENCES metodos_pago(id),
    fecha_pago DATE,
    monto DECIMAL(10,2)
);

-- 15. Comprobantes de Pago
CREATE TABLE comprobantes_pago (
    id SERIAL PRIMARY KEY,
    pago_id INT REFERENCES pagos(id),
    numero_comprobante VARCHAR(50),
    fecha_emision DATE
);

-- 16. Cuentas Bancarias
CREATE TABLE cuentas_bancarias (
    id SERIAL PRIMARY KEY,
    banco VARCHAR(100),
    numero_cuenta VARCHAR(30),
    tipo_cuenta VARCHAR(30)
);

-- 17. Transacciones Bancarias
CREATE TABLE transacciones_bancarias (
    id SERIAL PRIMARY KEY,
    cuenta_id INT REFERENCES cuentas_bancarias(id),
    pago_id INT REFERENCES pagos(id),
    fecha DATE,
    referencia VARCHAR(100)
);

-- 18. Historial de Crédito
CREATE TABLE historial_credito (
    id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id),
    fecha DATE,
    monto DECIMAL(10,2),
    tipo VARCHAR(20) -- crédito o débito
);

-- 19. Notas de Crédito
CREATE TABLE notas_credito (
    id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id),
    factura_id INT REFERENCES facturas(id),
    monto DECIMAL(10,2),
    fecha DATE
);

-- 20. Ajustes de Precio
CREATE TABLE ajustes_precio (
    id SERIAL PRIMARY KEY,
    producto_id INT REFERENCES productos(id),
    nuevo_precio DECIMAL(10,2),
    fecha_inicio DATE
);

-- 21. Cobros Pendientes
CREATE TABLE cobros_pendientes (
    id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id),
    factura_id INT REFERENCES facturas(id),
    monto_pendiente DECIMAL(10,2),
    fecha_vencimiento DATE
);