// HexBug BattleBot Remote Expander
// Because some of us have big hands.


// Hold the exsting remote with batery cover removed
// Hold two AA bateries and wires to old
// Prefer snap fit, but could use the old battery cover screw hole as anchor

// Still working out the battery things, but can be used as just a size increaser.

// will want rounded edges


echo(version=version());

use <../parts/batteries.scad>;
use <../parts/battery_tab.scad>;

// Values are in millimeters

$fs=0.5;
extruder_width = 0.4;
wall_thickness = 2*extruder_width;

////////////////////////////
function hyp(a,b) = sqrt(pow(a,2)+pow(b,2));


function HexBugBattleBotRemote_size() = [50,34,14];
module HexBugBattleBotRemote() {
  difference() {
    cube([50,34,14]);

    // corner cutouts
    mv=hyp(5,5)/2;
    translate([0,-mv,-0.5]) rotate([0,0,45]) cube([5,5,15]);
    translate([0,34-mv,-0.5]) rotate([0,0,45]) cube([5,5,15]);
    translate([50,34-mv,-0.5]) rotate([0,0,45]) cube([5,5,15]);
    translate([50,-mv,-0.5]) rotate([0,0,45]) cube([5,5,15]);

    // screw hole (not centered on X)
    //#translate([24,6,-0.5]) cylinder(d=1.6, h=3);

    // batteries:
    translate([11.65+6,12.8+6,2.1]) LR44();
    translate([24.1+6,12.8+6,2.1]) LR44();

    // battery cover
    translate([10.8,10,-0.1])
    difference() {
      cube([25.7,15.8,2.3]);
      mvv=hyp(4,4)/2;
      translate([0,-mvv,0]) rotate([0,0,45]) cube([4,4,4]);
      translate([0,15.8-mvv,0]) rotate([0,0,45]) cube([4,4,4]);
      translate([25.7,-mvv,0]) rotate([0,0,45]) cube([4,4,4]);
      translate([25.7,15.8-mvv,0]) rotate([0,0,45]) cube([4,4,4]);
    }
  }
}

/*
difference() {
  cube([50+wall_thickness*2,34+wall_thickness-0.5,10]);
  translate([wall_thickness,wall_thickness,wall_thickness])
    HexBugBattleBotRemote();
}
*/

function battery_holding_size(wall=wall_thickness) =
  let(aasize=battery_size_by_name("AA", hole=true))
  [4+6+4+aasize[0]*2, aasize[1]+wall*2, aasize[1]+wall*2];

// TODO: Add option to output just the cutouts
module battery_holding() {
  aasize=battery_size_by_name("AA", hole=true);
  // echo(aasize);
  aah=aasize[0]; // Room for battery and spring
  aad=aasize[1];

  // need ~6 between, and ~4 on each end. cutout from those is where the tabs go.
  hl= 4 + aah + 6 ;//+ aah + 4; //just half for now while sizing everything

  difference(){
    cube([hl,aad+wall_thickness*2,aad+wall_thickness*2]);

    // Cutout places for batteries
    translate([4, aad/2+wall_thickness, aad/2 + wall_thickness]) {
      rotate([0,90,0]) {
        union() {
          translate([-aad,-aad/2,0]) cube([aad,aad,aah]);
          AA(true);
        }
      }
    }
/* just half for now while sizing everything
    translate([4 + aah + 6, aad/2+wall_thickness, aad/2 + wall_thickness]) {
      rotate([0,90,0]) {
        union() {
          translate([-aad,-aad/2,0]) cube([aad,aad,aah]);
          AA(true);
        }
      }
    }
*/
    // Cutout places for tabs
    // The center of the main part of the tab should be at the center of the battery.
    // This should be a part.
    // gah. lining up the center of battery with the place it goes on the tabs…
    for(offset=[3.6, aah+4.4, aah+3.6+6, aah*2+6+4.4]) {
      // aad/2
      translate([offset, aad/2+wall_thickness, aad/2 + wall_thickness*2])
        rotate([180, 0, 0])
          battery_tab_cutout(center=true, vpin=false, extend=10);
      //   cube(size=[1, 5, 30], center=true);
      // translate([offset, aad/2+wall_thickness, 10.75])
      //   cube(size=[1, 11.5, aad], center=true);
    }
  }
}

battery_holding();
/*
remote = HexBugBattleBotRemote_size();
box = battery_holding_size() + [0, remote[1], 3];

use <MCAD/boxes.scad>

// TODO: Figure out how to route the wires.
// TODO: Figure out how to add metal contacts to LR44 stubs. (ring (or partial ring) and plate?)
difference() {
  translate([box[0]/2, box[1]/2, box[2]/2]) roundedBox(box, 5, true);
  translate([box[0]/2 - remote[0]/2, battery_holding_size()[1] + 1, box[2] - remote[2] + 1])
    HexBugBattleBotRemote();
  // translate([box[0]/2 - 15, box[1]/2, box[2]/2 - 3]) cube([30, 20, 10]);
  // %translate([0, 0, 0]) battery_holding();
}
*/
/* This is just a physical extension to make the controler bigger.
difference() {
  translate([box[0]/2, box[1]/2, box[2]/2]) roundedBox(box, 5, true);
  translate([box[0]/2 - remote[0]/2, battery_holding_size()[1] + 1, box[2] - remote[2] + 1])
    HexBugBattleBotRemote();
  translate([box[0]/2 - 15, box[1]/2, box[2]/2 - 3]) cube([30, 20, 10]);
}
*/


// vim: set ai et sw=2 ts=2 :
