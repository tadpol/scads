// Battery tabs for holding AA and similar sized batterys.
// Built for Keystone Electronics parts 5201 and 5223.
// 5201: https://www.keyelco.com/product-pdf.cfm?p=900
// 5223: https://www.keyelco.com/product-pdf.cfm?p=910


// TODO: function to return array for polygon? Is that useful?
// function battery_tab_size() = [1.45,11.20,11.99];

module battery_tab() {
  difference() {
    union() {
      // TODO: round corners?
      cube(size=[0.5, 11.2, 11.99]);
      translate([0, 11.2/2 - 3/2, 11.99])
        cube(size=[0.5, 3, 6.35]);
      translate([0.5, 11.2/2, 5]) {
        rotate([0, 90, 0]) {
          cylinder(h=1.45, r1=5.99/2, r2=3.99/2);
        }
      }
      translate([0.5, 11.2/2, 10.74]) {
        rotate([0, 90, 0]) {
          cylinder(r=2.49/2, h=0.5);
        }
      }
    }

    translate([-0.5, 11.2/2, 18.34-1.5]) {
      rotate([0, 90, 0]) {
        cylinder(r=1.7/2, h=2);
      }
    }
    translate([-0.5, 11.2/2, 10.74]) {
      rotate([0, 90, 0]) {
        cylinder(r=1.52/2, h=2);
      }
    }
  }
}

// function battery_tab_cutout_size() = [1,11.5,12.5];
// Cutout is the foot print of the tab, with padding on y and z.
// Also, Need a sane way to return where the battery aligns.
module battery_tab_cutout(center=false, vpin=false, extend=0) {
  // If center, put the center of the button onto 0,0,0
  // If vpin, add a tall skinny cylinder to visualize where the center is.
  // If extend, 'pull' an edge of the tab that far to allow for inserting the actual tab
  sze=[1, 11.2 + 1, 11.99 + 0.5];
  offset=center?[-0.5,-sze[1]/2,-5]:[0,0,0];
  translate(offset) {
    cube(size=sze);
    if (extend > 0) {
      translate([0, 0, -sze[2]+1]) {
        cube(size=sze);
      }
    }
    if (vpin) {
      translate([0, sze[1]/2, sze[2]/2]) {
        rotate([0, 90, 0]) {
          cylinder(r=0.5, h=20, center=true);
        }
      }
    }
    translate([0, sze[1]/2 - 2.5, sze[2]-0.5]) {
      cube(size=[1, 5, 11]);
    }
  }
}

battery_tab_cutout(center=true, $fs=0.5);
