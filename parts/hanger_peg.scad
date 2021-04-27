// Hook pegs, cylinder with a notch
module hanger_peg(h=10,d=3.3,notch=2,lip=1) {
  assert(h >= notch + lip, "Height must be larger than notch and lip");
  difference() {
    cylinder(d=d, h=h, center=true);
    translate([0, d/2, h/2 - notch/2 - lip]) {
      cube(size=[d+1, d, notch], center=true);
    }
  }
}
hanger_peg(h=5,$fn=20);

