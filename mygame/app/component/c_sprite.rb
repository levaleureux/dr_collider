class CSprite
  include DrColider

  attr_gtk
  attr_sprite

  def initialize args
    self.args = args
    @x = 100
    @y = 300
    @pic  = "sprites/perso_grand.png"
    @w = 32
    @h = 32
    #pos = {x: state.player.x,
    #       y: state.player.y,
    #       flip_horizontally: true,
    #       w:87,
    #       h:174}
    @path  = "sprites/square/red.png"
    #pos = {x: state.player.x,
    #       y: state.player.y,
    #       flip_horizontally: false,
    #       w:32,
    #       h:32}
  end

  def draw_data
    { x: @x, y: @y, w: @w, h: @h, path: @path}
  end

  def tick
    @w = 32
    @h = 32
    # outputs.sprites << self#.merge({ path: @pic })
    outputs.sprites << { x: @x, y: @y, w: @w, h: @h, path: @path}
    keyboard_check
  end

  def keyboard_check
    if args.inputs.keyboard.key_down.left
      @x -= 8
    end
    if args.inputs.keyboard.key_down.up
      @y += 8
    end
    if args.inputs.keyboard.key_down.down
      @y -= 8
    end
    if args.inputs.keyboard.key_down.right
      @x += 8
    end
  end
end
