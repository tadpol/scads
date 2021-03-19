echo(version=version());

// Values are in millimeters

$fa=1;
$fs=1;
////////////////////////////

headerLength=15;
headerWidth=2.7;

headerOffset = 2;
clipWidth = headerLength + (headerOffset * 2);

////////////////////////////
module spring(h=clipWidth, d=15, inset=4) {
  difference() {
    cylinder(h=clipWidth, d=d);
    translate([0,0,-1]) cylinder(h=clipWidth+2, d=d-inset);
    translate([-(d*2)/3,0,-1]) cylinder(h=clipWidth+2, d=d);
  }
}


module handle(length=40, r=-20, width=5) {
  difference() {
    translate([0,-3,0])
      rotate([0,0,r])
        cube([length,width,clipWidth]);

    translate([0,0,-1])
      cube([length,width,clipWidth+2]);
  }
}

difference() {
  union() {
    translate([0,-1,0]) handle(length=50);
    mirror([0,1,0]) translate([0,-1,0]) handle(length=50);
    translate([22,0,0]) spring();
  }

  translate([headerOffset,0,headerOffset]) {
    cube([headerWidth,headerWidth,headerLength]);
    translate([(headerWidth/4),0,headerWidth/4])
    cube([headerWidth-(headerWidth/2),headerLength,headerLength-(headerWidth/2)]);
  }
}

//  vim: set et ai sw=2 ts=2 :
