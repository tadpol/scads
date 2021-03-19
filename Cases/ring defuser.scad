
// For building the part that clips on the LED ring
ring_inside = 31/2;
ring_outside = 45/2;
inside_height = 3.33;

wall_thickness = 0.4 * 2; // 2x extusion width
//$fs=0.01;
$fn=80;

//============================================================================

module led_ring(r1,r2,h) {
	difference() {
		cylinder(r=r2, h=h);
		translate([0,0,-0.5]) cylinder(r=r1, h=h+1);
	}
}

// build as a shell
// Round top
difference() {
union() {
	torus_r_outside=((ring_outside-ring_inside) + wall_thickness*2)/2;
	torus_r_inside=(ring_outside-ring_inside)/2;
	difference() {
		rotate_extrude()
			translate([ring_inside+torus_r_outside-wall_thickness,0,0])
				circle(torus_r_outside);

		rotate_extrude() translate([ring_inside+torus_r_inside,0,0]) circle(torus_r_inside);

		translate([0,0,-torus_r_outside])
			cylinder(r=ring_outside+wall_thickness+1, h=torus_r_outside);
	}

	difference() {
		translate([0,0,-inside_height]) led_ring(ring_inside-wall_thickness, ring_outside+wall_thickness, inside_height);
		translate([0,0,-inside_height-0.5]) led_ring(ring_inside, ring_outside, inside_height+1);
	}
}

	translate([0,0,-(inside_height + 3)])
		cylinder(r=ring_outside+wall_thickness+1, h=3);
}

// Flat top
!difference() {
// TODO: add lip or tabs to lock on to led ring?
	led_ring(ring_inside-wall_thickness, ring_outside+wall_thickness, inside_height+wall_thickness*2);
	translate([0,0,-0.5]) led_ring(ring_inside, ring_outside, inside_height+0.5);
}

// vim: set sw=2 ts=2 :
