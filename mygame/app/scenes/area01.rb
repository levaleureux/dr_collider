class Area01Scene < Scene
  attr_gtk
  #attr_sprite
  #attr_accessor :name
  NAME = :title

  def initialize args
    self.args = args
    @sprite   = MySprite.new args
    @map      = Map.new args
    @sprite.set_colision_map @map
    @sprite.dr_colider_init
  end

  def reset
  end

  def tick
    args.outputs.labels << args.layout.rect(row: 3, col: 14)
      .merge(text: "You are on scene #{NAME}",
             vertical_alignment_enum: 0, alignment_enum: 0,
             size_enum: 3)
    @map.tick
    @sprite.tick
    @sprite.find_submap_points
    x = @sprite.c_sm_min_x
    y = @sprite.c_sm_min_y
    #
    args.outputs.labels << args.layout.rect(row: 4, col: 14)
      .merge(text: "x #{x} y #{y}",
             vertical_alignment_enum: 0, alignment_enum: 0,
             size_enum: 3)
    #
    @sprite.draw_submap_points
    @sprite.draw_submap
    # TODO
    args.outputs.labels << args.layout.rect(row: 2, col: 14)
      .merge(text: "i #{x.to_i} j #{y.to_i}: #{10 - y.to_i - 1}",
             vertical_alignment_enum: 0, alignment_enum: 0,
             size_enum: 3)
    #
    # @submap = @sprite.block_on_target_position
    if @blocks_find
      @blocks_find = false
      # ici les one call shoot
    end
    if args.inputs.keyboard.key_down.a
      @blocks_find = true
    end
    #
    @sprite.draw_debug_mode
  end

  private
end
