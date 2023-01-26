echo(version=version());
// Knob to replace lost part on fishing reel.

$fs=0.5;
module reelKnob() {
	// Simplest form is three cylinders.

	difference() {
		// Inner knob; sits inside the sleeve on the reel.
		cylinder(r=10/2, h=5, center=false);

		// Hole for head of bolt
		translate([0, 0, -1]) {
			cylinder(r=5.6/2, h=3+1, center=false);
		}
	}

	// Hex inset into bolt head
	translate([0, 0, 3-1]) {
		cylinder(r=2.5/2, h=1, center=false, $fn=6);
	}

	// add another outter most cylinder for where your fingers grab?
	translate([0, 0, 5]) {
		cylinder(r=15/2, h=5, center=false, $fn=12);
	}
}

reelKnob();
