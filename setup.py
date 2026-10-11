import os
import urllib.request
import yaml
from pathlib import Path

# Setup directories
dirs = [
    'assets/images',
    'assets/fonts',
    'lib/app',
    'lib/models',
    'lib/data',
    'lib/controllers',
    'lib/services',
    'lib/screens',
    'lib/widgets',
    'lib/utils',
    'lib/theme'
]

for d in dirs:
    os.makedirs(d, exist_ok=True)

# Download font
font_url = 'https://github.com/googlefonts/spacegrotesk/raw/main/fonts/ttf/SpaceGrotesk-Regular.ttf'
font_path = 'assets/fonts/SpaceGrotesk-Regular.ttf'
if not os.path.exists(font_path):
    print("Downloading Space Grotesk font...")
    urllib.request.urlretrieve(font_url, font_path)

font_bold_url = 'https://github.com/googlefonts/spacegrotesk/raw/main/fonts/ttf/SpaceGrotesk-Bold.ttf'
font_bold_path = 'assets/fonts/SpaceGrotesk-Bold.ttf'
if not os.path.exists(font_bold_path):
    print("Downloading Space Grotesk Bold font...")
    urllib.request.urlretrieve(font_bold_url, font_bold_path)

# Update pubspec.yaml
pubspec_path = 'pubspec.yaml'
with open(pubspec_path, 'r') as f:
    pubspec = yaml.safe_load(f)

if 'dependencies' not in pubspec:
    pubspec['dependencies'] = {}

pubspec['dependencies']['provider'] = '^6.1.1'
pubspec['dependencies']['url_launcher'] = '^6.2.1'

if 'flutter' not in pubspec:
    pubspec['flutter'] = {}

pubspec['flutter']['uses-material-design'] = True
pubspec['flutter']['assets'] = ['assets/images/']
pubspec['flutter']['fonts'] = [
    {
        'family': 'SpaceGrotesk',
        'fonts': [
            {'asset': 'assets/fonts/SpaceGrotesk-Regular.ttf'},
            {'asset': 'assets/fonts/SpaceGrotesk-Bold.ttf', 'weight': 700},
        ]
    }
]

with open(pubspec_path, 'w') as f:
    yaml.dump(pubspec, f, sort_keys=False)

print("Setup completed successfully.")
