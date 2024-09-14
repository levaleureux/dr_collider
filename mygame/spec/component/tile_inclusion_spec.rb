focus_spec :tile_inclusion do

  it "can be used as a module in a parent class" do |args, assert|
    sprite = MySprite.new args
    expect(sprite.colidable?).to be_truthy
  end

  it "find the tile of a sprite corner" do |args, assert|
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
