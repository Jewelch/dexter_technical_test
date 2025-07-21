#!/bin/bash

# Integration Test Runner Script
# Usage: ./scripts/integration_test.sh [device]
# Examples:
#   ./scripts/integration_test.sh chrome      # Run on Chrome browser
#   ./scripts/integration_test.sh ios         # Run on iOS Simulator
#   ./scripts/integration_test.sh android     # Run on Android Emulator

DEVICE=${1:-chrome}  # Default to chrome if no device specified

echo "🚀 Running Shift Handover E2E Tests on $DEVICE..."

flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/features/shift_handover/main/e2e_shift_handover_test.dart \
  -d $DEVICE