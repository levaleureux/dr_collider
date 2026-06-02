# Specs du coeur de DrColider : initialisation des dimensions de tuiles,
# positionnement, projection du deplacement et detection d'absence de
# collision sur la submap.
#
# Memes conventions que dr_colider_center_spec : doublures via `let`, hote
# pret a l'emploi via build_collider_host.

spec :dr_colider_core do
  # Carte 3x3 en tuiles de 32 px, vide par defaut.
  let(:map)  { FakeMap.new(tilewidth: 32, tileheight: 32) }
  let(:host) { build_collider_host(map: map, w: 32, h: 32) }

  context "colidable?" do
    specify "un hote muni du mixin est colidable" do
      expect(host.colidable?).to eq true
    end
  end

  context "dr_colider_init : dimensions en tuiles" do
    specify "une boite carree couvre une tuile dans chaque sens" do
      # boite 32x32, tuiles 32 -> 32 / 32 = 1 tuile en largeur comme en hauteur
      expect(host.c_tile_w).to eq 1
      expect(host.c_tile_h).to eq 1
    end

    specify "une boite non carree couvre le nombre de tuiles attendu" do
      wide = build_collider_host(map: map, w: 64, h: 32)
      # largeur : 64 / 32 = 2 tuiles ; hauteur : 32 / 32 = 1 tuile
      expect(wide.c_tile_w).to eq 2
      expect(wide.c_tile_h).to eq 1
    end
  end

  context "c_set_position" do
    specify "fixe les coordonnees du coin de la boite" do
      host.c_set_position(96, 128)
      expect(host.x).to eq 96
      expect(host.y).to eq 128
    end
  end

  context "c_set_delta puis c_project_new_move" do
    specify "projette la nouvelle position comme position + delta" do
      host.c_set_position(32, 64)
      host.c_set_delta(8, -16)
      host.c_project_new_move
      expect(host.c_new_x).to eq 40        # 32 + 8
      expect(host.c_new_y).to eq 48        # 64 + (-16)
    end
  end

  context "c_project_new_move_with" do
    specify "fixe position et delta puis projette en une seule fois" do
      host.c_project_new_move_with(x: 10, y: 20, dx: 5, dy: 7)
      expect(host.x).to eq 10
      expect(host.y).to eq 20
      expect(host.c_new_x).to eq 15        # 10 + 5
      expect(host.c_new_y).to eq 27        # 20 + 7
    end
  end

  context "no_colision?" do
    # find_submap_points calcule les bornes @c_sm_min/max lues par no_colision?
    # via submap_tiles ; il faut donc projeter, puis appeler find_submap_points,
    # avant d'interroger no_colision?.

    specify "sur une carte vide, aucune collision n'est detectee" do
      host.c_project_new_move_with(x: 0, y: 0, dx: 0, dy: 0)
      host.find_submap_points
      expect(host.no_colision?).to eq true
    end

    specify "un bloc plein dans la submap signale une collision" do
      blocked_map = FakeMap.new(tilewidth: 32, tileheight: 32, tiles: { [1, 1] => 1 })
      blocked     = build_collider_host(map: blocked_map, w: 32, h: 32)
      # cible la tuile (1,1) : 32 / 32 = 1 en x comme en y
      blocked.c_project_new_move_with(x: 32, y: 32, dx: 0, dy: 0)
      blocked.find_submap_points
      expect(blocked.no_colision?).to eq false
    end
  end
end
