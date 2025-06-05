# API RESTful para Sistema Bancario

Esta API implementa un backend para gestionar cuentas bancarias y transacciones, basado en el ejercicio grupal entregado en la P3.

## Requisitos Previos

- Ruby 3.0.0 o superior
- Rails 7.0.0 o superior
- PostgreSQL

## Instalación

1. Clonar el repositorio:
```bash
git clone https://github.com/pablotl0/ej_ds_examen.git
cd bank_api
```

2. Instalar las dependencias:
```bash
bundle install
```

3. Configurar la base de datos (editar `config/database.yml` según sea necesario)

4. Crear y migrar la base de datos:
```bash
rails db:create db:migrate
```

5. (Opcional) Cargar datos de ejemplo:
```bash
rails db:seed
```

6. Iniciar el servidor:
```bash
rails server
```

El servidor estará disponible en `http://localhost:3000`.

## Endpoints de la API

### Usuarios

- `GET /api/v1/users` - Listar todos los usuarios
- `GET /api/v1/users/:id` - Mostrar un usuario específico
- `POST /api/v1/users` - Crear un nuevo usuario
- `PUT /api/v1/users/:id` - Actualizar un usuario
- `DELETE /api/v1/users/:id` - Eliminar un usuario
- `POST /api/v1/users/new_user` - Crear o resetear un usuario (método especial)
- `POST /api/v1/users/:id/set_current` - Establecer un usuario como actual

### Cuentas

- `GET /api/v1/users/:user_id/accounts` - Listar todas las cuentas de un usuario
- `GET /api/v1/accounts/:id` - Mostrar una cuenta específica
- `POST /api/v1/users/:user_id/accounts` - Crear una nueva cuenta para un usuario
- `PUT /api/v1/accounts/:id` - Actualizar una cuenta
- `DELETE /api/v1/accounts/:id` - Eliminar una cuenta

### Transacciones

- `GET /api/v1/accounts/:account_id/transactions` - Listar todas las transacciones de una cuenta
- `POST /api/v1/accounts/:account_id/transactions/deposit` - Realizar un depósito
- `POST /api/v1/accounts/:account_id/transactions/withdrawal` - Realizar un retiro
- `POST /api/v1/accounts/:account_id/transactions/transfer` - Realizar una transferencia

## Ejemplos de Uso

### Crear un usuario
```bash
curl -X POST -H "Content-Type: application/json" -d '{"user":{"name":"juan"}}' http://localhost:3000/api/v1/users/new_user
```

### Crear una cuenta adicional
```bash
curl -X POST http://localhost:3000/api/v1/users/1/accounts
```

### Realizar un depósito
```bash
curl -X POST -H "Content-Type: application/json" -d '{"transaction":{"amount":100}}' http://localhost:3000/api/v1/accounts/juan-0/transactions/deposit
```

### Realizar un retiro
```bash
curl -X POST -H "Content-Type: application/json" -d '{"transaction":{"amount":50}}' http://localhost:3000/api/v1/accounts/juan-0/transactions/withdrawal
```

### Realizar una transferencia
```bash
curl -X POST -H "Content-Type: application/json" -d '{"transaction":{"amount":25,"destiny_account_id":"juan-1"}}' http://localhost:3000/api/v1/accounts/juan-0/transactions/transfer
```

### Ver transacciones de una cuenta
```bash
curl http://localhost:3000/api/v1/accounts/juan-0/transactions
```
