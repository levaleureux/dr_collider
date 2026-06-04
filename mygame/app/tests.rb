# Runner de tests dr_spec pour dr_colider.
# Usage: $DRAGONRUBY_BIN mygame --eval app/tests.rb --no-tick --exit-on-fail
#
# Ordre : framework dr_spec -> modules de collision -> fixtures -> specs.
# Les mixins se composent a la definition (dr_colider.rb fait `include
# DrColiderDraw/Submap`), donc charger draw et submap AVANT dr_colider.

require "lib/dr_spec/dragon_specs.rb"

# DrColiderDraw est du RENDU pur (args.outputs, draw_tile, label_data) :
# non testable unitairement hors runtime. On le charge AVANT d'activer la
# couverture pour qu'il soit defini sans etre instrumente -> la couverture
# mesure la seule LOGIQUE (center, submap, core), seuil 90 % credible.
require "lib/dr_colider/dr_colider_draw.rb"

# Couverture de code : instrumente lib/dr_colider/ (notre bibliotheque de
# logique). Doit preceder le require des modules suivis.
DrSpec::Coverage.start "lib/dr_colider/"

require "lib/dr_colider/dr_colider_submap.rb"
require "lib/dr_colider/dr_colider_center.rb"
require "lib/dr_colider/dr_colider.rb"

require "spec/support/collider_fixtures.rb"

# NB : require_specs (#50) ne fonctionne pas en layout mygame/ — il fait
# `$gtk.exec("ls spec")` dans le cwd du process (racine du depot), alors que
# les specs sont sous mygame/spec. On garde donc les require explicites.
require "spec/dr_colider_center_spec.rb"
require "spec/dr_colider_core_spec.rb"
require "spec/dr_colider_submap_spec.rb"
require "spec/dr_colider_draw_spec.rb"
require "spec/dr_colider_draw_rect_spec.rb"

run_specs
