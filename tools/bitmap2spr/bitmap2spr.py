#!/usr/bin/env python
# This is a simple Python hack that converts monochrome images with a
# multiple of 24x21px to an array of sprites. It can save the sprites
# with or without load address. Public Domain.
#
# 1st argument: file to convert
# 2nd argument: target file
# 3rd argument: load address in hex (optional)

import sys, struct
from PIL import Image

img = Image.open(sys.argv[1]).convert("1")

if (img.size[0] % 24) != 0 or (img.size[1] % 21) != 0:
    print("image size of %s isn't a multiple of 24x21!" % (str(img.size)))
    print("exiting!")
    sys.exit(1)

xoff = 0
yoff = 0

if len(sys.argv) > 3:
    print("adding loader address")
    sprbuf = struct.pack("<H", int(sys.argv[3], 16))
else:
    sprbuf = bytes()

while yoff < img.size[1]:
    while xoff < img.size[0]:
        crop = (xoff, yoff, xoff+24, yoff+21)
        print(crop)
        cut = img.crop(crop)
        cut_str = cut.tobytes()
        sprbuf = sprbuf + cut_str + struct.pack("x")
        xoff = xoff + 24
    yoff = yoff + 21
    xoff = 0

open(sys.argv[2], "wb").write(sprbuf)
