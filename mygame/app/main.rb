$gtk.console.font_style = GTK::Console::FontStyle.new(
  font: 'font.ttf', size_enum: 3, line_height: 1.1)

require 'lib/tiled/tiled.rb'
require "app/component/map.rb"

require "app/component/game.rb"
#
require "lib/dr_colider/dr_colider_draw.rb"
require "lib/dr_colider/dr_colider_submap.rb"
require "lib/dr_colider/dr_colider_center.rb"
require "lib/dr_colider/dr_colider.rb"
require "app/component/c_sprite.rb"
require "app/component/my_sprite.rb"
require "app/component/my_sprite_center.rb"

require "app/scene.rb"

def tick args
  args.state.game ||= Game.new args
  args.state.game.tick
end
