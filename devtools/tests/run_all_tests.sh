#!/usr/bin/env bash
set -euo pipefail

echo "Running comprehensive SQL tests..."

# Run the smoke tests first
echo "Running smoke tests..."
bash devtools/tests/sql-smoke/run_tests.sh

echo "All tests completed."