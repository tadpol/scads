echo(version=version());
$fn=10;

// Values are in millimeters
thickness = 1.75;
length=20;

union() {
	difference() {
		union() {
			cube([thickness*3,length,thickness*2]);
			translate([thickness*3,length-thickness*3,0])
				cube([thickness,thickness*3,thickness*2]);
		}
		translate([thickness,-thickness,-0.5])
			cube([thickness,length,thickness*2+1]);
		translate([thickness*3-thickness/2,length-thickness*3+thickness/2,-0.5])
			cube([thickness,thickness*2,thickness*4]);
	}
	translate([thickness*3/4,thickness/2,0])
		cylinder(d=thickness,h=thickness*2);
	translate([thickness*2+thickness*1/4,thickness/2,0])
		cylinder(d=thickness,h=thickness*2);
}

translate([10,0,0])
union() {
	cube([thickness,length,thickness*2]);
	translate([thickness*3/4,thickness/2,0])
		cylinder(d=thickness,h=thickness*2);
}
