echo(version=version());

// Values are in millimeters

////////////////////////////
// Adjust these for cup and coil
cupDiameter = 60;
coilDiameter = 30;
coilInnerDiameter = 25;
coilThickness = 2;

wallThickness = 2;
baseThickness = 4;

circuitDepth = 20; // how much space for the circuits
cupDepth = 10; // How much space to grab the cup
chargeDepth = 5; // How much space for the charging circuits

nubWidth = 5;
nubHeight = 3;

////////////////////////////
//
caseDiameter = cupDiameter + (wallThickness * 2); 
circuitDiameter = cupDiameter - (wallThickness *2);
innerWall = caseDiameter - cupDiameter;


// Bottom Cup piece.  Where the circuits live.
translate([0,0,0]) {
    difference() {
        cylinder(h=circuitDepth+cupDepth+baseThickness, d=caseDiameter);

        // Cut out a place for the circuits
        translate([0,0,baseThickness]) cylinder(h=circuitDepth+3, d=circuitDiameter);
        
        // Cut out a place for the cup
        translate([0,0,baseThickness+circuitDepth]) cylinder(h=cupDepth+3, d=cupDiameter);

        // Cut out a place for the coil
        translate([0,0,1+baseThickness-coilThickness])
            difference() {
                cylinder(h=coilThickness, d=coilDiameter);
                cylinder(h=coilThickness, d=coilInnerDiameter);
            }
        // Cut out a hole for the alignment nub.
        translate([0,0,-0.5])
            cylinder(h=nubHeight, d=nubWidth);

        // Cut out a hole to let wires through
        rotate([90,0,0])
            translate([0, circuitDepth, ((caseDiameter/2) - 5)])
                #cylinder(h=innerWall+2, r=2);

        // Cut a place for an O-ring to better grip the cup.
        //translate([0,0,circuitDepth+cupDepth-1]) cylinder(h=baseThickness, d=cupDiameter+wallThickness);
        // Not sure about this.
    }
}

// Base plate that goes above circuits and below cup.
translate([0,cupDiameter+5,0]) {
    cylinder(h=baseThickness, d=cupDiameter);
}

// Charging Base curcuit holder
translate([-(cupDiameter+5),0,0]) {
    difference() {
        cylinder(h=baseThickness+baseThickness+chargeDepth, d=caseDiameter);

        // Cut out a spot for the circuits
        translate([0,0,baseThickness]) cylinder(h=baseThickness+baseThickness+chargeDepth, d=circuitDiameter);

        // Cut out a lip to hold lid
        translate([0,0,baseThickness+chargeDepth]) cylinder(h=baseThickness*2, d=cupDiameter);

        // Cut out spot for power connector (USB?)
        translate([0, -((caseDiameter/2)+(innerWall/2)), baseThickness])
            #cube(size=[5,innerWall*2,3]);
    }
}

// Charging Base top plate.
translate([-(cupDiameter+5),cupDiameter+5,0]) {
    difference() {
        union() {
            cylinder(h=baseThickness, d=cupDiameter);
            // Add alignment nub
            translate([0,0,baseThickness]) cylinder(h=nubHeight, d1=nubWidth, d2=nubWidth-1);
        }

        // Cut out spot for coil
        translate([0,0,1+baseThickness-coilThickness])
            difference() {
                cylinder(h=2, d=coilDiameter);
                cylinder(h=2, d=coilInnerDiameter);
            }
    }
}
//  vim: set et ai sw=4 ts=4 :
