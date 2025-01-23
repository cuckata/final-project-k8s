#!/bin/bash
set -e

# Example smoke tests
echo "Running smoke tests..."

# Check if a service starts correctly
curl -s http://a02efe548514541ae9bef05814b43377-1317879840.eu-central-1.elb.amazonaws.com/ || {
  echo "Health check failed!";
  exit 1;
}

echo "Smoke tests passed!"