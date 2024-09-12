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

  # TODO: use named_params
  #
  def draw_submap_points
    draw_rect @c_sm_min_x.floor * @tile_w,
      @c_sm_min_y.floor * @tile_h,
      (@c_tile_w + 1) * @tile_w,
      (@c_tile_h + 1) * @tile_h
    # h as 4th params because w and h can be different
  end

  def submap_tiles
    result    = []
    start_row = @c_sm_min_x.floor
    end_row   = @c_sm_min_y.floor
    start_col = @c_sm_max_x.floor
    end_col   = @c_sm_max_y.floor
    #
    # TODO: refactor using ruby inject
    # this method will be a 5 lines one
    #
    (start_row..end_row).each do |row|
      row_blocks = []
      (start_col..end_col).each do |col|
        row_blocks << @current_colider_map.tile_at(row, col)
      end
      result << row_blocks
    end
    result
  end

  private

end
