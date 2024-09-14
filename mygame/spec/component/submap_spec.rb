spec :colider_inculison do
  it "can be used as a module in a parent class" do |args, assert|
    sprite = MySprite.new args
    expect(sprite.colidable?).to be_truthy
  end

  it "has a map" do |args, assert|
    sprite = MySprite.new args
    map  = Map.new  args, 0 , 0 , 100, 100
    sprite.set_colision_map map
    # puts map.tiles
    expect(sprite.current_colider_map.tiles).to eq map.tiles
  end
  xit "can find a submap" do |args, assert|
    # find min a and max b points
    # extract blocks as a subarray
    # for performance subarray size
    # can be define at the begining ?
    sprite = MySprite.new args

    # Dimensions de la sous-carte que le sprite va rechercher
    w, h = 10, 10

    # Initialisation de la carte principale avec des dimensions et des tuiles
    map = Map.new args, 0, 0, 100, 100
    sprite.set_colision_map map

    # Définir la position du sprite, pour cet exemple on suppose qu'il est à (10, 10)
    sprite_x, sprite_y = 10, 10

    # Points (a) et (b) définissant les limites de la sous-carte
    min_x, min_y = sprite_x, sprite_y
    max_x, max_y = sprite_x + w - 1, sprite_y + h - 1

    # Extraire la sous-carte
    submap = map.tiles[min_y..max_y].map { |row| row[min_x..max_x] }

    # Définir ce que l'on attend comme sous-carte (par exemple, une matrice 10x10)
    expected_submap = Array.new(h) { Array.new(w) { |i| i } }

    # Assertion pour vérifier que la sous-carte extraite est correcte
    assert.equal!(submap, expected_submap)
  end
end

spec '#dr_colider_init' do

  # TODO with another sprite size
  #
  it 'initializes tile dimensions correctly with defaults' do |args, assert|
    sprite = MySprite.new args
    sprite.x = 0
    sprite.y = 0
    sprite.c_new_x = 0
    sprite.c_new_y = 0
    map = Map.new args # , 0, 0, 100, 100
    map.init_map
    sprite.set_colision_map map
    sprite.dr_colider_init
    #
    expect(sprite.tile_w  ).to eq(32)
    expect(sprite.tile_h  ).to eq(32)
    expect(sprite.c_tile_w).to eq(1) # 32 / 16 = 2
    expect(sprite.c_tile_h).to eq(1) # 32 / 16 = 2
    #
    puts sprite.find_submap_points
    #
    expect(sprite.c_sm_min_x).to eq 0
    expect(sprite.c_sm_min_y).to eq 0

    expect(sprite.c_sm_max_x).to eq 1
    expect(sprite.c_sm_max_y).to eq 1
  end

end
