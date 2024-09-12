class Map

  MAPS = [
    "maps/colider_area_01.tmx",
  ]

  def initialize(args)
    @args = args
    args.state.loaded_maps ||= {}
    init_map
    @generate_done = false
    @offset        = 0
    @tile_w        = 32
    @tile_h        = 32
  end

  def args
    @args
  end

  def height
    map.height.to_i
  end

  def width
    map.width.to_i
  end

  def map_name
    MAPS.first
  end

  def map
    args.state.loaded_maps[map_name]
  end

  def tilewidth
    map.tilewidth
  end

  def tileheight
    map.tileheight
  end

  def init_map
    if args.state.loaded_maps.empty?
      args.outputs.primitives << {
        x: 25,
        y: 720 - 25,
        text: "Loading maps, please wait..",
        size_enum: 4,
      }.label!

      map = Tiled::Map.new map_name
      map.load
      args.state.loaded_maps[map_name] = map
    end

  end

  def tick
    render_1 unless @generate_done
    render_2
  end

  def render_1
    puts "----------- start generate ------------"
    if map # = args.state.loaded_maps[map_name]
      target        = args.render_target(:accumulation)
      attributes    = map.attributes
      target.width  = attributes.width.to_i * attributes.tilewidth.to_i
      target.height = attributes.height.to_i * attributes.tileheight.to_i
      target.clear_before_render = false
      target.clear_before_render = false
      target.static_sprites << map.layers.map(&:sprites)
      puts "----------- generate_done ------------"
      puts attributes.width.to_i
      puts attributes.tilewidth.to_i
      @generate_done = true
      #
    end
  end

  #
  # render avec le meme décalage et zomme que le sprite
  #
  def render_2

    zoom   = 0.25
    zoom   = 0.5
    zoom   = 1

    # @offset + = 1
    @offset     = 0 if @offset > 1280
    x_offset    = 0
    y_offset    = 0
    width       = 20 * 32 / zoom
    height      = 16 * 20 / zoom
    args.outputs.sprites << { x:         0 - @offset,
                              y:         0 ,
                              w:         width * 1,
                              h:         height* 1,
                              path:      :accumulation,
                              source_x:  x_offset,
                              source_y:  y_offset,
                              source_w:  width,
                              source_h:  height }
  end

  ## TODO: this must be move on map module or dr_colider module
  #
  def draw_submap block_list, x, y
  end

  def tile_at(i, j)
    # NOTE why - 1 ?
    j = 10 - 1 - j
    map.layers.first.tile_at(i, j)
  end

  def draw_tile_at i, j, x, y
    tile = tile_at(i, j)
    draw_tile tile, x, y
  end

  # TODO remove magic number
  #
  def draw_tile tile, x, y
    args.outputs.sprites << { x: x, y: y, h: @tile_h, w: @tile_w,
                              tile_x: tile.tile_x ,
                              tile_y: tile.tile_y,
                              tile_w: @tile_w,
                              tile_h: @tile_h,
                              path:   tile.path }
    # load map
  end

end
