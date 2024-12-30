import readline
import glob
import os
import json
import re

import tables
import methods 

"""
had the wrong idea about the alpha values for rgba
instead, find the closest rgb. then add the opacity value on to it
"""


DEFINED_FILE = "../../.config/gtk-3.0/gtk.css"

def parseColorsFromPath(path) -> dict:
    colors = dict()


    # fix the regex issues
    HEXREGEX = r"#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})(?=[\s;,)\]]|$)"
    RGBREGEX = r"rgb\(\s*(?P<red>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*(,|\s)\s*(?P<green>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*(,|\s)\s*(?P<blue>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*\)"
    RGBAREGEX = r"rgba\(\s*(?P<red>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*(,|\s)\s*(?P<green>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*(,|\s)\s*(?P<blue>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*(,|\s)\s*(?P<alpha>(1|0(?:\.\d+)))\s*\)"
    # HSLREGEX = r"" (too lazy, and not neede for my purposes at this moment)
    # HSLAREGEX = r""
    COLORREGEX = r"(?i)\b[a-zA-Z\-]+:\s*(aliceblue|antiquewhite|aqua|aquamarine|azure|beige|bisque|black|blanchedalmond|blue|blueviolet|brown|burlywood|cadetblue|chartreuse|chocolate|coral|cornflowerblue|cornsilk|crimson|cyan|darkblue|darkcyan|darkgoldenrod|darkgray|darkgreen|darkgrey|darkkhaki|darkmagenta|darkolivegreen|darkorange|darkorchid|darkred|darksalmon|darkseagreen|darkslateblue|darkslategray|darkslategrey|darkturquoise|darkviolet|deeppink|deepskyblue|dimgray|dimgrey|dodgerblue|firebrick|floralwhite|forestgreen|fuchsia|gainsboro|ghostwhite|gold|goldenrod|gray|green|greenyellow|grey|honeydew|hotpink|indianred|indigo|ivory|khaki|lavender|lavenderblush|lawngreen|lemonchiffon|lightblue|lightcoral|lightcyan|lightgoldenrodyellow|lightgray|lightgreen|lightgrey|lightpink|lightsalmon|lightseagreen|lightskyblue|lightslategray|lightslategrey|lightsteelblue|lightyellow|lime|limegreen|linen|magenta|maroon|mediumaquamarine|mediumblue|mediumorchid|mediumpurple|mediumseagreen|mediumslateblue|mediumspringgreen|mediumturquoise|mediumvioletred|midnightblue|mintcream|mistyrose|moccasin|navajowhite|navy|oldlace|olive|olivedrab|orange|orangered|orchid|palegoldenrod|palegreen|paleturquoise|palevioletred|papayawhip|peachpuff|peru|pink|plum|powderblue|purple|red|rosybrown|royalblue|saddlebrown|salmon|sandybrown|seagreen|seashell|sienna|silver|skyblue|slateblue|slategray|slategrey|snow|springgreen|steelblue|tan|teal|thistle|tomato|turquoise|violet|wheat|white|whitesmoke|yellow|yellowgreen)\s*;?"

    with open(path, "r") as file:
        for line in file:
            hexmatch = re.finditer(HEXREGEX, line)
            if hexmatch:
                for match in hexmatch:
                    hex_code = match.group(1)
                    colors[f"#{hex_code}"] = methods.hex_to_rgb(hex_code)
            rgbmatch = re.finditer(RGBREGEX, line)
            if rgbmatch:
                for match in rgbmatch:
                    red = match.group("red")
                    green = match.group("green")
                    blue = match.group("blue")
                    colors[f"rgb({red}, {green}, {blue})"] = (red, green, blue)
            rgbamatch = re.finditer(RGBAREGEX, line)
            if rgbamatch:
                for match in rgbamatch:
                    red = match.group("red")
                    green = match.group("green")
                    blue = match.group("blue")
                    alpha = match.group("alpha")
                    print(alpha)
                    colors[f"rgba({red}, {green}, {blue}, {alpha})"] = methods.rgba_to_rgb((int(red), int(green), int(blue), float(alpha)))
            colormatch = re.finditer(COLORREGEX, line)
            if colormatch:
                for match in colormatch:
                    color_name = match.group(1)
                    colors[color_name] = tables.NAME_RGB_EQUIVALENT.get(color_name.lower())
    return colors

def createNewReplacementFile(replaceDict):
    with open(DEFINED_FILE, 'r') as file:
        content = file.read()
    for old_color, new_color in replaceDict.items():
        content = content.replace(old_color, new_color)
    with open("replaced-file.txt", 'w') as file:
        file.write(content)

def getPathToFile() -> str:

    if DEFINED_FILE and os.path.isfile(DEFINED_FILE):
        return DEFINED_FILE
    else:
        if DEFINED_FILE:
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
    print("Tracked all existing colors")

    replaceDict = methods.find_closest_colors(colorsDict)

    # createNewReplacementFile(replaceDict)


if __name__ == "__main__":
    main()
