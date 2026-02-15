#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/../.."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color


services=(
  "devoops-gateway-service"
  "devoops-user-service"
  "devoops-accommodation-service"
  "devoops-notification-service"
  "devoops-rating-service"
  "devoops-reservation-service"
  "devoops-search-service"
  "devoops-frontend"
  "devoops-core"
)

print_separator() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

for service in "${services[@]}"; do
    SERVICE_PATH="$ROOT_DIR/$service"

    if [ ! -d "$SERVICE_PATH" ]; then
        echo -e "${RED}✗ $service - directory not found${NC}"
        continue
    fi

    if [ ! -d "$SERVICE_PATH/.git" ]; then
        echo -e "${YELLOW}⚠ $service - not a git repository${NC}"
        continue
    fi

    cd "$SERVICE_PATH"

    print_separator
    echo -e "${BOLD}${CYAN}📦 $service${NC}"
    print_separator

    # Get current branch
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    echo -e "${BOLD}Branch:${NC} ${GREEN}$BRANCH${NC}"

    # Get current commit hash and message
    COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null)
    COMMIT_MSG=$(git log -1 --pretty=format:"%s" 2>/dev/null)
    COMMIT_DATE=$(git log -1 --pretty=format:"%cr" 2>/dev/null)
    echo -e "${BOLD}Commit:${NC} ${YELLOW}$COMMIT_HASH${NC} - $COMMIT_MSG"
    echo -e "${BOLD}Date:${NC}   $COMMIT_DATE"

    if [ "$HAS_UPDATES" = false ]; then
        echo -e "  ${GREEN}✓ Up to date with all remotes${NC}"
    fi

    # Check for local uncommitted changes
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        echo ""
        echo -e "  ${YELLOW}⚠ Has uncommitted changes${NC}"
    fi

    echo ""
done

print_separator
echo -e "${BOLD}${CYAN}Summary complete${NC}"
print_separator
