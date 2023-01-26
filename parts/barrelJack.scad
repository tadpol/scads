// 5V barrel jack
// https://cdn-shop.adafruit.com/datasheets/21mmdcjackDatasheet.pdf
module jack() {
	cube([3.5, 9,11]);
	cube([14.4,9,6.5]);
	translate([0,9/2,6.5])
		rotate([0,90,0])
			cylinder(d=9,h=14.4);
	translate([10.7,-0.5,-3.5])
		cube([1,0.5,3.5]);
	translate([7.7,4,-3.5])
		cube([0.5,1,3.5]);
	translate([13.7,4,-3.5])
		cube([0.5,1,3.5]);
}


// vim: set ai sw=2 ts=2 :
