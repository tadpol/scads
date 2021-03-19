echo(version=version());
$fa=1;
$fs=1;

// Values are in millimeters
extusion_width=0.4;

thickness = 1.75;
length=20;

magnet_d=12;
m_buf=3;

lip=2;

difference() {
	width=magnet_d+m_buf;

	cube([width, length + width + lip, thickness+1]);

	translate([-.5, lip, -0.5])
		cube([width+1, length, thickness]);

	translate([width/2, length + m_buf + magnet_d/2, extusion_width*2])
		cylinder(d=magnet_d + extusion_width*2, h=4);
}

