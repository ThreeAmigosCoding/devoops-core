#!/bin/bash
#
# Setup Elasticsearch MCP Server for Docker Desktop
# Generates an API key and prints configuration instructions.
#
# Prerequisites:
#   - docker-compose stack is running (at least elasticsearch service)
#   - Elasticsearch security is enabled with ELASTIC_PASSWORD set in environment/.local.env
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../environment/.local.env"

# Load credentials from environment file
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: Environment file not found at $ENV_FILE"
  echo "Make sure environment/.local.env exists with ELASTIC_USERNAME and ELASTIC_PASSWORD."
  exit 1
fi

while IFS='=' read -r key value; do
  [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
  export "$key"="$value"
done < "$ENV_FILE"

ES_HOST="${ES_HOST:-localhost}"
ES_PORT="${ES_PORT:-9200}"
ES_URL="http://${ES_HOST}:${ES_PORT}"

echo "============================================"
echo " Elasticsearch MCP Server Setup"
echo "============================================"
echo ""

# Check if Elasticsearch is reachable
echo "Checking Elasticsearch at ${ES_URL}..."
if ! curl -sf -u "${ELASTIC_USERNAME}:${ELASTIC_PASSWORD}" "${ES_URL}/_cluster/health" > /dev/null 2>&1; then
  echo "ERROR: Cannot reach Elasticsearch at ${ES_URL}"
  echo ""
  echo "Make sure the docker-compose stack is running:"
  echo "  cd devoops-core && docker-compose up -d elasticsearch"
  echo ""
  echo "Then wait for it to be healthy:"
  echo "  docker-compose ps elasticsearch"
  exit 1
fi

echo "Elasticsearch is healthy."
echo ""

# Invalidate existing API keys with the same name
echo "Invalidating existing API keys..."
curl -sf -X DELETE "${ES_URL}/_security/api_key" \
  -u "${ELASTIC_USERNAME}:${ELASTIC_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d '{"name": "mcp-docker-desktop"}' > /dev/null 2>&1 || true

# Generate API key scoped to read-only access on log indices
echo "Generating API key..."
RESPONSE=$(curl -sf -X POST "${ES_URL}/_security/api_key" \
  -u "${ELASTIC_USERNAME}:${ELASTIC_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "mcp-docker-desktop",
    "role_descriptors": {
      "mcp_read_only": {
        "cluster": ["monitor"],
        "indices": [
          {
            "names": ["logs-*"],
            "privileges": ["read", "view_index_metadata", "monitor"]
          }
        ]
      }
    }
  }')

# Extract the encoded key (works with basic tools, no jq dependency)
ENCODED_KEY=$(echo "$RESPONSE" | grep -o '"encoded":"[^"]*"' | cut -d'"' -f4)

if [ -z "$ENCODED_KEY" ]; then
  echo "ERROR: Failed to generate API key."
  echo "Response: $RESPONSE"
  exit 1
fi

echo "API key generated successfully."
echo ""
echo "============================================"
echo " Docker Desktop MCP Server Configuration"
echo "============================================"
echo ""
echo "  1. Open Docker Desktop"
echo "  2. Go to MCP Toolkit"
echo "  3. Find or add the 'Elasticsearch' MCP server in Catalog"
echo "  4. Enter the following values:"
echo ""
echo "     URL:     http://host.docker.internal:${ES_PORT}"
echo "     API Key: ${ENCODED_KEY}"
echo ""
echo "  5. Save and enable the MCP server"
echo ""
echo "============================================"
echo ""
echo "NOTE: Use 'host.docker.internal' (not 'localhost')"
echo "      because the MCP server runs inside Docker's VM."
echo ""
