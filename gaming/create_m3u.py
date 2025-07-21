#!/usr/bin/env python3

"""
Generate M3U playlist files from disc game files.

Scans the current directory for files named like "Game Name (Disc <number>).<extension>",
groups them by game, sorts by disc number, and writes each list to a .m3u file.
Defaults to processing ".cue" files; a different extension (e.g. "chd") can be supplied via
a command-line argument.

Usage:
    $ python script.py        # Processes cue files by default
    $ python script.py chd    # Processes chd files
"""


#!/usr/bin/env python3
import os
import re
import argparse
from collections import defaultdict

def create_playlist_files(extension):
    # Remove leading dot if provided
    if extension.startswith('.'):
        extension = extension[1:]
    
    # List all files in the current directory
    files = os.listdir('.')

    # Create a regex pattern using the provided file extension
    pattern = re.compile(r"^(.*) \(Disc (\d+)\)\." + re.escape(extension) + r"$", re.IGNORECASE)

    # Dictionary to store games and their matching files
    games = defaultdict(list)

    # Iterate over files and match against the extension-specific pattern
    for file in files:
        match = pattern.match(file)
        if match:
            game_name = match.group(1)         # Extract game name
            disc_number = int(match.group(2))    # Extract disc number
            games[game_name].append((disc_number, file))

    # Create an .m3u file for each game
    for game_name, entries in games.items():
        # Sort the files by disc number
        entries.sort(key=lambda x: x[0])
        sorted_files = [entry[1] for entry in entries]
        m3u_filename = f"{game_name}.m3u"
        with open(m3u_filename, 'w') as m3u_file:
            m3u_file.write('\n'.join(sorted_files))
        print(f"Created playlist: {m3u_filename}")

if __name__ == "__main__":
    # Set up argument parsing to allow a file extension argument
    parser = argparse.ArgumentParser(description="Generate playlist .m3u files from disc files with a given extension")
    parser.add_argument(
        "extension",
        nargs="?",
        default="cue",
        help="File extension to search for (without the leading dot). E.g., cue or chd"
    )
    args = parser.parse_args()

    create_playlist_files(args.extension)