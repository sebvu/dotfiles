# methods to convert to rgb
from scipy.spatial import KDTree
import json

import tables

def rgba_to_rgb(rgba: tuple) -> tuple:
    alpha = rgba[3]
    return (rgba[0] * alpha, rgba[1] * alpha, rgba[2] * alpha)

def hex_to_rgb(hex: str) -> tuple:
    hex_array = []
    if len(hex) == 6:
        hex_array.append(hex[:2].upper())
        hex_array.append(hex[2:4].upper())
        hex_array.append(hex[4:6].upper())
    else:
        hex_array.append((hex[0] + hex[0]).upper())
        hex_array.append((hex[1] + hex[1]).upper())
        hex_array.append((hex[2] + hex[2]).upper())

    red = (tables.BASE16[hex_array[0][0]] * (16**1)) + (tables.BASE16[hex_array[0][1]] * (16**0))
    green = (tables.BASE16[hex_array[1][0]] * (16**1)) + (tables.BASE16[hex_array[1][1]] * (16**0))
    blue = (tables.BASE16[hex_array[2][0]] * (16**1)) + (tables.BASE16[hex_array[2][1]] * (16**0))
    return (red, green, blue)

def find_closest_colors(dict_list: dict) -> dict:
    preset_colors = list(tables.CATPPUCCIN_MOCHA.values())
    query_colors = list(dict_list.values())
    keys = list(dict_list.keys())

    tree = KDTree(preset_colors)

    closest_colors = []
    for color in query_colors:
        distance, index = tree.query(color)
        closest_colors.append(preset_colors[index])

    matching_pair = {}

    with open("wow2.txt", "w") as file:
        for i in range(len(closest_colors)):
            matching_pair[keys[i]] = closest_colors[i]
            file.write(f"\nKey Color: {keys[i]}, RGB Version rgb{query_colors[i]} ->> closest color is: rgb{closest_colors[i]} ")

    print(json.dumps(matching_pair, indent=2))

    return matching_pair
