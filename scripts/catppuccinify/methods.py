# methods to convert to rgb

def rgba_to_rgb(rgba: tuple) -> tuple:
    alpha = rgba[3]
    return (rgba[0] * alpha, rgba[1] * alpha, rgba[2] * alpha)

def hex_to_rgb(hex: string) -> tuple:

