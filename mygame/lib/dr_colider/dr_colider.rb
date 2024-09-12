##
# TODO: doc
#
module DrColider
  include DrColiderDraw
  include DrColiderSubmap

  attr_accessor :current_colider_map,
    :c_tile_w,   :c_tile_h,
    :c_sm_min_x, :c_sm_min_y,
    :c_sm_max_x, :c_sm_max_y

  def colidable?
    true
  end

  # Map is a 2 array with mandatory methods
  #
  def set_colision_map map
    @current_colider_map = map
  end

  def dr_colider_init
    @tile_w   = @current_colider_map.tilewidth.to_i
    @tile_h   = @current_colider_map.tileheight.to_i
    @c_tile_w = @w / @tile_w # TODO 1 if 0
    @c_tile_h = @h / @tile_h
    puts "tile_w______________________"
    puts @tile_w.to_s
    puts @w
    puts "______________________"
  end

end
