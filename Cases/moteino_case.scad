echo(version=version());

// Values are in millimeters

$fa=1;
$fs=1;
////////////////////////////

side_wires = false;
ftdi_header = false;
power_ftdi = true;
height = 20; // Extra height for shields.

////////////////////////////
use <parts/moteino.scad>;

tolerance=0.2;
wall_thickness = 0.4 * 3; // 3x extusion width


// Main Box
mote_box=moteino_dims() + [
	wall_thickness*2,
	wall_thickness*2,
	wall_thickness*2 + height
];
mote_cut=moteino_dims() + [
	tolerance,
	tolerance,
	tolerance + wall_thickness + height,
];
wire_diameter=1.3; // Battery wires
ftdi_width=15.5;
power_ftdi_width=ftdi_width/2;

%translate([wall_thickness+tolerance,10+wall_thickness,wall_thickness+tolerance])
	moteino();

difference() {
	cube(mote_box);
	translate([wall_thickness,wall_thickness,wall_thickness]) cube(mote_cut);

	if (side_wires) {
		// Cut slot for battery wires coming in.
		translate([mote_box[0]-0.5 - wall_thickness, 3, mote_box[2]-(wire_diameter+wall_thickness)])
			cube([wall_thickness+1, wire_diameter*2, wire_diameter+wall_thickness+0.1]);
	}
	if (ftdi_header) {
		cr=(mote_box[0]/2) - (ftdi_width/2) - tolerance/2;
		translate([cr,-(tolerance/2),wall_thickness])
			cube([ftdi_width+tolerance, wall_thickness+tolerance, mote_box[2]]);
	}
	if (power_ftdi) {
		cr=(mote_box[0]/2) - tolerance/2;
		translate([cr,-(tolerance/2),wall_thickness])
			cube([power_ftdi_width+tolerance, wall_thickness+tolerance, mote_box[2]-height - 8]);
	}
}

// Lid
mote_lid=[
	mote_box[0],
	mote_box[1],
	wall_thickness
];
mote_lid_lip = [
	mote_box[0] - wall_thickness*2,
	mote_box[1] - wall_thickness*2,
	wall_thickness
];
translate([0,0,mote_box[2] + 20])
!difference() {
	union() {
		cube(mote_lid);
		translate([wall_thickness,wall_thickness,-wall_thickness]) cube(mote_lid_lip);
	}
	translate([10,mote_lid[1]-7,-3]) cylinder(d=5,h=5);
	translate([10,mote_lid[1]-18,-3]) cylinder(d=5,h=5);
}

// vim: set ai sw=2 ts=2 :
