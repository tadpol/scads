echo(version=version());

// Values are in millimeters

$fa=1;
$fs=1;

//////////////////
wallThickness=5;

coilDiameter = 39;
coilInnerDiameter = 29.5; //32.5;
coilThickness = 2;
wirePath = 3;

featherWidth = 23;
featherLength = 51;
featherDepth = 8; // includes components
featherCircuitDepth = 2;

baseSize = featherLength;

////////////////////////////
// Coil Mount
translate([0, 0, 0])
difference() {
	cube(size=[baseSize,baseSize,wallThickness]);

	// Cut out a place for the coil
	translate([baseSize/2,baseSize/2,wallThickness-1.5])
		difference() {
			cylinder(h=coilThickness, d=coilDiameter);
			translate([0,0,-1])
				cylinder(h=coilThickness+2, d=coilInnerDiameter);
		}

	// Cutout place for wires to wrap around back
	translate([baseSize/2 - wirePath/2, -1, wallThickness-1.5])
		cube(size=[wirePath, baseSize/2 - coilDiameter/2 + 2, coilThickness]);
	translate([baseSize/2 - wirePath/2, -1, -1])
		cube(size=[wirePath, coilThickness, baseSize/2 - coilDiameter/2 + 2]);

}



//	vim: set ai sw=2 ts=2 :
