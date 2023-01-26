
// Started from: http://forum.openscad.org/file/n21474/polar_coordinates.scad

// I feel like this shape has a name.  It reminds me of sugar cookies.
module bumpy_cylinder(r=20, cr=4, h=1) {
	pi = 3.1416;
	t_max = 1; // create polygon based on polar plot in the range of 0 < t <= t_max
	function sine_thing(t,r=10,n=8) = r + sin(n*(t/t_max)*360); // a multi-lobed pattern
	degrees = (180 * (cr*2)) / (r*pi);
	total = floor(360/degrees);
	fragments = total*10; // How smooth is the wave

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

bumpy_cylinder(r=20);

// vim: set sw=2 ts=2 :
