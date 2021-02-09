$fn=60;

thickness = 5;
width = 60;
height = 120;
bevel = 30;

mounting_hole_spacing = 85;
mounting_hole_size = 2;

wedge_width = 45;
wedge_height = 112;
wedge_angle = 15;

module plate() {
    translate([-width/2, -height/2, 0])
    difference() {
        minkowski(){
            difference() {
                cube([width, height, thickness]);

                translate([-1,0,0]) 
                rotate([90-bevel,0,0]) 
                cube([width+2, 10, 10]);

                translate([-1, height, 0])
                rotate([bevel,0,0]) 
                cube([width+2, 10, 10]);
                      
                translate([0, -1, 0])
                rotate([0,bevel-90,0]) 
                cube([10, height+2, 10]);
                
                translate([width, -1, 0])
                rotate([0,-bevel,0]) 
                cube([10, height+2, 10]);
            }
            sphere(.5);
        }
        
        translate([-250,-250,-2]) cube([500, 500, 2]);
    }
}


module screw_hole() {
    translate([0, 0, -1])
    cylinder(h=100, r=mounting_hole_size);
    translate([0, 0, 3])
    cylinder(h=100, r=mounting_hole_size*2);
}

module mounting_holes() {
    translate([0, mounting_hole_spacing/2, 0]) screw_hole();
    translate([0, -mounting_hole_spacing/2, 0]) screw_hole();
}

module prism(l, w, h){
    minkowski(){
        polyhedron(
            points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
            faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
        );
        sphere(.5);
    }
}

module wedge() {
    translate([wedge_width/2, -wedge_height/2, thickness])
    rotate([0,0,90])
    prism(wedge_height, wedge_width, wedge_width*sin(wedge_angle));
}

module wiring_hole(){
    hull(){
        translate([0, 10,-1]) cylinder(h=100, r=10);
        translate([0, -10,-1]) cylinder(h=100, r=10);
    }
}

module hexagon(radius)
{
  circle(r=radius,$fn=6);
}



difference(){
    union() {
        plate();
        wedge();
    }
    mounting_holes();
    wiring_hole();
}
