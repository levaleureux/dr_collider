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

  private

end
