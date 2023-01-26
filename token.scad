$fs=0.1;

module spot_bean() {
translate([-67,6,0.9])
scale([0.6,0.6,0.6])
linear_extrude(height = 5, center = false, convexity = 10)
	import("bean.svg");
}

difference() {
	cylinder(d=50, h=2);
	translate([0,0,-1]) cylinder(d=10, h=5);

	spot_bean();
	mirror([0,1,0]) spot_bean();
}

// vim: set sw=2 ts=2 :
