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

  it "une routine de colision à des effet" do |args, assert|
    # la fonction prend le submap_id et le delta et autre context
    @sprite.c_project_new_move_with \
      x:  5,  y: 10,
      dx: 7, dy: 20
    @sprite.apply_colide
    expect(@sprite.c_new_x).to eq 12
    expect(@sprite.c_new_y).to eq 30
    # si dans le vide
    # expect a bougé
    #
    # si dans un mur pousser au bord du mur
    # pour x
    # pour y
    #
  end
end
