// echo(version=version());
// Values are in millimeters

/* The outer most dimensions of the sensor */
function d2cs_h_dimensions() = [31.6, 33.5, 11.3];

module mount_wing() {
	translate([5.5, -2.45, 0]) {
		cube([19.5, 2.45, 1.5]); // TODO: Round corner a smige.
	}
	// This isn't centered on the wing-bit
	translate([16.2 - 7.8/2, -2.45, 0]) {
		difference() {
			hull() {
				cube([7.8, 0.1, 1.5]);
				translate([7.8/2, -3.15, 0]) cylinder(h=1.5, d=4, $fn=16);
			}
			translate([7.8/2, -3.15, -0.05]) cylinder(h=1.6, d=2.8, $fn=16);
		}
	}
}

/**
 * Capacitive Liquid Level Sensor
 * https://www.eptsensor.com/level-sensor/single-point-level-sensor/d2cs-h-capacitive-level-sensor.html
 */
module d2cs_h() {
	// The main cube (including the circle on the back)
	cube([ 31.6, 19.2, 9.3]);
	translate([16.2, 19.2/2, -2]) {
		difference($fn=35) {
			cylinder(h = 2, d=10.9);
			translate([0,0,-0.05]) cylinder(h = 2.1, d=9);
		}
	}

	// 'Wings' for mounting holes
	mount_wing();
	translate([0, 19.2, 0]) mirror([0,1,0]) mount_wing();
	
	// The rails above the wings
	translate([10, -2, 6]) {
		cube([16, 2, 1]);
	}
	translate([10, 19.2, 6]) {
		cube([16, 2, 1]);
	}
}

d2cs_h();
