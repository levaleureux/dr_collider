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

  def submap_id
    [[
      @current_colider_map
      .tile_at(@x.to_i / @tile_w, @y.to_i / @tile_h).id
    ]]
  end

  # TODO: center_x and center_new_x
  #
  def target_submap_id
    [[
      @current_colider_map
      .tile_at((@c_new_x.to_i + @tile_w.to_i / 2) / @tile_w,
               (@c_new_y.to_i + @tile_h.to_i / 2) / @tile_h).id
    ]]
  end

  def apply_colide
    id = target_submap_id[0][0]
    if id == 1
      process_colide_with_full_block
    else
      process_colide_with_empty
    end
  end

  def process_colide_with_full_block
    # puts "full_block ___________".blue
    @c_new_x = @x
    @c_new_y = @y
  end

  def process_colide_with_empty
    @x = @c_new_x
    @y = @c_new_y
    # puts "empty _________".blue
  end

end
