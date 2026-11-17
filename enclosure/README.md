# Enclosure

The 3D-printed housing for the Raspberry Pi 5, its cooler and the Waveshare 7-inch DSI touchscreen, designed by Zidan Zuberi in OpenSCAD.

Version 3 is three parts:

- `armor_face.stl`: the front frame that holds the screen
- `armor_back.stl`: the back pod for the Pi and cooler, with an open top and U-shaped port slots
- `armor_lid.stl`: a separate vented lid that presses into place

`dashboard_armor.scad` is the source. Set `part` at the top of the file to `"face"`, `"back"` or `"lid"` to export each piece, or `"fit"` to see them assembled.

## Printing

- Material: ASA or ABS. PLA softens in a hot car.
- Each part prints without supports: the frame face down, the pod open side up, the lid flat.
- The two halves join with M3 screws into heat-set inserts in the frame.
