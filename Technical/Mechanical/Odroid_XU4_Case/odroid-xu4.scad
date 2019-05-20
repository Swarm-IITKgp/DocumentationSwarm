XU4_WIDTH = 83.1;
XU4_HEIGHT=59;

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

module round_cube_2(size, radius) {
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
    translate([x-radius, y-radius, 0]) cube([radius, radius, z]);
    translate([0, y-radius, 0]) cube([radius, radius, z]);
}

module odroid_xu4() {
	w=XU4_WIDTH;
	h=XU4_HEIGHT;
    // PCB
    color("lightblue") translate([0,0,2]) cube([w,h,1]);
    difference() {
        color("lightblue") round_cube([w,h,1], 3);
        
        translate ([3.5,3.5,-1]) cylinder(r=1.5, h=3);
        translate ([w-3.5,3.5,-1]) cylinder(r=1.5, h=3);
        translate ([w-3.5,h-3.5,-1]) cylinder(r=1.5, h=3);
        translate ([3.5,h-3.5,-1]) cylinder(r=1.5, h=3);
    }
    
    
    // ethernet
    color("lightgrey") translate([8,0,1]) cube([16, 21.42, 13.5]);
    
    // usb 2.0
    color("lightgrey") translate([25.5,0,1]) cube([7.5, 1, 15]);
    color("lightgrey") translate([26.5,0,1]) cube([5.5, 19.5, 15]);
    
    // power
    color("darkgrey") translate([35,-0.8,1]) cube([8, 11, 10]);
    
    // fan + heatsing
    difference() {
        color("lightgray") translate([34,12,1]) cube([41, 41, 13.5]);
        translate([54.5,32.5,5]) cylinder(r=18, h=10);    
    }
    color("white")  translate([29,41,-4]) cylinder(r=2.3, h=22.3);   
    color("white")  translate([78,22,-4]) cylinder(r=2.3, h=22.3);   
    
    // usb 3.0
    color("lightgrey") translate([7.5, h-1,1]) cube([15, 1, 15.5]);
    color("lightgrey") translate([8.5, h-17.5,1]) cube([13, 17.5, 15.0]);
    
    // emmc
    color("darkred") translate([45, 0, -1.8]) cube([13.5, 18.67, 1.8]);
    color("darkgrey") translate([46, 2, -2.63]) cube([11.5, 13, 2.63]);
    
    // rtc
    color("white") translate([0.5, 24.5,1]) cube([3.6, 7.6, 6]);
    
    // uart
    color("white") translate([.5, 37.5,1]) cube([5, 12.5, 10]);

    // button
    color("black") translate([30, h-2.7, 1]) cylinder(r=1.6, h=13.5);
    color("gray") translate([26.9, h-6, 1]) cube([6,6,4]);
    
    // gpio
    color("black") translate([35.5, h-1-5.4, 1]) cube([37.5, 5.4, 6]);
    
    // i2s
    color("black") translate([w-5.5-1, h-7-19.5,1]) cube([5.5, 19.5, 6]);
    
    // cdcard/emmc switch
    color("gray") translate([w-3.8, 8, 1]) cube([3.8, 8.5, 3.5]);
    color("white") translate([w, 10, 3]) cube([2, 3, 1.5]);
    
    // hdmi
    color("lightgray") translate([w-23.5, -1, 1]) cube([15.5, 11.5, 6.5]);
    
    // sdcard
    color("lightgray") translate([46, 5, 1]) cube([8, 6, 3]);

}


module spacers() {
	w=XU4_WIDTH;
	h=XU4_HEIGHT;

    for(x=[3.5, w-3.5]) for(y=[3.5, h-3.5]) {
        translate([x, y, 1]) cylinder(r=2.35, h=19, $fn=6);
    }    

    for(x=[3.5, w-3.5]) for(y=[3.5, h-3.5]) {
        translate([x, y, -6]) cylinder(r=2.35, h=6, $fn=6);
    }    

    
}


module top_lid() {
    w=XU4_WIDTH;
    h=XU4_HEIGHT;
    depth = 1.5;
    w_add = 3;
    
    difference() {
        // + 8
        round_cube([ w + w_add + 8, h,depth], 4);
        for(x=[3.5, w-3.5]) for(y=[3.5, h-3.5]) {
            translate([x, y, -1]) cylinder(r=1.6, h=3);
        }

        for(x=[5:15:w-10]) for(y=[9:15:h-10]) {
            translate([x, y, -1]) cube([12,12,3]);
        }
        
        // буква Г
        translate([w+w_add, -1, -1]) cube([2.5, 40+1, 3]);
        translate([w+w_add+2, -1, -1]) cube([10, 20, 3]);
        
        translate([w, 45, -1]) cube([7, 10, 3]);
       
    }

    translate([w+8.25, 19, 0]) cylinder(r=2.77, h=depth);
    
    
   
    // secure to a ruler
    
    ruler_thick = 2;
    ruler_height = 40;
             
    // буква O
    translate([w-38, -10, 0])  difference()  {
        round_cube_2([38+w_add, 10, depth], 3);
        translate([7, 5,-1]) cylinder(r=1.6, h=3);
        translate([12, 3.5, -1]) cube([26, 3, 3]);
    }    
    
    //translate([w, 0, 0])  difference() {
    //    cube([10,h, 2]);
    //    //translate([4, 0, -1]) cube([1, 50, 5]);
    //    translate([4, 0, -1]) cube([ruler_thick + 0.5, ruler_height+ 10, 5]);
    //    translate([5,0,0]) rotate([0,0,0]) cube([5,2,5]);
    //}

    //translate([w+7,5,0]) rotate([1,1,0]) cylinder(r=2, h=2);
}

module bottom_lid() {
    top_lid();
    // emmc support
    // translate([45, 0, 0]) cube([13.5, 18.67, 3.5]);
    r = 5;
    translate([47+r, r+3, 0]) cylinder(r=r, h=4.5, center=false);
    
    //r = 10;
    
    translate([52,   8, 0]) cylinder(r=7.5, h=2, center=false);
    translate([52,   8, 0]) cylinder(r=7, h=2.5, center=false);
    translate([52,   8, 0]) cylinder(r=6.5, h=3, center=false);
    translate([52,   8, 0]) cylinder(r=6, h=3.5, center=false);
    translate([52,   8, 0]) cylinder(r=5.5, h=4, center=false);
    //translate([52,   8, 0]) cylinder(r=5.5, h=4.8, center=false);
}

module gate() {
    difference() {
        union() {
            translate([0, 1, 0]) round_cube([15, 32.5, 1.5], 2);
            translate([0, 5.5, 0])  round_cube([28, 24, 1.5],2);
        }
        translate([5, 11, -1]) cube([19, 12, 5]);
        translate([4, 4.5, -1]) cube([8, 25, 3]);        
    }
 
    translate([0, 5.5, 0]) round_cube([4, 4, 4], 1);
    translate([13, 5.5, 0]) round_cube([4, 4, 4], 1);
    translate([0,  25.5, 0]) round_cube([4, 4, 4], 1);
    translate([13, 25.5, 0]) round_cube([4, 4, 4], 1);
    
}

module support() {
    difference() {
        cube([36, 8, 1]);
        translate([5, -1, -1]) cube([1.5, 6, 3]);
        translate([12, -1, -1]) cube([1, 6, 3]);
        translate([13+19, -1, -1]) cube([1.5, 6, 3]);
        
    }
    
}

module preview() {
    
    odroid_xu4();
    spacers();
    translate ([0, 0, 20]) top_lid();
    translate ([0, 0, -7]) bottom_lid();
    // 58 - > 68
    rotate([90,0,0]) translate([68,-10,4]) gate();

    
    //rotate([0,270,180]) translate([-12, -2, 5]) support();
}

module top_and_bottom_lids() {
    translate([XU4_WIDTH, XU4_HEIGHT]) rotate([0, 0, 180]) top_lid();
    translate([0,70,0]) bottom_lid();
    translate([48,XU4_HEIGHT,0]) cube([2, 10, 1.5]); 
}

module many_gates() {
    // 60, 80
    for(x=[0:29:40]) for(y=[0:33:30]) {
        translate([x, y, 0]) gate();
        if(x<50) {
           translate([x+25, y+15, 0]) cube([6,1, 1.5]);
        }
        //if(y<60) {
        //   translate([x+10, y+30, 0]) cube([1,6, 1.5]);    
        //}
    }
    
    
}

$fn=50;
preview();

//top_and_bottom_lids();
// build

//projection(cut = false)


//for(y=[0:10:40]) {
//    translate([0, y, 0]) support();
//}

    
//many_gates();
    