#
# Manage scene
# it has kind of minimal state machine use
#
class SceneManager
  attr_gtk

  def initialize args
    args.state.current_scene = :title
    #puts args.state.current_scene
    puts "--------------------------"
    puts :scene_manager_initialized
  end

  def current_scene
    state.current_scene
  end

  def tick
    state.my_scenes[current_scene].tick
    guard
    # if next scene was set/requested,
    # then transition the current scene to the next scene
    if state.next_scene
      change_scene
      end_tick
    end
  end

  private

  def guard
    # capture the current scene to verify it didn't change through
    # the duration of tick
    #current_scene = state.current_scene
    if state.current_scene != current_scene
      raise [
        "Scene was changed incorrectly. ",
        "et args.state.next_scene to change scenes."].join
    end
  end

  def end_tick
    # on peut ici réinit ou pas c'est le purpose du manager
    # qui devrait etre remplacer par une state machine
    # avec des effets sur les transitions
    #
    puts "after current_scene"
    puts state.current_scene
    state.next_scene = nil
  end

  def change_scene
    puts "next_scene"
    puts (next_scene = args.state.next_scene)
    puts current_scene
    state.current_scene =  next_scene
    #
  end
end
