# Specs du coeur de DrColider : initialisation des dimensions de tuiles,
# positionnement, projection du deplacement et detection d'absence de
# collision sur la submap.
#
# Mise en place entierement decrite par des `let` granulaires (tile, blocks,
# w, h, map, host). Les contextes imbriques SURCHARGENT ces `let` (boite large,
# boite minuscule, carte avec bloc) : le `let(:host)` se reconstruit alors
# automatiquement a partir des valeurs surchargees.

spec :dr_colider_core do
  let(:tile)   { 32 }
  let(:blocks) { {} }                  # carte vide par defaut
  let(:w)      { 32 }
  let(:h)      { 32 }
  let(:map)    { FakeMap.new(tilewidth: tile, tileheight: tile, tiles: blocks) }
  let(:host)   { build_collider_host(map: map, w: w, h: h) }

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

    context "boite non carree (large)" do
      let(:w) { 64 }                   # surcharge : 64 / 32 = 2 tuiles
      specify "couvre deux tuiles en largeur, une en hauteur" do
        expect(host.c_tile_w).to eq 2
        expect(host.c_tile_h).to eq 1
      end
    end

    context "boite plus petite qu'une tuile" do
      let(:w) { 16 }                   # surcharge : 16 / 32 < 1
      let(:h) { 16 }
      specify "couvre au moins une tuile (garde anti-zero, #5)" do
        expect(host.c_tile_w).to be_greater_than_or_equal_to 1
        expect(host.c_tile_h).to be_greater_than_or_equal_to 1
      end
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
    # Depuis le correctif #3, no_colision? amorce elle-meme ses bornes
    # (find_submap_points) : plus aucun pre-appel n'est requis.

    specify "sur une carte vide, aucune collision n'est detectee" do
      host.c_project_new_move_with(x: 0, y: 0, dx: 0, dy: 0)
      expect(host.no_colision?).to eq true
    end

    specify "amorce elle-meme les bornes, sans pre-appel a find_submap_points" do
      # On interroge DIRECTEMENT no_colision? apres projection : la methode
      # doit poser ses propres bornes @c_sm_* (sinon submap_tiles lit nil).
      host.c_project_new_move_with(x: 0, y: 0, dx: 0, dy: 0)
      expect(host.no_colision?).to eq true
    end

    context "un bloc plein dans la submap" do
      let(:blocks) { { [1, 1] => 1 } }   # surcharge : bloc plein en (1,1)
      specify "signale une collision" do
        # cible la tuile (1,1) : 32 / 32 = 1 en x comme en y
        host.c_project_new_move_with(x: 32, y: 32, dx: 0, dy: 0)
        expect(host.no_colision?).to eq false
      end
    end
  end
end
