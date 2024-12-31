import os
import readline
import glob
import re

from methods import methods
from palette.catppuccin_mocha import PALETTE

"""
    Color Converter

    convert a file's color palette to whatever color palette you want

    for new color palettes, reference palettes/catppuccin folder

    (so far everything is just converted to rgb/rgba :p)
"""

# NOT OPTIONAL, select python palette to import/create your own
# from palette import (palette name) as palette

# optional, remove if you intend on manually finding file path
DEFINED_FILE = "../../.config/gtk-3.0/gtk.css"

def findAllColorsFromFile(file) -> None:
    """
        return a dictionary of key value colors
        key: the original color in its original form
        value: the closest paletted color
    """

    HEXREGEX = r"#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})(?=[\s;,)\]]|$)"
    RGBREGEX = r"rgb\(\s*(?P<red>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*(,|\s)\s*(?P<green>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*(,|\s)\s*(?P<blue>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*\)"
    RGBAREGEX = r"rgba\(\s*(?P<red>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*(,|\s)\s*(?P<green>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*(,|\s)\s*(?P<blue>25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\s*(,|\s)\s*(?P<alpha>(1|0(?:\.\d+)))\s*\)"
    # HSLREGEX = r"" (too lazy, and not neede for my purposes at this moment)
    # HSLAREGEX = r""
    COLORREGEX = r"(?i)\b[a-zA-Z\-]+:\s*(aliceblue|antiquewhite|aqua|aquamarine|azure|beige|bisque|black|blanchedalmond|blue|blueviolet|brown|burlywood|cadetblue|chartreuse|chocolate|coral|cornflowerblue|cornsilk|crimson|cyan|darkblue|darkcyan|darkgoldenrod|darkgray|darkgreen|darkgrey|darkkhaki|darkmagenta|darkolivegreen|darkorange|darkorchid|darkred|darksalmon|darkseagreen|darkslateblue|darkslategray|darkslategrey|darkturquoise|darkviolet|deeppink|deepskyblue|dimgray|dimgrey|dodgerblue|firebrick|floralwhite|forestgreen|fuchsia|gainsboro|ghostwhite|gold|goldenrod|gray|green|greenyellow|grey|honeydew|hotpink|indianred|indigo|ivory|khaki|lavender|lavenderblush|lawngreen|lemonchiffon|lightblue|lightcoral|lightcyan|lightgoldenrodyellow|lightgray|lightgreen|lightgrey|lightpink|lightsalmon|lightseagreen|lightskyblue|lightslategray|lightslategrey|lightsteelblue|lightyellow|lime|limegreen|linen|magenta|maroon|mediumaquamarine|mediumblue|mediumorchid|mediumpurple|mediumseagreen|mediumslateblue|mediumspringgreen|mediumturquoise|mediumvioletred|midnightblue|mintcream|mistyrose|moccasin|navajowhite|navy|oldlace|olive|olivedrab|orange|orangered|orchid|palegoldenrod|palegreen|paleturquoise|palevioletred|papayawhip|peachpuff|peru|pink|plum|powderblue|purple|red|rosybrown|royalblue|saddlebrown|salmon|sandybrown|seagreen|seashell|sienna|silver|skyblue|slateblue|slategray|slategrey|snow|springgreen|steelblue|tan|teal|thistle|tomato|turquoise|violet|wheat|white|whitesmoke|yellow|yellowgreen)\s*;?"

    method = methods(PALETTE)

    with open(file, "r") as file:
        info_path = "output-files/information.txt"
        # os.makedirs(os.path.dirname(info_path), exist_ok=True)
        with open(info_path, "w") as info:
            convert_file_path = "output-files/converted-file.txt"
            # os.makedirs(os.path.dirname(convert_file_path), exist_ok=True)
            with open (convert_file_path, "w") as convert_file:
                for line in file:
                    converted_line = line

                    hexmatch = re.finditer(HEXREGEX, converted_line)
                    if hexmatch:
                        for match in hexmatch:
                            hex_code = match.group(1)
                            rgb_hex = method.hex_to_rgb(hex_code)
                            closest_color = method.find_closest_colors(rgb_hex)
                            info.write(f"HEX: #{hex_code} --> converted to RGB: rgb{rgb_hex} --> closest color: rgb{closest_color}\n")
                            converted_line = re.sub(HEXREGEX, f"rgb{closest_color}", converted_line)
                    rgbmatch = re.finditer(RGBREGEX, converted_line)
                    if rgbmatch:
                        for match in rgbmatch:
                            red = int(match.group("red"))
                            green = int(match.group("green"))
                            blue = int(match.group("blue"))
                            rgb_tuple = (red, green, blue)
                            closest_color = method.find_closest_colors(rgb_tuple)
                            info.write(f"RGB: rgb{rgb_tuple} not converted as it is already RGB. --> closest color: rgb{closest_color}\n")
                            re.sub(RGBREGEX, f"rgb{closest_color}", converted_line)
                    rgbamatch = re.finditer(RGBAREGEX, converted_line)
                    if rgbamatch:
                        for match in rgbamatch:
                            red = int(match.group("red"))
                            green = int(match.group("green"))
                            blue = int(match.group("blue"))
                            alpha = float(match.group("alpha"))
                            rgb_tuple = (red, green, blue)
                            rgba_tuple = (red, green, blue, alpha)
                            closest_color = method.find_closest_colors(rgb_tuple)
                            closest_color_with_alpha = (closest_color[0], closest_color[1], closest_color[2], alpha)
                            info.write(f"RGBA: rgba{rgba_tuple} --> without alpha: rgb{rgb_tuple}. --> closest color: rgb{closest_color}, --> w/ alpha: rgba{closest_color_with_alpha}\n")
                            re.sub(RGBAREGEX, f"rgba{closest_color_with_alpha}", converted_line)
                    colormatch = re.finditer(COLORREGEX, line)
                    if colormatch:
                        for match in colormatch:
                            color_name = match.group(1)
                            rgb_tuple = method.name_rgb_equivalent(color_name)
                            closest_color = method.find_closest_colors(rgb_tuple)
                            info.write(f"named color: {color_name} --> converted to RGB: rgb{rgb_tuple} --> closest color: rgb{closest_color}\n")
                            re.sub(COLORREGEX, f"rgb{rgb_tuple}", converted_line)
                    convert_file.write(converted_line)

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
    findAllColorsFromFile(getPathToFile())


if __name__ == "__main__":
    main()
