#!/usr/bin/env python3
"""Environment validation script for BARQ assessment."""
import sys
import urllib.request

CHECKS = [
    ("API Root (/)", "http://localhost:8090/"),
    ("Health Check (/healthz)", "http://localhost:8090/healthz"),
    ("Readiness Check (/ready)", "http://localhost:8090/ready"),
]

def run_checks():
    failed = False
    print("Running BARQ Assessment Validation Checks...\n")
    
    for name, url in CHECKS:
        try:
            req = urllib.request.Request(url, headers={"X-Request-ID": "validator-script"})
            with urllib.request.urlopen(req, timeout=3) as response:
                status = response.getcode()
                if status == 200:
                    print(f"[PASS] {name} -> Status {status}")
                else:
                    print(f"[FAIL] {name} -> Unexpected Status {status}")
                    failed = True
        except Exception as exc:
            print(f"[FAIL] {name} -> Connection Error: {exc}")
            failed = True

    if failed:
        print("\nValidation Result: FAILED ❌")
        sys.exit(1)
    else:
        print("\nValidation Result: PASSED ✅")
        sys.exit(0)

if __name__ == "__main__":
    run_checks()
