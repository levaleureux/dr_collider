#
#
#
module DrColiderDraw

  def draw_rect x, y, w, h = 0
    h = w if h = 0
    a = [x , y]
    b = [x + w, y]
    a = [x , y]
    b = [x + w, y]
    args.outputs.lines << [a[0], a[1],     b[0], b[1]    ]
    args.outputs.lines << [a[0], a[1],     a[0], a[1] + w]
    args.outputs.lines << [a[0], a[1] + w, b[0], b[1] + w]
    args.outputs.lines << [b[0], b[1],     b[0], b[1] + w]
  end

  def puts_map
    map = @current_colider_map
    puts map.map.attributes
    puts map.tile_at 0, 0
    puts map.tile_at 1, 1
    puts map.width.to_s.blue
    map.height.times do |j|
      row = []
      map.width.times do |i|
        row << map.tile_at(i, j).id
      end
      puts row
    end
  end

  ## TODO: must be call in a double loop
  # offset as params
  #
  def draw_submap x_offset = 800, y_offset = 200
    # x   = @c_sm_min_x
    # y   = @c_sm_min_y
    map = @current_colider_map
    # map.draw_tile_at x.to_i,     y.to_i,     x_offset,      y_offset
    # map.draw_tile_at x.to_i + 1, y.to_i,     x_offset + 32, y_offset
    # map.draw_tile_at x.to_i,     y.to_i + 1, x_offset,      y_offset + 32
    # map.draw_tile_at x.to_i + 1, y.to_i + 1, x_offset + 32, y_offset + 32

    submap_tiles.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        map.draw_tile tile, x_offset + i * @tile_w, y_offset + @tile_h
      end
    end
  end

  def parse_map data
    (data[:start_x]..data[:end_x]).each do |i|
      (data[:start_y]..data[:end_y]).each do |j|
        yield(data, i, j)
      end
    end
  end

  # show tile index as an overlay
  #
  def display_tiles data
    parse_map data do |data, i, j|
      map  = data[:map]
      tile = map.layers.first.tile_at(i, j).id
      args.outputs.labels << {
        text:     tile,
        x:        i * 32 + 8 + data[:offset_x],
        y:        y_reverse(j) * 32 + 32 + data[:offset_y],
        size_px:  14
      }
    end
  end

  def y_reverse y
    @current_colider_map.height - y - 1
  end

  # show tile coordonate x,y as an overlay
  #
  def display_coordinates data
    parse_map data do |data, i, j|
      map  = data[:map]
      args.outputs.labels << {
        text:     "#{i},#{j}",
        x:        i * 32 + 8 + data[:offset_x],
        # y:        y_reverse(j) * 32 + 16 + data[:offset_y],
        y:        j * 32 + 16 + data[:offset_y],
        size_px:  12
      }
    end
  end

  def draw_debug_map data
    map  = @current_colider_map.map
    data = data.merge map: map
    display_tiles data
    display_coordinates data
  end

  def label_data text, row, col
    args.outputs.labels << args.layout.rect(row: row, col: col)
      .merge(text: text,
             vertical_alignment_enum: 0, alignment_enum: 0,
             size_enum: 2)
  end

  def draw_debug_mode
    a = "start_x: #{@c_sm_min_x}, end_x: #{@c_sm_max_x}"
    label_data a, 5, 14
    b = "start_y: #{y_reverse @c_sm_min_y.to_i}, end_y: #{y_reverse @c_sm_max_y.to_i}"
    label_data b, 6, 14
    draw_debug_map \
      start_x:  0, end_x:    @current_colider_map.width - 1,
      start_y:  0, end_y:    y_reverse(0),
      offset_x: 0, offset_y: 0
    #
    # TODO: extract method and add params
    start_x = @c_sm_min_x.to_i
    start_y = y_reverse(@c_sm_min_y.to_i) - 1
    end_y   = start_y + 1
    draw_debug_map \
      start_x:  @c_sm_min_x.to_i,    end_x:    @c_sm_max_x.to_i,
      start_y:  start_y,             end_y:    end_y,
      offset_x: (25 - start_x) * 32, offset_y: (start_y -2) * 32 + 5

  end
end
