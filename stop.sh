#!/bin/bash

# OpenEMR Stop Script
# This script stops all OpenEMR Docker containers

set -e

echo "=========================================="
echo "  OpenEMR Stop Script"
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
    exit 1
fi

# Check if Docker Compose is available (try both versions)
DOCKER_COMPOSE="docker compose"
if ! docker compose version &> /dev/null; then
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE="docker-compose"
    else
        echo -e "${RED}Error: Docker Compose is not available${NC}"
        exit 1
    fi
fi

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}Error: docker-compose.yml not found${NC}"
    echo "Are you in the correct directory?"
    exit 1
fi

# Stop containers
echo -e "${YELLOW}Stopping OpenEMR containers...${NC}"
$DOCKER_COMPOSE down

echo ""
echo -e "${GREEN}✓${NC} OpenEMR containers stopped successfully!"
echo ""
echo "To remove volumes and data, run: $DOCKER_COMPOSE down -v"
echo "To view stopped containers, run: docker ps -a"
echo ""
