// For all, if hole is true, then make a suitable cutout for holding the battery *AND* space for springs and
// contacts to connect it.
//
// Review https://en.wikipedia.org/wiki/List_of_battery_sizes for missing sizes; add as needed.

// All of these are cylinders
batteries_by_name = [
  // Name, Height, Diameter, button-top
  ["AAAA", 42.5, 8.3, true],
  ["AAA", 44.5, 10.5, true],
  ["AA", 49.5, 14.5, true],
  ["A23", 28.5, 10.3, true],
  ["C", 50, 26.2, true],
  ["D", 61.5, 34.2, true],
  ["LR41", 3.6, 7.9, false],
  ["LR44", 5.4, 11, false],
  ["CR1130", 3, 11.5, false],
];

function battery_size_by_name(name="AA", hole=false) =
  let(found_idx=search([name], batteries_by_name),
      found=batteries_by_name[found_idx[0]],
      dia=found[2] + (hole?1:0),
      height=found[1] + (hole?3:0)
      )
      [height,dia];

module battery_by_name(name="AA", hole=false) {
  found_idx=search([name], batteries_by_name);
  found = batteries_by_name[found_idx[0]];
  if (hole) {
    // if button type, assume that it will get held by a wire spring, so 1 for button, 2 for spring.
    // if not button, assume sheet metal spring, so 1.
    cylinder(h=found[1] + (found[3]?3:1), d=found[2] + 1);

  }else {
    cylinder(h=found[1], d=found[2]);
    if (found[3]) {
      // !!!! There is no standard sizing of the button, so we'll use a single size for now.
      translate([0, 0, found[1]])
        cylinder(d=5.5, h=1);
    }
  }
}


module AAA(hole=false) {
  battery_by_name(parent_module(1), hole);
}
module AA(hole=false) {
  battery_by_name(parent_module(1), hole);
}
module C(hole=false) {
  battery_by_name(parent_module(1), hole);
}
module LR44(hole=false) {
  battery_by_name(parent_module(1), hole);
}
