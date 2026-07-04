#!/bin/bash

# OpenEMR Setup and Run Script
# This script sets up and starts the OpenEMR application using Docker

set -e

echo "=========================================="
echo "  OpenEMR Setup and Run Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available (try both versions)
DOCKER_COMPOSE="docker compose"
if ! docker compose version &> /dev/null; then
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE="docker-compose"
    else
        echo -e "${RED}Error: Docker Compose is not available${NC}"
        echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
        exit 1
    fi
fi

echo -e "${GREEN}✓${NC} Docker and Docker Compose are installed"
echo ""

# Check if docker-compose.yml exists, if not copy from production example
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${YELLOW}No docker-compose.yml found. Copying from production example...${NC}"
    if [ -f "docker/production/docker-compose.yml" ]; then
        cp docker/production/docker-compose.yml docker-compose.yml
        echo -e "${GREEN}✓${NC} Created docker-compose.yml from production example"
    else
        echo -e "${RED}Error: Production docker-compose.yml template not found${NC}"
        exit 1
    fi
    echo ""
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo -e "${YELLOW}No .env file found. Copying from .env.example...${NC}"
        cp .env.example .env
        echo -e "${GREEN}✓${NC} Created .env file"
        echo ""
    fi
fi

# Install PHP dependencies if vendor directory doesn't exist
if [ ! -d "vendor" ]; then
    echo -e "${YELLOW}Installing PHP dependencies...${NC}"
    if command -v composer &> /dev/null; then
        composer install --no-dev
        echo -e "${GREEN}✓${NC} PHP dependencies installed"
    else
        echo -e "${YELLOW}Warning: Composer not found. Skipping PHP dependency installation.${NC}"
        echo "The Docker container will handle this."
    fi
    echo ""
fi

# Install Node dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}Installing Node.js dependencies...${NC}"
    if command -v npm &> /dev/null; then
        npm install
        echo -e "${GREEN}✓${NC} Node.js dependencies installed"
        echo ""
        echo -e "${YELLOW}Building frontend assets...${NC}"
        npm run build
        echo -e "${GREEN}✓${NC} Frontend assets built"
    else
        echo -e "${YELLOW}Warning: npm not found. Skipping Node dependency installation.${NC}"
        echo "The Docker container will handle this."
    fi
    echo ""
fi

# Start Docker containers
echo "=========================================="
echo "  Starting OpenEMR Docker Containers"
echo "=========================================="
echo ""

# Force recreate containers to handle any configuration changes
$DOCKER_COMPOSE up -d --force-recreate --remove-orphans

echo ""
echo -e "${GREEN}✓${NC} Docker containers started successfully!"
echo ""
echo "=========================================="
echo "  OpenEMR Access Information"
echo "=========================================="
echo ""
echo "  HTTP:  http://localhost:8080"
echo "  HTTPS: https://localhost:8443"
echo ""
echo "  Default Credentials:"
echo "    Username: admin"
echo "    Password: pass"
echo ""
echo "  Note: Initial setup may take 5-10 minutes."
echo "  Check logs with: $DOCKER_COMPOSE logs -f"
echo ""
echo "=========================================="
