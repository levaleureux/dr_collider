# Specs de DrColiderCenter : centre de la boite, tuile occupee, resolution de
# collision « au centre » (un seul point teste : le centre de la cible).
#
# Mise en place via `let` granulaires (tile, blocks, w, h, map, host).

spec :dr_colider_center do
  let(:tile)   { 32 }
  let(:blocks) { { [1, 1] => 1 } }     # un seul bloc plein en (1,1)
  let(:w)      { 32 }
  let(:h)      { 32 }
  let(:map)    { FakeMap.new(tilewidth: tile, tileheight: tile, tiles: blocks) }
  let(:host)   { build_collider_host(map: map, w: w, h: h) }

  context "centre de la boite" do
    specify "le centre vaut le coin + une demi-tuile" do
      host.c_set_position(32, 64)
      expect(host.c_center_x).to eq 48        # 32 + 16
      expect(host.c_center_y).to eq 80        # 64 + 16
    end

    specify "a l'origine, le centre est une demi-tuile" do
      host.c_set_position(0, 0)
      expect(host.c_center_x).to eq 16
      expect(host.c_center_y).to eq 16
    end
  end

  context "tuile occupee par le coin courant" do
    specify "renvoie l'id de la tuile sous (x, y)" do
      host.c_set_position(32, 32)             # tuile (1,1) -> plein
      expect(host.submap_id).to eq [[1]]
    end

    specify "une case vide renvoie 0" do
      host.c_set_position(0, 0)               # tuile (0,0) -> vide
      expect(host.submap_id).to eq [[0]]
    end
  end

  context "resolution de collision (apply_colide)" do
    specify "un mouvement vers une case pleine est annule" do
      host.c_project_new_move_with(x: 0, y: 0, dx: 40, dy: 40) # centre vise (1,1)
      host.apply_colide
      expect(host.c_new_x).to eq 0            # bloque : retour a la position
      expect(host.c_new_y).to eq 0
    end

    specify "un mouvement vers une case vide est applique" do
      host.c_project_new_move_with(x: 0, y: 0, dx: 8, dy: 8)   # reste en (0,0)
      host.apply_colide
      expect(host.x).to eq 8                   # libre : la position avance
      expect(host.y).to eq 8
    end
  end
end
