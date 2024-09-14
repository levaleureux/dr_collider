#
# see DrColiderDraw for drawing info on screen
# or puts info
#
module DrColiderCenter

  def c_center_x
    @x + @tile_w.to_i / 2
  end

  def c_center_y
    @y + @tile_h.to_i / 2
  end

  # TODO
  #
  def submap_id
    [[
      @current_colider_map
      .tile_at(@x / @tile_w, @y / @tile_h).id
    ]]
  end

  private

end
