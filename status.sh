#!/bin/bash

# OpenEMR Status Script
# This script shows the status of OpenEMR Docker containers

set -e

echo "=========================================="
echo "  OpenEMR Status Check"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
    echo "Run ./run.sh first to set up OpenEMR"
    exit 1
fi

# Show container status
echo -e "${BLUE}Container Status:${NC}"
echo "----------------------------------------"
$DOCKER_COMPOSE ps
echo ""

# Check if containers are running
RUNNING=$($DOCKER_COMPOSE ps --services --filter "status=running" 2>/dev/null | wc -l)
TOTAL=$($DOCKER_COMPOSE ps --services 2>/dev/null | wc -l)

if [ "$RUNNING" -eq 0 ]; then
    echo -e "${RED}✗${NC} No containers are running"
    echo "Start OpenEMR with: ./run.sh"
elif [ "$RUNNING" -eq "$TOTAL" ]; then
    echo -e "${GREEN}✓${NC} All containers are running ($RUNNING/$TOTAL)"
else
    echo -e "${YELLOW}⚠${NC} Some containers are running ($RUNNING/$TOTAL)"
fi

echo ""

# Show resource usage if containers are running
if [ "$RUNNING" -gt 0 ]; then
    echo -e "${BLUE}Resource Usage:${NC}"
    echo "----------------------------------------"
    $DOCKER_COMPOSE top
    echo ""
    
    echo -e "${BLUE}Container Stats:${NC}"
    echo "----------------------------------------"
    docker stats --no-stream $($DOCKER_COMPOSE ps -q 2>/dev/null)
    echo ""
    
    echo -e "${BLUE}Health Status:${NC}"
    echo "----------------------------------------"
    for container in $($DOCKER_COMPOSE ps -q 2>/dev/null); do
        CONTAINER_NAME=$(docker inspect --format='{{.Name}}' "$container" | sed 's/\///')
        HEALTH=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "no healthcheck")
        
        if [ "$HEALTH" = "healthy" ]; then
            echo -e "  ${GREEN}✓${NC} $CONTAINER_NAME: $HEALTH"
        elif [ "$HEALTH" = "unhealthy" ]; then
            echo -e "  ${RED}✗${NC} $CONTAINER_NAME: $HEALTH"
        elif [ "$HEALTH" = "starting" ]; then
            echo -e "  ${YELLOW}⟳${NC} $CONTAINER_NAME: $HEALTH"
        else
            echo -e "  ${YELLOW}−${NC} $CONTAINER_NAME: $HEALTH"
        fi
    done
    echo ""
    
    echo -e "${BLUE}Access URLs:${NC}"
    echo "----------------------------------------"
    echo "  HTTP:  http://localhost:8080"
    echo "  HTTPS: https://localhost:8443"
    echo ""
    
    echo -e "${BLUE}Useful Commands:${NC}"
    echo "----------------------------------------"
    echo "  View logs:        $DOCKER_COMPOSE logs -f"
    echo "  View app logs:    $DOCKER_COMPOSE logs -f tabemr"
    echo "  View DB logs:     $DOCKER_COMPOSE logs -f mysql"
    echo "  Restart:          $DOCKER_COMPOSE restart"
    echo "  Stop:             ./stop.sh"
    echo ""
fi

echo "=========================================="
