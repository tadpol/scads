echo(version=version());

// Values are in millimeters

$fa=1;
$fs=1;
////////////////////////////

function moteino_dims(has_ftdi_pins=true, has_headers = "top") = [
	(23),
	(34 + (has_ftdi_pins?10:0)),
	(2.5 + ((has_headers)?10:0))
	];
	


module moteino(has_ftdi_pins=true, has_headers = "top") {
	motenio = [23, 34, 2.5];
	cube(motenio);

	if(has_ftdi_pins) {
		translate([4, -10, motenio[2]]) {
			cube([15, 12, 3]);
		}
	}
	header = [3, motenio[1], 10];
	if(has_headers == "top") {
		translate([0, 0, motenio[2]]) cube(header);
		translate([(motenio[0] - header[0]), 0, motenio[2]]) cube(header);
	} else if (has_headers == "bot" || has_headers == "bottom") {
		translate([0, 0, -header[2]]) cube(header);
		translate([(motenio[0] - header[0]), 0, -header[2]]) cube(header);
	}
}


moteino();

// vim: set ai sw=2 ts=2 :
