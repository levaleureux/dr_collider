focus_spec :c_sprite do

  before do |args, assert|
    @sprite = MySprite.new args
  end

  it "set_position" do |args, assert|
    @sprite.c_set_position
    expect(@sprite.x).to eq 0
    expect(@sprite.y).to eq(0)
    @sprite.c_set_position 25, 37
    expect(@sprite.x).to eq(25)
    expect(@sprite.y).to eq(37)
  end

  it "set_delta" do |args, assert|
    @sprite.c_set_delta 0, 0
    expect(@sprite.c_dx).to eq 0
    expect(@sprite.c_dy).to eq 0
    @sprite.c_set_delta 33, 11
    expect(@sprite.c_dx).to eq 33
    expect(@sprite.c_dy).to eq 11
  end

  it "propose new position" do |args, assert|
    @sprite.c_set_position
    @sprite.c_set_delta 10, 10
    @sprite.c_project_new_move
    expect(@sprite.c_new_x).to eq 10
    expect(@sprite.c_new_y).to eq 10
    #
    @sprite.c_set_position 5, 10
    @sprite.c_set_delta 7, 20
    @sprite.c_project_new_move
    expect(@sprite.c_new_x).to eq 12
    expect(@sprite.c_new_y).to eq 30
  end

  # this one is usefull for test
  #
  it "propose new position with" do |args, assert|
    @sprite.c_project_new_move_with \
      x:  5,  y: 10,
      dx: 7, dy: 20
    expect(@sprite.c_new_x).to eq 12
    expect(@sprite.c_new_y).to eq 30
  end

end
