echo(version=version());


$fs=0.5;
difference() {
  cube([10,10,10]);
  translate([10/2, 5.5/4, -0.5]) {
    cylinder(d=5.5, h=11, center=false);
  }
}