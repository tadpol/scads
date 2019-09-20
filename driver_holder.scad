
$fs=1;


// A template for punch outs for adding hooks for Ikea's Skadis pegboard
// Uses Skadis_Universal_Hook.stl to attach to pegboard.
module skadis_template(thick=4.5, cutpad=2, rep=1, repgap=40) {
	end = repgap * (rep - 1);
	for(i = [0:repgap:end]) {
		translate([i,0,0]) {
			cube([thick,thick+cutpad,thick]);
			translate([0,0,35.3-thick-((thick*2)+1)]) cube([thick,thick+cutpad,(thick*2)+1]);
		}
	}
}

// A double ring holder for small screw driver.
module holder(d1=13, d2=4.1, space=21, h=21, thick=4.5) {
	union() {
		outter_d1 = d1+(thick*2);
		outter_r1 = outter_d1/2;
		outter_d2 = d2+(thick*2);
		outter_r2 = outter_d2/2;
		difference() {
			union() {
				cylinder(d=outter_d1, h=thick);
				translate([-outter_r2,0,0]) cube([outter_d2, outter_r1, thick]);
			}
			translate([0,0,-.25]) cylinder(d=d1, h=thick+0.5);
		}
		translate([0,0,-space]) {
			difference() {
				union() {
					cylinder(d=outter_d2, h=thick);
					translate([-outter_r2,0,0]) cube([outter_d2, outter_r1, thick]);
				}
				translate([0,0,-.25]) cylinder(d=d2, h=thick+0.5);
			}
		}
		translate([-outter_r2,outter_r1, -space]) cube([outter_d2, thick, h+thick]);
	}
}

difference() {
	union() {
		st = 13 + (4.5 * 2) - 2;
		v=st * 6;
		for (s=[0:st:v]){
			translate([s,0,0]) holder(h=31);
		}
		translate([0,13-2,-21]) cube([120,4.5,4.5]);
	}

	translate([-(4.5) + (13 + (4.5*2)),13-7,-21])
		skadis_template(rep=3, cutpad=8);
}
//holder();
// difference() {
// 	holder(h=31);
// 	translate([-4.5/2,6,-21.5])  skadis_template(cutpad=8);
// }


// vim: set ai sw=2 ts=2 :
