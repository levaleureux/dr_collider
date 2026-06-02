# Runner de tests dr_spec pour dr_colider.
# Usage: $DRAGONRUBY_BIN . --eval app/tests.rb --no-tick --exit-on-fail
#
# Ordre : framework dr_spec -> modules de collision -> fixtures -> specs.
# Les mixins se composent a la definition (dr_colider.rb fait `include
# DrColiderDraw/Submap`), donc charger draw et submap AVANT dr_colider.

require "lib/dr_spec/dragon_specs.rb"

require "lib/dr_colider/dr_colider_draw.rb"
require "lib/dr_colider/dr_colider_submap.rb"
require "lib/dr_colider/dr_colider_center.rb"
require "lib/dr_colider/dr_colider.rb"

require "spec/support/collider_fixtures.rb"

require "spec/dr_colider_center_spec.rb"
require "spec/dr_colider_core_spec.rb"
require "spec/dr_colider_submap_spec.rb"
require "spec/dr_colider_draw_spec.rb"

run_specs
