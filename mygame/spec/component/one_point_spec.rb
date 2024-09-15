#
# If you want a very simple collider system
# the module collider_one_point
#
focus_spec :one_point do
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
  end

  it "find tile id submap" do |args, assert|
    @sprite.x = @w
    @sprite.y = @w * 2
    expect(@sprite.submap_id).to eq([[0]])
    # on colidable block
    @sprite.x = 0
    @sprite.y = 0
    expect(@sprite.submap_id).to eq([[1]])
  end

  ## TODO use a int map
  # in orther to make the spec more readable
  #
  xit "can move sprite in emty block" do |args, assert|
    # x y start in empty block
    @sprite.c_project_new_move_with \
      x:  34,  y: 35,
      dx: 5, dy: 5
    @sprite.apply_colide
    expect(@sprite.c_new_x).to eq 39
    expect(@sprite.c_new_y).to eq 40
  end

  ## TODO use a int map
  # in orther to make the spec more readable
  #
  it "can move sprite in emty block" do |args, assert|
    # x y start in empty block
    @sprite.c_project_new_move_with \
      x:  34,  y: 35,
      dx: 0,  dy: -16
    @sprite.apply_colide
    expect(@sprite.c_new_x).to eq 34
    expect(@sprite.c_new_y).to eq 35
  end
end
