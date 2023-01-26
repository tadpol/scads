echo(version=version());

// Values are in millimeters

$fa=1;
$fs=1;
////////////////////////////
function weather_shield_dims(has_lux=true) = [23, 34, has_lux?7:2.5];

module weather_shield(has_lux=true) {
	motenio = [23, 34, 2.5];
	cube(motenio);

	if(has_lux) {
		translate([0, 9, 4.5]) {
			cube([13, 10.2, 2.5]);
		}
		translate([13-2.5, 9, 2.5]) {
			cube([2.5, 10.2, 2.5]);
		}
	}
}

weather_shield();
