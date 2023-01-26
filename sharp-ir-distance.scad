echo(version=version());

// Values are in millimeters

$fa=1;
$fs=1;
////////////////////////////


module sharp_ir_distance_mount() {
	dia=3.75*2;
	difference() {
		union() {
			cylinder(h=2, d=dia);
			translate([0,-dia/2,0]) cube([dia,dia,2]);
		}
		translate([0,0,-0.5]) cylinder(h=3, d=(3.2));
	}
}
module sharp_ir_distance_connector() {
	cube([10.1, 18.9-13, 1.2]);
}
module sharp_ir_distance(fuzz=0) {
	translate([3.75*2,0,0]) {
		cube([29.5, 13, 13.5 - 6.3]);
		translate([0,(13-8.4)/2,0]) cube([29.5, 8.4, 13.5 - 2]);

		top_len = 7.5+4.15+16.3;
		top_rim = (29.5 - top_len)/2;

		translate([top_rim-fuzz,(13-7.2-fuzz)/2,0]) cube([7.5+(fuzz*2), 7.2+(fuzz*2), 13.5]);
		translate([top_rim+7.5+4.15-fuzz,(13-7.2-fuzz)/2,0]) cube([16.3+(fuzz*2), 7.2+(fuzz*2), 13.5]);

		center_offset_mount = (37 - 29.5)/2;
		translate([-center_offset_mount,(13-7.2),0]) sharp_ir_distance_mount();
		translate([center_offset_mount+29.5,(13-7.2),0]) mirror() sharp_ir_distance_mount();


		translate([14.75-(10.1/2), 13, 3.3]) sharp_ir_distance_connector();
	}
}

//translate([3.75*2,0,0]) sharp_ir_distance();

//	vim: set ai sw=2 ts=2 :
