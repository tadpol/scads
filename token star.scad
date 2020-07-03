$fs=0.1;

module arm(r) {
  translate([-r,r,0]){
    difference(){
      translate([r,0,0]) cylinder(r=r, h=2);

      rotate([0,0,25]) translate([r,0,-.5])
        cylinder(r=r, h=3);
      
      translate([r,r,-.5]) rotate([0,0,270]) cube([r*2,r*2,3]);
    }
  }
}

difference() {
//  cylinder(d=50, h=2);
  for(v = [0:72:360]) {
    rotate([0,0,v]) arm(r=25);
  }
  translate([0,0,-1]) cylinder(d=10, h=5);
}

// vim: set ai et sw=2 ts=2 :
