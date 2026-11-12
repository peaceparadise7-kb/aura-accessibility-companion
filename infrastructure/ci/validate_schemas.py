#!/usr/bin/env python3
"""
Validates shared JSON schemas, contracts, and bundled asset profiles.
"""
import json
import sys
from pathlib import Path


def validate_json_file(file_path: Path) -> bool:
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            json.load(f)
        print(f"[OK] Valid JSON: {file_path}")
        return True
    except Exception as e:
        print(f"[ERROR] Invalid JSON {file_path}: {e}", file=sys.stderr)
        return False


def main():
    root = Path(__file__).resolve().parent.parent.parent
    files_to_check = [
        root / "shared" / "schemas" / "appliance_profile.schema.json",
        root / "shared" / "schemas" / "ar_event.schema.json",
        root / "shared" / "contracts" / "ar_event_contract.json",
        root / "shared" / "contracts" / "api_v1_openapi.json",
        root / "apps" / "mobile" / "assets" / "profiles" / "microwave_sample.json",
    ]

    all_passed = True
    for f in files_to_check:
        if not f.exists():
            print(f"[MISSING] Required file missing: {f}", file=sys.stderr)
            all_passed = False
            continue
        if not validate_json_file(f):
            all_passed = False

    if not all_passed:
        sys.exit(1)
    print("All shared schemas and contracts passed JSON syntax validation.")


if __name__ == "__main__":
    main()
