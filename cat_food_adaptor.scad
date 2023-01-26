// Cat Food Adaptor

echo(version=version());
// Values are in millimeters

$fs=0.5;
extruder_width = 0.4;
// wall_thickness = (2*extruder_width)*2;
wall_thickness = (4*extruder_width);


// Female connection to splitter output

// Need not a cube; 
/*
  Basically this:
    +---------+
    |          \
    |           \
    +------------+
*/

// This makes the right side one.
module inside_lip() {
  hull() { // I likely need to rearrange the points in each face, but wrapping in hull also works…
  // FIXME: stop hull here.
    polyhedron(points=[
      [0,0,0],    // 0
      [36,0,0],   // 1
      [36,30,0],  // 2
      [0,30,0],   // 3
      [0,0,30],   // 4
      [40,0,30],  // 5
      [40,30,30], // 6
      [2,30,30],  // 7
    ], faces=[
      [0,1,2,3],  // top
      [0,1,5,4],  // front
      [0,4,7,3],  // left
      [1,2,6,5], // right
      [2,3,7,6], // back
      [4,5,6,7],  // bottom
    ]);
  }
}

module shoot_collar(wall=wall_thickness) {
  difference() {
    // gonna try resize, otherwise will need another polyhedron.
    resize(newsize=[40+wall*2,30+wall*2,30+wall*2]) inside_lip();
    translate([wall, wall, wall]) {
      inside_lip();
    }
    translate([wall, wall, -0.25]) {
      cube([36,30, wall+0.5]);
    }
    translate([wall, wall, 30+wall-0.25]) {
      linear_extrude(height=wall+1) {
        polygon(points=[
          [0,0],   // 4
          [40,0],  // 5
          [40,30], // 6
          [2,30],  // 7
        ]);
      }
    }
  }
}

module shoot_extention(wall=wall_thickness, h=5) {
  difference() {
    cube([36 + wall*2, 30 + wall*2, h]);
    translate([wall, wall, -0.25]) {
      cube([36, 30, h+wall]);
    }
  }
}

module from_shoot_to_pipe_inside(wall=wall_thickness) {
  outside=38.1;
  inside=34.7;
  // wall=1.76;
  hull() {
    linear_extrude(height=0.1) {
      polygon(points=[
          [0,0],    // 0
          [36,0],   // 1
          [36,30],  // 2
          [0,30],   // 3
      ]);
    }
    rotate([10, 0, 0]) {
      translate([36/2, 30/2 +2, -11]) {
        cylinder(d=inside-wall*2, h=4);
      }
    }
  }
  rotate([10, 0, 0]) {
    translate([36/2, 30/2 +2, -20]) {
      cylinder(d=inside-wall*2, h=10);
    }
  }
}
module from_shoot_to_pipe_outside(wall=wall_thickness) {
  outside=38.1;
  inside=34.7;
  // wall=1.76;
  px=36+wall*2;
  py=30+wall*2;
  hull() {
    linear_extrude(height=0.1) {
      polygon(points=[
          [0,0],    // 0
          [px,0],   // 1
          [px,py],  // 2
          [0,py],   // 3
      ]);
    }
    rotate([10, 0, 0]) {
      translate([px/2, py/2 +2, -11]) {
        cylinder(d=inside, h=4);
      }
    }
  }
  rotate([10, 0, 0]) {
    translate([px/2, py/2 +2, -20]) {
      cylinder(d=inside, h=10);
    }
  }
}
module from_shoot_to_pipe(wall=wall_thickness) {
  // TODO: clean this up into a single module?
  difference() {
    from_shoot_to_pipe_outside(wall);
    translate([wall, wall, 0]) {
      from_shoot_to_pipe_inside(wall);
    }
  }
}

module bend(wall=wall_thickness, width=36, height=30) {
  // each side should be height, angle is 60º, so…
  side=height + wall*2;
  mid_h=sin(60) * side;
  difference() {
    linear_extrude(height=width+wall*2) {
      polygon(points=[[0,0],[mid_h,side/2],[0,side]]);
    }
    translate([wall, 0, wall]) {
      cube([side, side, width]);
    }
  }
}

// So maybe it would work out better to not go pipe until after the bend.  And do the bend bit as a drop
// TODO: Remember to mirror() to fit on left side of splitter.

module cat_food_adaptor_right() {
  panel_extention=6.35; // ¼in

  translate([0,-wall_thickness,0]) {
    shoot_collar();
  }
  translate([0, 0, -panel_extention]) {
    translate([0,-wall_thickness, 0]) {
      shoot_extention(h=6.35);
    }
    rotate([300, 0, 0]) {
      translate([0, -wall_thickness, 0]) {
        from_shoot_to_pipe();
      }
    }
    translate([0, 30+wall_thickness, 0.2]) {
      rotate([0, 90, 0]) {
        rotate([0, 0, -120]) {
          bend();
        }
      }
    }
  }
}

// cat_food_adaptor_right();

mirror([1, 0, 0]) {
  cat_food_adaptor_right();
}



