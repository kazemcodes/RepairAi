#!/usr/bin/env python3
"""
Scan data directory and generate metadata for index.
"""

import os
import json
import hashlib
from pathlib import Path

def calculate_file_hash(filepath):
    """Calculate SHA256 hash of a file."""
    sha256_hash = hashlib.sha256()
    with open(filepath, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()

def scan_directory(base_path, subdir):
    """Scan a subdirectory and return list of files with metadata."""
    files = []
    full_path = Path(base_path) / subdir
    
    if not full_path.exists():
        return files
    
    for root, dirs, filenames in os.walk(full_path):
        for filename in filenames:
            if filename.startswith('.'):
                continue
                
            filepath = Path(root) / filename
            relative_path = filepath.relative_to(base_path)
            
            files.append({
                'path': str(relative_path),
                'type': subdir.rstrip('s'),  # 'schematics' -> 'schematic'
                'hash': calculate_file_hash(filepath),
            })
    
    return files

def main():
    base_path = Path(__file__).parent.parent.parent
    
    # Scan schematics and solutions directories
    schematics = scan_directory(base_path, 'data/schematics')
    solutions = scan_directory(base_path, 'data/solutions')
    
    # Output for next step
    result = {
        'schematics': schematics,
        'solutions': solutions,
    }
    
    with open('.github/scripts/scan_result.json', 'w') as f:
        json.dump(result, f, indent=2)
    
    print(f"Found {len(schematics)} schematics and {len(solutions)} solutions")

if __name__ == '__main__':
    main()
