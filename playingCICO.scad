echo(version=version());

cupDiameter = 40;
coilDiameter = 12;
coilInnerDiameter = 9;

// Cup bottom
difference() {
cylinder(h = 10, d=cupDiameter);
translate([0, 0, 7.5]) union() {
    // nub for an O-ring to better hold onto cup
    translate([0, 0, 1]) cylinder(h = 1, d=(cupDiameter-2));
    cylinder(h=6, d=(cupDiameter-4));
}
translate([0, 0, -1])
    cylinder(h=7.5, d=(cupDiameter-4));

rotate([90,0,0])
    translate([0, 5, ((cupDiameter/2) - 2.5)])
        #cylinder(h=3, r=1);
}

// Lid for bottom.
translate([cupDiameter+5,0,0]) {
    difference() {
        union() {
            cylinder(h = 1, d=cupDiameter);
            cylinder(h = 2, d=(cupDiameter-4));
        }
        translate([0,0,0.5])
            difference() {
                cylinder(h=2, d=coilDiameter);
                cylinder(h=2, d=coilInnerDiameter);
            }
        translate([0,0,-0.5])
            cylinder(h=2, d=3);
    }
    
}

// Charging Base
translate([-(cupDiameter+5),0,0]) {
    difference() {
        union() {
            cylinder(h=4, d=cupDiameter);
            translate([0,0,4]) cylinder(h=1, d1=3, d2=1);
        }
        translate([0,0,-1]) cylinder(h=4, d=(cupDiameter-4));
        translate([0,0,1.5])
            difference() {
                cylinder(h=2, d=coilDiameter);
                cylinder(h=2, d=coilInnerDiameter);
            }
        translate([0, -((cupDiameter/2)-1), 1.5])
            #cube(size=[2,4,1], center=true);

    }
}