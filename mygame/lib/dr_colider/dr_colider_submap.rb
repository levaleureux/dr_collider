#
# see DrColiderDraw for drawing info on screen
# or puts info
#
module DrColiderSubmap
  def find_submap_points
    @c_sm_min_x = @x / @tile_w
    @c_sm_min_y = @y / @tile_h
    @c_sm_max_x = @c_sm_min_x + @c_tile_w
    @c_sm_max_y = @c_sm_min_y + @c_tile_h
  end

  def draw_submap_points
    draw_rect @c_sm_min_x.floor * 32, @c_sm_min_y.floor * 32, 2 *32
  end

  def block_on_target_position
    return [] unless @current_colider_map

    blocks    = []
    start_row = (@y / @tile_h).floor
    end_row   = ((@y + @h) / @tile_h).floor
    start_col = (@x / @tile_w).floor
    end_col   = ((@x + @w) / @tile_w).floor
    #
    #
    (start_row..end_row).each do |row|
      (start_col..end_col).each do |col|
        # if @current_colider_map[row] && @current_colider_map[row][col]
        blocks << @current_colider_map.map.layers.first.tile_at(row, col)
        # end
      end
    end

    blocks
  end
end
