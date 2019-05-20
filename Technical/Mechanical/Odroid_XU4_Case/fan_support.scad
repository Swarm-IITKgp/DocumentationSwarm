module round_cube(size, radius) {
    x = size[0];
	y = size[1];
	z = size[2];
    
    linear_extrude(height=z)
	hull()
	{
		// place 4 circles in the corners, with the given radius
		translate([0+radius ,0+radius, 0])
		circle(r=radius);
	
		translate([0+radius, y-radius, 0])
		circle(r=radius);
	
		translate([x-radius, y-radius, 0])
		circle(r=radius);
	
		translate([x-radius, 0+radius, 0])
		circle(r=radius);
	}
    
}


module nuts() {
    translate([0,0,0]) cylinder(r=3, h=10);
    translate([0,75,0]) cylinder(r=3, h=10);
    
    translate([35,-3,0]) cylinder(r=1.5, h=20);
    translate([35,72-3,0]) cylinder(r=1.5, h=20);
}


module support() {
    difference() {

        union() {
            translate([-8,-8,0]) round_cube([36,75+15, 3], 2);
            translate([0,-8,0]) round_cube([45, 10, 3], 2);
            translate([0,64.5,0]) round_cube([45, 10, 3], 2);

        }
        // 3 D
        translate([-5,-3.5,-1]) round_cube([10, 7, 10], 1);
        translate([-5,71.5,-1]) round_cube([10, 7, 10], 1);
  
        // 1.5 D
        translate([30, 67.25,-1]) round_cube([10, 3.5, 10], 1);
        translate([30, -4.75,-1]) round_cube([10, 3.5, 10], 1);

        // optimize
        translate([0, 10, -1]) round_cube([20, 55, 10], 1);
        
     }
}

$fn=20;
//nuts();
support();

