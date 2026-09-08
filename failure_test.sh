#!/usr/bin/env bash
set -e

URL="http://localhost:8080/instance"

echo "=== 1. Checking baseline (Both apps should be running) ==="
curl -s $URL
echo -e "\n"

echo "=== 2. Stopping app-01 to simulate failure ==="
docker compose stop app-01
sleep 2

echo "=== 3. Testing traffic during app-01 failure (Should route to app-02) ==="
for i in {1..3}; do
    echo -n "Request $i: "
    curl -s $URL
    echo ""
    sleep 1
done

echo -e "\n=== 4. Recovering app-01 ==="
docker compose start app-01
# Wait a few seconds for health checks to pass
sleep 5

echo "=== 5. Verifying recovery (Traffic should balance again) ==="
for i in {1..4}; do
    echo -n "Request $i: "
    curl -s $URL
    echo ""
    sleep 1
done

echo -e "\nFailure Test Completed Successfully! ✅"
