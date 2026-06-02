##
# TODO: doc
#
module DrColider
  include DrColiderDraw
  include DrColiderSubmap

  attr_accessor :current_colider_map,
    :c_tile_w,   :c_tile_h,
    :c_sm_min_x, :c_sm_min_y,
    :c_sm_max_x, :c_sm_max_y,
    :c_new_x,    :c_new_y,
    :c_dx,       :c_dy

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
    # Au moins une tuile, meme si la boite est plus petite qu'une tuile
    # (sinon submap vide -> collision jamais detectee). Cf. issue #5.
    @c_tile_w = [@w / @tile_w, 1].max
    @c_tile_h = [@h / @tile_h, 1].max
  end

  def c_set_position x = 0, y = 0
    @x = x
    @y = y
  end

  def c_set_delta dx = 0, dy = 0
    @c_dx = dx
    @c_dy = dy
  end

  def c_project_new_move
    @c_new_x = @x + @c_dx
    @c_new_y = @y + @c_dy
  end

  def c_project_new_move_with x: 0, y: 0, dx: 0, dy: 0
    @x    = x;  @y    = y
    @c_dx = dx; @c_dy = dy
    c_project_new_move
  end

  def colision_check
    # a = "x #{@x} new_x: #{@c_new_x}"
    # label_data a, 10, 14
    # if no_colision?
      # @x = @c_new_x
      # @y = @c_new_y
      # a = "x #{@x} new_x: #{@c_new_x} col no"
      # label_data a, 9, 14
    # else
      # a = "x #{@x} new_x: #{@c_new_x} col yes"
      # label_data a, 9, 14
      # @c_new_y =  @y + 0
      # @c_new_x =  @x + 0
    # end
    apply_colide
  end

  def no_colision?
    find_submap_points
    ids = submap_tiles.flatten.map &:id
    ids.all? { |id| id == 0 }
  end
end
