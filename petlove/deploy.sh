#!/bin/bash

# PetLove Production Deployment Script
set -e

echo "🐾 Starting PetLove deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if .env.prod exists
if [ ! -f .env.prod ]; then
    print_warning ".env.prod file not found. Creating from template..."
    cp .env.production .env.prod
    print_warning "Please edit .env.prod with your production values before running again."
    exit 1
fi

# Load environment variables
source .env.prod

# Validate required environment variables
if [ -z "$MONGO_ROOT_PASSWORD" ]; then
    print_error "MONGO_ROOT_PASSWORD is not set in .env.prod"
    exit 1
fi

print_status "Building PetLove application..."
docker-compose -f docker-compose.prod.yml build --no-cache

print_status "Starting services..."
docker-compose -f docker-compose.prod.yml up -d

print_status "Waiting for services to be healthy..."
sleep 30

# Check if services are running
if docker-compose -f docker-compose.prod.yml ps | grep -q "Up"; then
    print_status "✅ PetLove deployed successfully!"
    print_status "🌐 Application is available at: http://localhost:${APP_PORT:-80}"
    print_status "📊 API documentation: http://localhost:${APP_PORT:-80}/docs"
    
    echo ""
    print_status "To view logs: docker-compose -f docker-compose.prod.yml logs -f"
    print_status "To stop: docker-compose -f docker-compose.prod.yml down"
else
    print_error "❌ Deployment failed. Check logs with: docker-compose -f docker-compose.prod.yml logs"
    exit 1
fi
