width=18.75;
thickness=1.25;
height=15;
slot=12;
span=60;
wall=1.5;
pinch=0.1;
tip_width=11;
tip_height=7;
bottom_gap=10;
bolt_r=4;

$fn=48;

module stand(width,thickness)
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

module card_cutout()
{union() {
		CubePoints = [
		  [  0,  1,  0 ],  //0
		  [ width/2,  1,  0 ],  //1
		  [ width/2-pinch,  thickness+1,  0 ],  //2
		  [  0,  thickness+1,  0 ],  //3
		  [  0,  1,  height*2 ],  //4
		  [ width/2,  1,  height*2 ],  //5
		  [ width/2-pinch,  thickness+1,  height*2 ],  //6
		  [  0,  thickness+1,  height*2 ]]; //7

		CubeFaces = [
		  [0,1,2,3],  // bottom
		  [4,5,1,0],  // front
		  [7,6,5,4],  // top
		  [5,6,2,1],  // right
		  [6,7,3,2],  // back
		  [7,4,0,3]]; // left

		translate([0,-1,tip_height])
		polyhedron( CubePoints, CubeFaces );

		cube([tip_width/2,thickness,tip_height+1]);

}}

module shape_tombstone(r,h,a)
{
	union() {
		cube([r*2,h,a]);
		translate([r,h,a])
		rotate([90,0,0]) {
			cylinder(r=r,h=h);

			cylinder(r=r,h=h);
		}
	}

}

function shape_bend_pos(r,t,a) = [
(t+r)-((t+r)*sin(a))
,0,
((t+r)*cos(a))
];

function shape_bend_rot(r,t,a) = [0,90-a,0];

module shape_bend(r,t,a,h)
{difference() {
	translate([t+r,h,0])
	rotate([90,0,0])
	difference() {
		cylinder(r=t+r,h=h);
		translate([0,0,-h*0.5])
			cylinder(r=r,h=h*2);

		rotate([0,0,a])
		translate([0,-(r+t),-h])
			cube([(r+t)*3,(r+t)*3,h*4]);
	}
	translate([-(r+t),-h*2,-(r+t)*2])
		cube([(r+t)*3,h*4,(r+t)*2]);
}}


module stand_1fa_half()
{
	difference() {
		//cube([span/2,thickness+wall*2,height+span*bottom_gap]);
		union() {
			cube([width/2+wall,thickness+wall*2,height+bottom_gap]);
			translate([height+bottom_gap+(width-height-wall*2),0,0])
			rotate([0,-90,0])
			shape_bend(height,bottom_gap,0,thickness+wall*2);
			translate([height+bottom_gap+(width-height-wall*2),0,bottom_gap/2])
			rotate([-90,0,0])
			cylinder(r=bottom_gap/2,h=thickness+wall*2);
		}

		// Bottom cutout for stability
		//scale([1,1,bottom_gap*2])
		//translate([0,thickness+wall*4,0])
		//rotate([90,0,0])
			//cylinder(r=(span*0.33),h=thickness+wall*5);
		hull() {
		scale([2,1,1])
		translate([0,-wall,0])
		rotate([0,90,0])
			shape_tombstone(r=wall*2,h=thickness+wall*4,a=span/4*0.66-wall*2);
		translate([0,thickness+wall*4,0])
		rotate([90,0,0])
			cylinder(r=width/2+wall,h=thickness+wall*5);
		}

		// Corner cutout for looks
		//translate([span/2,thickness+wall*4,height+span*bottom_gap])
		//scale([1,1,0.8])
		//rotate([90,0,0])
			//cylinder(r=(span/2-width/2-wall),h=thickness+wall*5);

		// Card slot
		translate([0,wall,bottom_gap-1])
			card_cutout();

		// slot for rounded plates
		translate([0,-wall,slot+bottom_gap-1])
			cube([width/2,thickness+wall*2,height*2]);
		
		// Hole for connector screw
		//translate([0,thickness+wall*4,height+span*bottom_gap])
		//rotate([90,0,0])
		//cylinder(r=bolt_r,h=thickness+wall*5);
	}
}

module stand_1fa()
{union(){
	stand_1fa_half();
	mirror([1,0,0]) stand_1fa_half();
}}

stand_1fa();

