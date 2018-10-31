
// This is likely what you will want to change if you need it to hold up 
// heavier cards.
span=60;

width=18.75;
thickness=1.25;
height=20;
slot=12;

module stand()
{difference(){
	cube([span,thickness*3,height+1],true);

	translate([0,0,height+1])
		cube([width,thickness,height+1],true);
	translate([0,-thickness*1.5,1+slot])
		cube([width,thickness*3,height+1],true);
	translate([-span/2,thickness*3,(height+1)/2])
	rotate([90,0,0])
		cylinder(r=(span/2-width/2-thickness*1.5),h=thickness*10);
	translate([span/2,thickness*5,(height*1.2)/2])
	rotate([90,0,0])
		cylinder(r=(span/2-width/2-thickness*1.5),h=thickness*10);

}}


stand();
