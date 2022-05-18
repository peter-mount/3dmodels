use <cartridge.scad>;


BBCCartridge(component = 0);
translate([100, 0, 0]) BBCCartridge(component = 1, pcbBump = 0);

