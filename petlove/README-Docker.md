# 🐾 PetLove Docker Deployment Guide

This guide will help you deploy the PetLove application using Docker for production.

## 📋 Prerequisites

- Docker Desktop installed
- Docker Compose installed
- At least 2GB RAM available
- Port 80 (or your chosen port) available

## 🚀 Quick Start

### 1. Clone and Navigate
```bash
git clone <your-repo>
cd petlove
```

### 2. Configure Environment
```bash
# Copy the production environment template
cp .env.production .env.prod

# Edit the production environment file
# Update MONGO_ROOT_PASSWORD and other sensitive values
```

### 3. Deploy

**On Windows:**
```cmd
deploy.bat
```

**On Linux/Mac:**
```bash
chmod +x deploy.sh
./deploy.sh
```

**Manual deployment:**
```bash
docker-compose -f docker-compose.prod.yml up -d --build
```

## 📁 Docker Files Overview

- `Dockerfile` - Multi-stage build for React frontend + FastAPI backend
- `docker-compose.yml` - Development environment
- `docker-compose.prod.yml` - Production environment with security
- `.dockerignore` - Excludes unnecessary files from build
- `nginx.conf` - Reverse proxy configuration
- `init-mongo.js` - MongoDB initialization script

## 🔧 Configuration

### Environment Variables (.env.prod)
```env
MONGO_ROOT_PASSWORD=your_secure_password
MONGODB_URI=mongodb://admin:password@mongodb:27017/petlove?authSource=admin
PORT=8000
APP_PORT=80
ENVIRONMENT=production
```

### MongoDB Setup
The application uses MongoDB as the database. In production:
- MongoDB runs in a separate container
- Data is persisted using Docker volumes
- Database is initialized with proper collections and indexes

## 🌐 Access Points

After deployment:
- **Application**: http://localhost (or your configured port)
- **API Documentation**: http://localhost/docs
- **API Base**: http://localhost/api

## 📊 Monitoring

### View Logs
```bash
# All services
docker-compose -f docker-compose.prod.yml logs -f

# Specific service
docker-compose -f docker-compose.prod.yml logs -f petlove-app
```

### Check Status
```bash
docker-compose -f docker-compose.prod.yml ps
```

### Health Check
```bash
curl http://localhost/api
```

## 🛠️ Management Commands

### Start Services
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Stop Services
```bash
docker-compose -f docker-compose.prod.yml down
```

### Restart Services
```bash
docker-compose -f docker-compose.prod.yml restart
```

### Update Application
```bash
# Pull latest code
git pull

# Rebuild and restart
docker-compose -f docker-compose.prod.yml up -d --build
```

## 🔒 Security Features

- MongoDB not exposed to host network in production
- Nginx reverse proxy with rate limiting
- Security headers configured
- Gzip compression enabled
- Health checks implemented

## 🐛 Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Change APP_PORT in .env.prod
   APP_PORT=8080
   ```

2. **MongoDB connection failed**
   ```bash
   # Check MongoDB container
   docker-compose -f docker-compose.prod.yml logs mongodb
   ```

3. **Frontend not loading**
   ```bash
   # Check if build completed successfully
   docker-compose -f docker-compose.prod.yml logs petlove-app
   ```

### Reset Everything
```bash
# Stop and remove all containers, networks, and volumes
docker-compose -f docker-compose.prod.yml down -v
docker system prune -f

# Rebuild from scratch
docker-compose -f docker-compose.prod.yml up -d --build
```

## 📈 Scaling

To scale the application:
```bash
# Scale app instances
docker-compose -f docker-compose.prod.yml up -d --scale petlove-app=3
```

## 🌍 Cloud Deployment

This Docker setup is ready for cloud deployment on:
- AWS ECS/EKS
- Google Cloud Run/GKE
- Azure Container Instances/AKS
- DigitalOcean App Platform
- Heroku Container Registry

## 📞 Support

If you encounter issues:
1. Check the logs using the commands above
2. Verify your .env.prod configuration
3. Ensure Docker has sufficient resources
4. Check firewall settings for port access
