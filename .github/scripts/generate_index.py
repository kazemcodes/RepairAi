#!/usr/bin/env python3
"""
Generate index.json from scan results.
"""

import json
from datetime import datetime

def main():
    # Read scan results
    try:
        with open('.github/scripts/scan_result.json', 'r') as f:
            scan_result = json.load(f)
    except FileNotFoundError:
        print("No scan results found, creating empty index")
        scan_result = {'schematics': [], 'solutions': []}
    
    # Generate index.json
    index = {
        'version': '1.0.0',
        'updated_at': datetime.now().isoformat(),
        'schematics': scan_result.get('schematics', []),
        'solutions': scan_result.get('solutions', []),
    }
    
    # Write index.json
    with open('index.json', 'w') as f:
        json.dump(index, f, indent=2)
    
    print(f"Generated index.json with {len(index['schematics'])} schematics and {len(index['solutions'])} solutions")

if __name__ == '__main__':
    main()
