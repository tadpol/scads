echo(version=version());
$fa=1;
$fs=1;

// Values are in millimeters
extusion_width=0.4;

// Builds a tower of decreasing sizes.  Place tube over to see where it fits.
min_size = 40;
max_size = 43;
step = extusion_width;
check_height = 2;

list = [
	for(h=check_height, d=max_size; d>min_size; h=h+check_height,d=d-step) [d,h]
];
echo(list);

difference() {
	for(do = list) {
		cylinder(d=do[0], h=do[1]);
	}

	translate([0,0,-check_height/2])
		cylinder(d=min_size-step*2, h=len(list) * check_height + check_height);
}

// vim: set sw=2 ts=2 :
