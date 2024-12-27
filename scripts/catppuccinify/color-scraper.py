import readline
import glob
import os
import json
import re
from collections import Counter

"""
https://regex101.com/

use this
"""

# DEFINED_PATH = "../../.config/gtk-3.0/gtk.css.bak"
DEFINED_PATH = "cases/testcase.css"

def parseColorsFromPath(path) -> Counter:
    colors = Counter()
    rgbVersion = dict()

    # fix the regex issues
    HEXREGEX = r"#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})(?=[\s;,)\]]|$)"
    RGBREGEX = r"rgb\(\s*(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*,\s*(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*,\s*(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*\)"
    RGBAREGEX = r"rgba\(\s*(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*,\s*(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*,\s*(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*,\s*([0-1]\.[0-9]{2})\s*\)"
    HSLREGEX = r"hsl\(\s*(\d{1,3}deg),\s*(\d{1,3}%),\s*(\d{1,3}%)\s*\)"
    COLORREGEX = r"(?i)\b[a-zA-Z\-]+:\s*(aliceblue|antiquewhite|aqua|aquamarine|azure|beige|bisque|black|blanchedalmond|blue|blueviolet|brown|burlywood|cadetblue|chartreuse|chocolate|coral|cornflowerblue|cornsilk|crimson|cyan|darkblue|darkcyan|darkgoldenrod|darkgray|darkgreen|darkgrey|darkkhaki|darkmagenta|darkolivegreen|darkorange|darkorchid|darkred|darksalmon|darkseagreen|darkslateblue|darkslategray|darkslategrey|darkturquoise|darkviolet|deeppink|deepskyblue|dimgray|dimgrey|dodgerblue|firebrick|floralwhite|forestgreen|fuchsia|gainsboro|ghostwhite|gold|goldenrod|gray|green|greenyellow|grey|honeydew|hotpink|indianred|indigo|ivory|khaki|lavender|lavenderblush|lawngreen|lemonchiffon|lightblue|lightcoral|lightcyan|lightgoldenrodyellow|lightgray|lightgreen|lightgrey|lightpink|lightsalmon|lightseagreen|lightskyblue|lightslategray|lightslategrey|lightsteelblue|lightyellow|lime|limegreen|linen|magenta|maroon|mediumaquamarine|mediumblue|mediumorchid|mediumpurple|mediumseagreen|mediumslateblue|mediumspringgreen|mediumturquoise|mediumvioletred|midnightblue|mintcream|mistyrose|moccasin|navajowhite|navy|oldlace|olive|olivedrab|orange|orangered|orchid|palegoldenrod|palegreen|paleturquoise|palevioletred|papayawhip|peachpuff|peru|pink|plum|powderblue|purple|red|rosybrown|royalblue|saddlebrown|salmon|sandybrown|seagreen|seashell|sienna|silver|skyblue|slateblue|slategray|slategrey|snow|springgreen|steelblue|tan|teal|thistle|tomato|turquoise|violet|wheat|white|whitesmoke|yellow|yellowgreen)\s*;?"

    with open(path, "r") as file:
        for line in file:
            hexmatch = re.findall(HEXREGEX, line)
            if hexmatch:
                for match in hexmatch:
                    print(match)
                    print(f"Found hex value: #{match}")
                    colors[f"#{match}"] += 1
            rgbmatch = re.findall(RGBREGEX, line)
            if rgbmatch:
                for match in rgbmatch:
                    print(match)
                    joined_output = f"rgb({', '.join(tuple(match))})"
                    print(f"Found rgb value: {joined_output}")
                    colors[f"{joined_output}"] += 1
            rgbamatch = re.findall(RGBAREGEX, line)
            if rgbamatch:
                for match in rgbamatch:
                    print(match)
                    joined_output = f"rgba({', '.join(tuple(match))})"
                    print(f"Found rgba value: {joined_output}")
                    colors[f"{joined_output}"] += 1
            hslmatch = re.findall(HSLREGEX, line)
            if hslmatch:
                for match in hslmatch:
                    print(match)
                    joined_output = f"hsl({', '.join(tuple(match))})"
                    print(f"Found hsl value: {joined_output}")
                    colors[f"{joined_output}"] += 1
            colormatch = re.findall(COLORREGEX, line)
            if colormatch:
                for match in colormatch:
                    print(match)
                    print(f"Found color value: {match}")
                    colors[f"{match}"] += 1
    return colors

def getPathToFile() -> str:

    if DEFINED_PATH and os.path.isfile(DEFINED_PATH):
        return DEFINED_PATH
    else:
        if DEFINED_PATH:
            print("Pre-defined path did not resolve to a valid file.\n")

        def complete(text, state):
            return (glob.glob(text+'*')+[None])[state]

        while True:
            readline.set_completer_delims(' \t\n;')
            readline.parse_and_bind("tab: complete")
            readline.set_completer(complete)
            raw_input = (input('file? '))

            if os.path.isfile(raw_input):
                break
            else:
                print("\nNot a file\n")
        return raw_input

def main():
    colorsDict = parseColorsFromPath(getPathToFile())
    with open("output.txt", "w") as output:
        output.write(json.dumps(colorsDict, indent=2))
    print("Outputted to output.txt!")

if __name__ == "__main__":
    main()
