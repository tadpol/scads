// Triangles

module triangle(angle=90, a=10, b=10) {

	c = sqrt(pow(a,2) + pow(b,2) - 2*a*b*cos(angle));

	p = [
	[0,0],
	[0,a],
];
}
