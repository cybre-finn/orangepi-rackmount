$fn=100;

panelWidth=254;
panelHeight=44.45;
spacexEdgeHoles=254-248;
spaceyEdgeHoles=6.33;
innerWidth=panelWidth-spacexEdgeHoles-(3+6+3);
paddingX=spacexEdgeHoles+37;
piUSBWidth=14.75;
piEthernetWidth=16;
paddingUsbEth=5.5;
PcbThickness=4;
PcbLength=94;
panelThickness=4;
sataUsbDimens=[73.35,10.75,19.10];
widthJacks=2*paddingUsbEth+2*piUSBWidth+piEthernetWidth;

difference() {
    panel();
    jacks(9);
    sataUSB([0,2*sataUsbDimens[1]+2*4+2]);
    sataUSB([92,2]);
    sataUSB([92,sataUsbDimens[1]+4+2]);
    sataUSB([92,2*sataUsbDimens[1]+2*4+2]);
}

supports(3, 11, 1.5, PcbLength ,4.5, 2.5, 0,widthJacks, [17.5,90]);
supports(2*sataUsbDimens[1]+2*4, 11,2, 110, 2,  6, 0, sataUsbDimens[0],  [33.4-panelThickness,110-panelThickness]);
supports(0, 11,2,110,2, 6, 92,sataUsbDimens[0], [33.4-panelThickness,110-panelThickness]);
supports(sataUsbDimens[1]+4, 11,2, 110, 2,  6, 92, sataUsbDimens[0],  [33.4-panelThickness,110-panelThickness]);
supports(2*sataUsbDimens[1]+2*4, 11,2, 110, 2,  6, 92, sataUsbDimens[0],  [33.4-panelThickness,110-panelThickness]);

module panel() {
    difference (){
        roundedCube([panelWidth,panelHeight,panelThickness],3);
        translate([spacexEdgeHoles,spaceyEdgeHoles,-1]) {
            holes();
        }
        translate([spacexEdgeHoles+innerWidth, spaceyEdgeHoles,-1]) {
            holes();
        }
    }
}

module holes() {
    hull() {
        cylinder(10,3,3);
        translate([6,0,0]) cylinder(10,3,3);
    }
    hull() {
        translate([0,31.8,0]) {
            cylinder(10,3,3);
            translate([6,0,0]) cylinder(10,3,3);
        }
    }
}
 
module piUSB() {
    cube([piUSBWidth,16,20]);
}

module piEthernet() {
    cube([piEthernetWidth,14,20]);
}

module jacks(jackYpadding) {
    translate([paddingX,jackYpadding,-1]) piUSB();
    translate([paddingX+paddingUsbEth+piUSBWidth,jackYpadding,-1]) piEthernet();
    translate([paddingX+2*paddingUsbEth+piUSBWidth+piEthernetWidth,jackYpadding,-1]) piUSB();
}

module supports(supporterYpadding, width, height, lenght, spacingRightLeft, holePadding, spaceX, inBetween,zHoles) {
    translate([paddingX+spaceX-spacingRightLeft,supporterYpadding,panelThickness]) {
        supportPart(false);
    }
    translate([paddingX+spaceX+inBetween+spacingRightLeft-width,supporterYpadding,panelThickness]) {
        supportPart(true);
    }
    module supportPart(side) {
        holePos =   side ? width-holePadding-spacingRightLeft : holePadding+spacingRightLeft ;
        difference() {
            cube([width,height,lenght]);
            translate([holePos,5,zHoles[0]]) {
                rotate([90,0,0]) cylinder(10,1.3,1.35);
            }
            translate([holePos,5,zHoles[1]]) {
                rotate([90,0,0])cylinder(10,1.5,1.35);
            }
        }
        if (side==false) {
            cube([1,5,lenght]);
            prism(1, sataUsbDimens[1]+4, 80);
            cube([1,sataUsbDimens[1]+4, 10]);
        }
        if (side==true) {
            translate([width-1,0,0]) {
                cube([1,5,+lenght]);
                prism(1, sataUsbDimens[1]+4, 80);
                cube([1,sataUsbDimens[1]+4, 10]);
            }
        }
    }
}

module prism(l, w, h){
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,0,h], [l,0,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module sataUSB(params) {
    translate([paddingX+params[0],params[1],-1]) cube(sataUsbDimens);
}

module roundedCube(dimens, radius){
    points = [ [radius,radius,0], [dimens[0]-radius,radius,0], [radius,dimens[1]-radius,0], [dimens[0]-radius,dimens[1]-radius,0] ];
    hull(){
        for (p = points){
            translate(p) cylinder(r=radius, h=dimens[2]);
        }
    }
}