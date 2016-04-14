// Blomdofts redesign to make the Kame fat.
// Different servos, large BEC and sensor eyes.

// Set quality
$fa = 0.5; // minimum angle
$fs = 0.5; // facet size

// lower/upper switcher, to extract the two parts
lower=true;

// kame outer parameters
kamebox_length=102;
kamebox_width=77;
kamebox_servobox_height=32;
kamebox_wallstrength= 2;
kamebox_lid_height= 6;

kamebox_iro_width=32;
kamebox_iro_length = 72;
kamebox_iro_height = 12;

// servo parameters
servo_width=12;
servo_height = 21;
servo_length=24;
servo_overhang=4;
servo_mounthole = 0.7;

// kame inner parameters
servobed_height=6;
servobed_upper_height=5;
overlap_height = 4;
offset_anchor_length = 12;
offset_anchor_width= 7;

batterydoor_width=kamebox_width-2*(kamebox_wallstrength+servo_width+8);
batterydoor_rim=3;
batterydoor_length=50;

// ---------------------
// Modules

// attribution: groovenectar
module roundedcube_simple(size = [1, 1, 1], center = false, radius = 0.5) {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate = (center == false) ?
		[radius, radius, radius] :
		[
			radius - (size[0] / 2),
			radius - (size[1] / 2),
			radius - (size[2] / 2)
	];

	translate(v = translate)
	minkowski() {
		cube(size = [
			size[0] - (radius * 2),
			size[1] - (radius * 2),
			size[2] - (radius * 2)
		]);
		sphere(r = radius);
	}
}

// simple servo box cutout
module servobox() {
        translate([servo_overhang, 0, -1])
        cube([servo_length, servo_width, servo_height+5]);
        translate([servo_overhang/2, servo_width/2, -1])
        cylinder(r=servo_mounthole, h = servo_height+5);
        translate([servo_length+servo_overhang/2+servo_overhang, servo_width/2, -1])
        cylinder(r=servo_mounthole, h = servo_height+5);
}


// ---------------------
// Model starts here

if(lower) {
    difference() {
        union() {    
            // base cube
            difference() {
                    roundedcube_simple([kamebox_length, kamebox_width, kamebox_servobox_height], radius=2);
                    
                // main inner cut
                translate([kamebox_wallstrength, kamebox_wallstrength, kamebox_wallstrength])
                cube([kamebox_length-kamebox_wallstrength*2, kamebox_width-kamebox_wallstrength*2, kamebox_servobox_height-kamebox_wallstrength*2]);
         
                // -----   
                // open box cut
                translate([-1, -1, kamebox_servobox_height - kamebox_lid_height])
                    cube([kamebox_length+2, kamebox_width+2, kamebox_servobox_height]);
     
                // -----   
                // open box cut
                translate([kamebox_wallstrength/2, kamebox_wallstrength/2, kamebox_servobox_height - kamebox_lid_height-overlap_height])
                    cube([kamebox_length-kamebox_wallstrength, kamebox_width-kamebox_wallstrength, overlap_height]);

                }
                
            // servobed
            translate([kamebox_wallstrength, kamebox_wallstrength, 0])
            cube([kamebox_length-2*kamebox_wallstrength, servo_width+1, servobed_height]);
            
            translate([kamebox_wallstrength, kamebox_width-servo_width-1-kamebox_wallstrength, 0])
            cube([kamebox_length-2*kamebox_wallstrength, servo_width+1, servobed_height]);
        }
        
        // cut servo places
        translate([kamebox_wallstrength, kamebox_wallstrength, 0])
            servobox();
        
        translate([kamebox_length-kamebox_wallstrength-2*servo_overhang-servo_length, kamebox_wallstrength, 0])
            servobox();
        
        translate([kamebox_wallstrength, kamebox_width-kamebox_wallstrength-servo_width, 0])
            servobox();
        
        translate([kamebox_length-kamebox_wallstrength-2*servo_overhang-servo_length, kamebox_width-kamebox_wallstrength-servo_width, 0])
            servobox();

        // holes for servocable
        translate([kamebox_length/2, kamebox_wallstrength+servo_width*1/3+1, -1])
            scale([1, 0.8, 1])
        cylinder(r=5, h=10);
        translate([kamebox_length/2, kamebox_width-kamebox_wallstrength-servo_width*1/3-1, -1])
                    scale([1, 0.8, 1])    
        cylinder(r=5, h=10);

        // hole for on/off switch
        
        translate([-1, kamebox_width/2, kamebox_servobox_height*0.5]) 
        rotate([90, 0, 90])
        cylinder(r=3, h=kamebox_wallstrength+2);
        


        // place for eyes, module has 26mm hole distance and 16mm sensors
        translate([kamebox_length-kamebox_wallstrength-1, kamebox_width/2-13, kamebox_servobox_height*0.4]) 
        rotate([90, 0, 90])
        cylinder(r=8.15, h=kamebox_wallstrength+2);
        translate([kamebox_length-kamebox_wallstrength-1, kamebox_width/2+13, kamebox_servobox_height*0.4]) 
        rotate([90, 0, 90])
        cylinder(r=8.15, h=kamebox_wallstrength+2);
 
        // battery chute
        translate([(kamebox_length-batterydoor_length)*6/8, (kamebox_width-batterydoor_width)/2, -1])
        cube([batterydoor_length, batterydoor_width+1, kamebox_wallstrength+2]);
                
        translate([(kamebox_length-batterydoor_length)*7.5/8, (kamebox_width-batterydoor_width)/2-batterydoor_rim, -1]) {
               translate([-3, 0, 3]) rotate([0, 20, 0])
        cube([5, batterydoor_rim+1, kamebox_wallstrength+2]);       
    cube([10, batterydoor_rim+1, kamebox_wallstrength+2]);
    }
        translate([(kamebox_length-batterydoor_length)*7.5/8, (kamebox_width-batterydoor_width)/2+batterydoor_width, -1]) {
        cube([10, batterydoor_rim+1, kamebox_wallstrength+2]);
        translate([-3, 0, 3]) rotate([0, 20, 0])
        cube([5, batterydoor_rim+1, kamebox_wallstrength+2]);
    }    
        translate([(kamebox_length-batterydoor_length)*6/8+batterydoor_length-10, (kamebox_width-batterydoor_width)/2-batterydoor_rim, -1]) {
        translate([-3, 0, 3]) rotate([0, 20, 0])
        cube([5, batterydoor_rim+1, kamebox_wallstrength+2]);    
        cube([10, batterydoor_rim+1, kamebox_wallstrength+2]);
    }    
    translate([(kamebox_length-batterydoor_length)*6/8+batterydoor_length-10, (kamebox_width-batterydoor_width)/2+batterydoor_width, -1]) {
            translate([-3, 0, 3]) rotate([0, 20, 0])
        cube([5, batterydoor_rim+1, kamebox_wallstrength+2]);

        cube([10, batterydoor_rim+1, kamebox_wallstrength+2]);
}    
 
    }
} else { // creating the upper part
           // base lid cube

    difference() {
        union() {
            difference() {
                union() {
                    difference() {
                        roundedcube_simple([kamebox_length, kamebox_width, kamebox_servobox_height], radius=2);
                        
                    // -----   
                    // open box cut
                    translate([-1, -1, kamebox_lid_height])
                        cube([kamebox_length+2, kamebox_width+2, kamebox_servobox_height]);
                    }
                    
                    translate([(kamebox_length-kamebox_iro_length)/2, (kamebox_width-kamebox_iro_width)/2, -1* kamebox_iro_height+2])
                    roundedcube_simple([kamebox_iro_length, kamebox_iro_width, kamebox_iro_height], radius=2);

                   // overlap rim, 0.1 for fitting
                    translate([1.1, 1.1, kamebox_lid_height])
                    cube([kamebox_length-2.2, kamebox_width-2.2, overlap_height]);                
                }
                // main inner cut
                translate([kamebox_wallstrength, kamebox_wallstrength, kamebox_wallstrength])
                cube([kamebox_length-kamebox_wallstrength*2, kamebox_width-kamebox_wallstrength*2, kamebox_servobox_height-kamebox_wallstrength*2]);

// cut for MCU
                translate([kamebox_wallstrength+(kamebox_length-kamebox_iro_length)/2, kamebox_wallstrength+(kamebox_width-kamebox_iro_width)/2, -1*kamebox_iro_height+2*kamebox_wallstrength])
                cube([kamebox_iro_length-kamebox_wallstrength*2, kamebox_iro_width-kamebox_wallstrength*2, kamebox_iro_height]);
             
             // cut for usb access
                translate([(kamebox_length-kamebox_iro_length)/2-1, kamebox_width/2-5, -0.55*kamebox_iro_height])
                cube([kamebox_wallstrength+2, 10, 5]);
 
                // cut for reset and program           
                translate([(kamebox_length-kamebox_iro_length)/2+5, kamebox_width/2-7, -    kamebox_iro_height])
                cylinder(r=2, h=kamebox_wallstrength+10);

                translate([(kamebox_length-kamebox_iro_length)/2+5, kamebox_width/2+7, -    kamebox_iro_height])
                cylinder(r=2, h=kamebox_wallstrength+10);

                // cuts to fixate the board
                translate([kamebox_length/2, kamebox_width/2, -1])
                    cylinder(r=kamebox_iro_width/2-1, h=2.2);
                translate([kamebox_length/2-20, kamebox_width/2, -1])
                    cylinder(r=kamebox_iro_width/2-1, h=2.2);
                translate([kamebox_length/2+20, kamebox_width/2, -1])
                    cylinder(r=kamebox_iro_width/2-1, h=2.2);

           }
        
            // servo upper part
            translate([kamebox_wallstrength, kamebox_wallstrength, 0])
            cube([kamebox_length-2*kamebox_wallstrength, servo_width+1, servobed_upper_height]);
            
            translate([kamebox_wallstrength, kamebox_width-servo_width-1-kamebox_wallstrength, 0])
            cube([kamebox_length-2*kamebox_wallstrength, servo_width+1, servobed_upper_height]);
        }
    
        // opposite anchor points for legs
        translate([offset_anchor_length, offset_anchor_width, -1])
            cylinder(r=1.6, h=20);
        translate([offset_anchor_length, offset_anchor_width, kamebox_wallstrength])
            cylinder(r=3.5, h=20, $fn=6);
       
        translate([kamebox_length-offset_anchor_length, offset_anchor_width, -1])
            cylinder(r=1.6, h=20);
        translate([kamebox_length-offset_anchor_length, offset_anchor_width, kamebox_wallstrength])
            cylinder(r=3.5, h=20, $fn=6);
        
        translate([offset_anchor_length, kamebox_width-offset_anchor_width, -1])
            cylinder(r=1.6, h=20);
        translate([offset_anchor_length, kamebox_width-offset_anchor_width, kamebox_wallstrength])
            cylinder(r=3.5, h=20, $fn=6);
       
        translate([kamebox_length-offset_anchor_length, kamebox_width-offset_anchor_width, -1])
            cylinder(r=1.6, h=20);
        translate([kamebox_length-offset_anchor_length, kamebox_width-offset_anchor_width, kamebox_wallstrength])
            cylinder(r=3.5, h=20, $fn=6);
    }
    
}



    
        