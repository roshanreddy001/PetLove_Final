@echo off
REM PetLove Production Deployment Script for Windows
setlocal enabledelayedexpansion

echo 🐾 Starting PetLove deployment...

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not installed. Please install Docker Desktop first.
    pause
    exit /b 1
)

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker Compose is not available. Please install Docker Compose.
    pause
    exit /b 1
)

REM Check if .env.prod exists
if not exist ".env.prod" (
    echo [WARNING] .env.prod file not found. Creating from template...
    copy ".env.production" ".env.prod"
    echo [WARNING] Please edit .env.prod with your production values before running again.
    pause
    exit /b 1
)

echo [INFO] Building PetLove application...
docker-compose -f docker-compose.prod.yml build --no-cache

if errorlevel 1 (
    echo [ERROR] Build failed. Please check the output above.
    pause
    exit /b 1
)

echo [INFO] Starting services...
docker-compose -f docker-compose.prod.yml up -d

if errorlevel 1 (
    echo [ERROR] Failed to start services. Please check the output above.
    pause
    exit /b 1
)

echo [INFO] Waiting for services to be healthy...
timeout /t 30 /nobreak >nul

REM Check if services are running
docker-compose -f docker-compose.prod.yml ps | findstr "Up" >nul
if errorlevel 1 (
    echo [ERROR] ❌ Deployment failed. Check logs with: docker-compose -f docker-compose.prod.yml logs
    pause
    exit /b 1
) else (
    echo [INFO] ✅ PetLove deployed successfully!
    echo [INFO] 🌐 Application is available at: http://localhost
    echo [INFO] 📊 API documentation: http://localhost/docs
    echo.
    echo [INFO] To view logs: docker-compose -f docker-compose.prod.yml logs -f
    echo [INFO] To stop: docker-compose -f docker-compose.prod.yml down
    pause
)
