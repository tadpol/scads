/*
 * @param gap How much tolerence around to provide
 * @param plugin Point where the center of the microb jack in plugged in.
 */
module usbMicroBPlug(case=[10.2,29.1,7.85], plugin=[0,0,0], gap=0, plugcutout=false) {
	plug = [7,6.3,2];
	plug_depth = 4.3; // How far in the plug goes.
	wgap = [(case[0]+gap*2)/case[0], (case[1]+gap*2)/case[1], (case[2]+gap*2)/case[2]];

	translate([plugin[0]-case[0]/2,plugin[1]-case[1]-(plug[1]-plug_depth),plugin[2]-case[2]/2]) {
		scale(wgap) {
			cube(case);
			if (plugcutout) {
				translate([0,case[1]-0.1,0])
					cube([case[0],plug[1],case[2]]);
			} else {
				translate([case[0]/2-plug[0]/2,case[1]-0.1,case[2]/2-plug[2]/2])
					cube(plug);
			}
		}
	}
}

//usbMicroBPlug(plugcutout=true);

// vim: set ai sw=2 ts=2 :
