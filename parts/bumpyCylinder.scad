
// Started from: http://forum.openscad.org/file/n21474/polar_coordinates.scad

// I feel like this shape has a name.  It reminds me of sugar cookies.
module bumpy_cylinder(r=20, cr=4, h=1) {
	pi = 3.1416;
	t_max = 1; // create polygon based on polar plot in the range of 0 < t <= t_max
	function sine_thing(t,r=10,n=8) = r + sin(n*(t/t_max)*360); // a multi-lobed pattern
	degrees = (180 * (cr*2)) / (r*pi);
	total = ceil(360/degrees); // How many bumps (periods)
	fragments = total*10; // How smooth is the wave
	//echo(360/total);

	points = [ for (i = [0:fragments])
		let(
				t = (i * t_max / fragments),
				angle = i * 360 / fragments,
				r = sine_thing(t,r=r, n=total)
			)
		[r*cos(angle), r*sin(angle)]
	];

	linear_extrude(h)
		polygon(points);
}



// Move children to top of bump. (Start of period)
// Rotate children to top of bump (Start of period).  They still need to translate
// out.
// This seems to start a 1/4 off, why?
module bumpy_cylinder_rotate_to(r=20, cr=4, idx=1) {
	pi = 3.1416;
	t_max = 1; // create polygon based on polar plot in the range of 0 < t <= t_max
	function sine_thing(t,r=10,n=8) = r + sin(n*(t/t_max)*360); // a multi-lobed pattern
	degrees = (180 * (cr*2)) / (r*pi); // NOT the actual period. (because of ceil())
	total = ceil(360/degrees); // How many bumps (periods)
	fragments = total*10; // How smooth is the wave
	step = 360/total; // Degrees for each period.

	rotate([0,0, (idx + 0.25)*step])
		children();
}

bumpy_cylinder(r=20, cr=3);
bumpy_cylinder_rotate_to(r=20, cr=3, idx=3.25)
	translate([20,0,0])
		cylinder(r=1,h=4,$fn=10, center=true);

// vim: set sw=2 ts=2 :
