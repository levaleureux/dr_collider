focus_spec :tile_inclusion do
  #
  before do |args, assert|
    @sprite   = MySpriteCenter.new args
    @w        = 32
    @map      = Map.new args
    @map.init_map
    @sprite.set_colision_map @map
    @sprite.dr_colider_init
  end

  it "can be used as a module in a parent class" do |args, assert|
    sprite = MySpriteCenter.new args
    expect(sprite.colidable?).to be_truthy
  end

  # NOTE: On this type of colistion sprite size din't matter
  # But it's better to provide a sprite:
  # smaller or equal to the sprite of a tile
  #
  it "find a sprite center" do |args, assert|
    @sprite.x = @w
    @sprite.y = @w * 2
    #
    expect(@sprite.tile_w).to eq(@w)
    expect(@sprite.tile_h).to eq(@w)
    expect(@sprite.c_center_x).to eq(48)
    expect(@sprite.c_center_y).to eq(64 + 16) # 80
    #
    @sprite.x = 0
    @sprite.y = 0
    expect(@sprite.c_center_x).to eq(16)
    expect(@sprite.c_center_y).to eq(16)
    #
  end

  # it "find the tile of a sprite center" do |args, assert|
  it "find the tile of a sprite corner (4 corners sprite)" do |args, assert|
    # todo il faudra faire des points intermediare
    # on set un sprite
    # on choisi un corner
    # on expect que x,y
  end

  it "on à une routine de colision pour un tile et un point et un context" do |args, assert|
    # todo il faudra faire des points intermediare
    # on set un sprite
    # on a un corner tile
    # et un delta
    # et on on aurrai un context
    # on à une selecteur de routine
  end

  it "une routine de colision à des effet" do |args, assert|
    # pour plus de testabilité
    # c'est une fonction avec un context d'entrès et de sortie
    # et il y aura un seteur de context
  end
end
