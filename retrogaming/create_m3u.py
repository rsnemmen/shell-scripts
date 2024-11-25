#!/usr/bin/env python3
import os
import re
from collections import defaultdict

def create_m3u_files():
    # Get a list of all files in the current directory
    files = os.listdir('.')

    # Regular expression to match files in the format "<game name> (Disc <number>).cue"
    pattern = re.compile(r"^(.*) \(Disc (\d+)\)\.cue$", re.IGNORECASE)

    # Dictionary to store games and their cue files
    games = defaultdict(list)

    # Iterate through the files and match them against the pattern
    for file in files:
        match = pattern.match(file)
        if match:
            game_name = match.group(1)  # Extract the game name
            disc_number = int(match.group(2))  # Extract the disc number
            games[game_name].append((disc_number, file))  # Store the disc number and file

    # Create an .m3u file for each game
    for game_name, cues in games.items():
        # Sort the cue files by disc number
        cues.sort(key=lambda x: x[0])
        # Extract the sorted cue filenames
        sorted_cue_files = [cue[1] for cue in cues]
        # Create the .m3u filename
        m3u_filename = f"{game_name}.m3u"
        # Write the sorted cue filenames to the .m3u file
        with open(m3u_filename, 'w') as m3u_file:
            m3u_file.write('\n'.join(sorted_cue_files))
        print(f"Created playlist: {m3u_filename}")

if __name__ == "__main__":
    create_m3u_files()