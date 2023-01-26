echo(version=version());

// Values are in millimeters

$fa=1;
$fs=1;
////////////////////////////
// Adjust these for cup
cupDiameter = 80;
wallThickness=5;

mountingNutWidth = 4.5;
mountingNutLength = mountingNutWidth;
mountingNutDepth = 3;

// Big zip-tie that goes around the cup and holds all of this on.
zipTieWidth = 5;
zipTieThick = 1;

coilDiameter = 38.5;
coilInnerDiameter = 32.5;
coilThickness = 2;

coilCircutWidth = 10;
coilCircutLength = 25;
coilCircutDepth = 2;

battMountThick = 2;
battMountLength = 20;

lipoWidth = 21;
lipoLength = 29;
lipoDepth = 4;

featherWidth = 23;
featherLength = 51;
featherDepth = 8; // includes components
featherCircuitDepth = 2;

wireD = 2;
// http://www.csgnetwork.com/screwsochdcaptable.html
mountingScrewD = 3; // Good fit screw is M2.5
mountingScrewLength = wallThickness*3 + featherDepth;

// Want to try replacing the mountingScrew with small zip-ties.
sztWidth = 3; // X
sztThick = 1.5; // Y
sztXinset = 2;
sztYinset = 1;
sztSlotOffset = 1.5;

baseSize = featherLength;

//////////////////////////////////////////////////////////////////////////////
module zip_tie_cutout(depth = featherDepth) {
	for(ox=[sztXinset,baseSize-sztThick-sztXinset]) {
		for(oy=[sztYinset,baseSize-sztWidth-sztYinset]) {
			translate([ox,oy,0]) {
				translate([0,0,-1])
					cube(size=[sztThick,sztWidth,depth+2]);
				//children();
			}
		}
	}
}
module zip_tie_extra_cutout(depth = featherDepth) {
	for(ox=[-sztXinset,baseSize-sztThick-sztXinset]) {
		for(oy=[sztYinset,baseSize-sztWidth-sztYinset]) {
			translate([ox,oy,depth]) {
				children();
			}
		}
	}
}

module screw_cutout() {
	for(ox=[mountingScrewD/2+1,baseSize-(mountingScrewD/2)-1]) {
		for(oy=[mountingScrewD/2+1,baseSize-(mountingScrewD/2)-1]) {
			translate([ox,oy,-1])
				cylinder(h=featherDepth+2, d=mountingScrewD);
		}
	}
}
////////////////////////////
// Lower part
rotate([0,0,0])
difference() {
	cube(size=[baseSize,baseSize,15]);

	// cutout center to thin this down. (don't need it solid)
	translate([wallThickness,wallThickness,-1])
		cube(size=[baseSize-(wallThickness*2),baseSize-(wallThickness*2),10]);

	// Cutout the curve of the mug
	translate([baseSize/2, -2.5, (cupDiameter/2)+2])
		rotate([-90,0,0])
			cylinder(h=baseSize+5, d=cupDiameter);

	// Cutout path for zip-tie.
	// FIXME: requires magic number to get placed correctly; don't do that.
	rotate([90,0,0])
	translate([baseSize/2,baseSize - 12,-baseSize/2 - 5])
		difference() {
			cylinder(h=zipTieWidth, d=cupDiameter+(zipTieThick*2));
			translate([0,0,-1])
			cylinder(h=zipTieWidth+2, d=cupDiameter);
		}

	// cutout for mounting zip-ties
	zip_tie_cutout(depth=wallThickness+0.5);
	// side-extention cutouts
	zip_tie_extra_cutout(depth=wallThickness) {
		cube(size=[5,sztWidth,sztThick]);
	}

	// cutout for probe holder
	*translate([baseSize/2, 2.5, (cupDiameter/2)+2])
	rotate([0,-25,0])
		translate([0,0,-(cupDiameter/2)-2.4])
			cube(size=[5.1,10,5.1], center=true);
}

////////////////////////////
// Coil Mount / Top piece

translate([baseSize+5, 0, 0])
difference() {
	cube(size=[baseSize,baseSize,wallThickness]);

	// cutout for mounting zip-ties
	zip_tie_cutout();
	// side-extention cutouts
	zip_tie_extra_cutout(depth=wallThickness-sztSlotOffset) {
		cube(size=[5,sztWidth,sztSlotOffset+1]);
	}

	// Cut out a place for the coil
	translate([baseSize/2,baseSize/2,wallThickness-0.5])
		difference() {
			cylinder(h=coilThickness, d=coilDiameter);
			translate([0,0,-1])
				cylinder(h=coilThickness+2, d=coilInnerDiameter);
		}

	// Cutout place for the coil circut
	translate([baseSize/2-coilCircutWidth/2,baseSize/2-coilCircutLength/2,wallThickness-0.5])
		cube(size=[coilCircutWidth,coilCircutLength,coilCircutDepth]);

	// cutout for wires.
	translate([baseSize/2-wireD, coilCircutLength/2-wireD/2,-1])
		cube(size=[wireD*2,wireD,wallThickness+2]);
}

////////////////////////////
// Middle bit / battery holder and circuit
translate([0,baseSize+5,0])
union() {
	// Rail to mounting screws.
	difference() {
		union() {
			cube(size=[mountingScrewD+2, baseSize, battMountThick]);

			// Standoffs for the screws
			for(ox=[0,baseSize-(mountingScrewD+2)]) {
				for(oy=[0,baseSize-(mountingScrewD+2)]) {
					translate([ox,oy,0])
						cube(size=[mountingScrewD+2, mountingScrewD+2, featherDepth]);
				}
			}
		}
		// cutout for mounting zip-ties
		zip_tie_cutout();

		// cut off tops for holding the circuit board
		translate([baseSize-(mountingScrewD+2)-0.5, -0.5, featherDepth-featherCircuitDepth])
			cube(size=[mountingScrewD+3, baseSize+1, featherCircuitDepth+1]);
	}

	// Show the battery for sighting
	%translate([battMountThick, baseSize/4, featherDepth-lipoDepth])
		cube(size=[lipoWidth,lipoLength,lipoDepth]);

	// Show the feather circuit board for sighting
	%translate([baseSize-featherWidth,0,0])
		cube(size=[featherWidth,featherLength,featherDepth]);

	// Battery clip
	translate([0,baseSize/4,0])
	union() {
		translate([0,lipoLength/2-(battMountLength/2),0])
			cube(size=[lipoWidth+(battMountThick*2), battMountLength, featherDepth-lipoDepth]);
		translate([0,lipoLength/2-(battMountLength/2), 0])
			cube(size=[2, battMountLength, featherDepth]);
		translate([lipoWidth+battMountThick,lipoLength/2-(battMountLength/2), 0])
			cube(size=[2, battMountLength, featherDepth]);
	}
}

////////////////////////////
// Holder for temperature sensors
*translate([baseSize+5,baseSize+5,0])
difference(){
	union() {
		cube(size=[5,40,5]);
		translate([0,40,0])
			cube(size=[15,5,5]);
	}

	translate([10,40,0])
		zip_tie_cutout();
}
//	vim: set ai sw=2 ts=2 :
