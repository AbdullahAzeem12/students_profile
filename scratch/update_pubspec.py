import yaml

pubspec_path = 'pubspec.yaml'
with open(pubspec_path, 'r') as f:
    pubspec = yaml.safe_load(f)

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

print("pubspec updated")
