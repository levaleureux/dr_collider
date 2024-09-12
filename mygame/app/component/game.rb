class Game
  attr_gtk

  # TODO move scene in scene manager
  def initialize args
    self.args      = args
    @scene_manager = SceneManager.new args
    #@scene_title  = Scene::Title.new args
    #@scene_sample = Scene::Sample.new args
    @scene_area_01 = Area01Scene.new args
    # TODO sound scene
    # @scenes = [@scene_title, @scene_sample]
    @scenes = [@scene_area_01]
    post_init
    puts "initialized game"
  end

  #
  # TODO use state directly
  #
  def tick
    # state.my_scenes[state.current_scene].tick
    @scene_manager.tick
    # TODO inputs directly ?
    if args.inputs.keyboard.key_down.escape
      # TODO $gtk
      args.gtk.request_quit
    end
    keyboard_check
  end

  def keyboard_check
    #
    if args.inputs.keyboard.key_down.escape
      args.gtk.request_quit
    end
    # if args.inputs.keyboard.key_down.z
      # args.state.ball_speed = 0
    # end
    # if args.inputs.keyboard.key_down.up
      # args.state.ball_speed = 0.25
    # end
    # if args.inputs.keyboard.key_down.down
      # args.state.ball_speed = 0.5
    # end
    # if args.inputs.keyboard.key_down.h
      # args.state.ball_speed = 1
    # end
  end

  private

  def post_init
    @scene_manager.args = args
    state.my_scenes = {}
    post_init_scenes

    state.post_init = true
  end

  def post_init_scenes
    @scenes.each do |scene|
      scene.args = args
      scene.add_to_scenes
    end
  end

end
