from scipy.spatial import KDTree
import tables

"""
    convert hex to a tuple containing (red, green, blue)
"""

class methods:
    def __init__(self, palette: dict):
        self.preset_colors = list(palette.values())
        self.tree = KDTree(list(self.preset_colors))

    def hex_to_rgb(self, hex: str) -> tuple:
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

    def find_closest_colors(self, color_code: tuple) -> tuple:
        _, index = self.tree.query(color_code)
        closest_pair = (self.preset_colors[index])
        return closest_pair

    def name_rgb_equivalent(self, name: str) -> tuple:
        return tables.NAME_RGB_EQUIVALENT.get(name)
