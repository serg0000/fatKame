// Blomdofts redesign to make the Kame fat.
// Battery

// Set quality
$fa = 0.5; // minimum angle
$fs = 0.5; // facet size


// kame outer parameters
kamebox_length=102;
kamebox_width=77;
kamebox_servobox_height=30; // was:32.
kamebox_wallstrength= 2;
kamebox_lid_height= 6;
servo_width=12;

batterydoor_width=kamebox_width-2*(kamebox_wallstrength+servo_width+8);
batterydoor_rim=3;
batterydoor_length=50;

//---------
// Model starts here


// battery chute
translate([(kamebox_length-batterydoor_length)*6/8, (kamebox_width-batterydoor_width)/2-batterydoor_rim-2, -2])
cube([batterydoor_length+8, batterydoor_width+1+batterydoor_rim*2+4, 1]);

translate([(kamebox_length-batterydoor_length)*7.5/8+4, (kamebox_width-batterydoor_width)/2-batterydoor_rim+1, -1]) {
difference() {
    cube([8,batterydoor_rim+3, kamebox_wallstrength*2+1]);
    cube([6,batterydoor_rim+1, kamebox_wallstrength]);    
    }
}

translate([(kamebox_length-batterydoor_length)*7.5/8+4, (kamebox_width-batterydoor_width)/2+batterydoor_width-2, -1]) {
difference() {
    cube([8,batterydoor_rim+3, kamebox_wallstrength*2+1]);
    translate([0,2,0])
    cube([6,batterydoor_rim+1, kamebox_wallstrength]);    
    }
}

translate([(kamebox_length-batterydoor_length)*6/8+batterydoor_length-7, (kamebox_width-batterydoor_width)/2-batterydoor_rim+1, -1]) {
difference() {
    cube([8,batterydoor_rim+3, kamebox_wallstrength*2+1]);
    cube([6,batterydoor_rim+1, kamebox_wallstrength]);    
    }
}

translate([(kamebox_length-batterydoor_length)*6/8+batterydoor_length-7, (kamebox_width-batterydoor_width)/2+batterydoor_width-2, -1]) {
difference() {
    cube([8,batterydoor_rim+3, kamebox_wallstrength*2+1]);
    translate([0,2,0])
    cube([6,batterydoor_rim+1, kamebox_wallstrength]);    
    }
} 