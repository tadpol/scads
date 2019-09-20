echo(version=version());

// Values are in millimeters

$fa=1;
$fs=1;
////////////////////////////
use <parts/moteino.scad>;

tolerance=0.2;
wall_thickness = 1.5;


// Main Box
mote_box=moteino_dims() + [
	wall_thickness*2,
	wall_thickness*2,
	wall_thickness*2
];
mote_cut=moteino_dims() + [
	tolerance,
	tolerance,
	tolerance + wall_thickness,
];
wire_diameter=1.3; // Battery wires

%translate([wall_thickness+tolerance,10+wall_thickness,wall_thickness+tolerance])
	moteino();

!difference() {
	cube(mote_box);
	translate([wall_thickness,wall_thickness,wall_thickness]) cube(mote_cut);
	// Cut slot for battery wires coming in.
	translate([mote_box[0]-0.5 - wall_thickness, 3, mote_box[2]-(wire_diameter+wall_thickness)])
		cube([wall_thickness+1, wire_diameter*2, wire_diameter+wall_thickness+0.1]);
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
union() {
	cube(mote_lid);
	translate([wall_thickness,wall_thickness,-wall_thickness]) cube(mote_lid_lip);
}

