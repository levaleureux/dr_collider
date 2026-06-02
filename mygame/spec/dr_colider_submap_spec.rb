# Specs de DrColiderSubmap : delimitation de la "sous-carte" (submap) couverte
# par la boite projetee, et extraction des tuiles correspondantes.
#
# Deux responsabilites distinctes :
#   - find_submap_points : calcule les bornes en coordonnees tuiles et les
#     memorise dans @c_sm_min_x/min_y/max_x/max_y ;
#   - submap_tiles : relit ces bornes pour en extraire la grille de tuiles.
# submap_tiles depend donc de l'appel prealable de find_submap_points.
#
# Mise en place via `let` granulaires (tile, blocks, w, h, map, host).

spec :dr_colider_submap do
  let(:tile)   { 32 }
  # Deux blocs pleins en coordonnees tuiles (tx, ty) : (1,2) et (2,3).
  let(:blocks) { { [1, 2] => 1, [2, 3] => 1 } }
  let(:w)      { 32 }
  let(:h)      { 32 }
  let(:map) do
    FakeMap.new(tilewidth: tile, tileheight: tile, width: 4, height: 4,
                tiles: blocks)
  end
  let(:host) { build_collider_host(map: map, w: w, h: h) }

  context "find_submap_points : bornes de la sous-carte" do
    specify "renvoie [min_x, min_y, max_x, max_y] en coordonnees tuiles" do
      # Boite 32x32 (c_tile_w = c_tile_h = 1), position projetee (32, 64).
      # min_x = 32/32 = 1, min_y = 64/32 = 2, max = min + 1.
      host.c_project_new_move_with(x: 32, y: 64, dx: 0, dy: 0)
      expect(host.find_submap_points).to eq [1, 2, 2, 3]
    end

    specify "memorise les bornes dans les accesseurs c_sm_*" do
      host.c_project_new_move_with(x: 32, y: 64, dx: 0, dy: 0)
      host.find_submap_points
      expect(host.c_sm_min_x).to eq 1
      expect(host.c_sm_min_y).to eq 2
      expect(host.c_sm_max_x).to eq 2
      expect(host.c_sm_max_y).to eq 3
    end

    specify "prend en compte le deplacement projete (delta)" do
      # Depart (0, 0) + delta (64, 32) -> position projetee (64, 32).
      # min_x = 64/32 = 2, min_y = 32/32 = 1.
      host.c_project_new_move_with(x: 0, y: 0, dx: 64, dy: 32)
      expect(host.find_submap_points).to eq [2, 1, 3, 2]
    end

    specify "a l'origine, la sous-carte demarre en (0, 0)" do
      host.c_project_new_move_with(x: 0, y: 0, dx: 0, dy: 0)
      expect(host.find_submap_points).to eq [0, 0, 1, 1]
    end

    specify "renvoie des bornes entieres (Integer)" do
      # La division entiere mRuby (Integer / Integer) peut produire un Float.
      # On normalise a la source : les quatre bornes doivent etre des Integer.
      host.c_project_new_move_with(x: 32, y: 64, dx: 0, dy: 0)
      host.find_submap_points.each do |borne|
        expect(borne).to be_instance_of Integer
      end
    end
  end

  context "submap_tiles : extraction de la grille de tuiles" do
    specify "renvoie une grille 2x2 d'objets repondant a .id" do
      # find_submap_points DOIT preceder submap_tiles : ce dernier relit
      # @c_sm_* pose par le premier. Sous-carte bornee (1,2)..(2,3).
      host.c_project_new_move_with(x: 32, y: 64, dx: 0, dy: 0)
      host.find_submap_points
      grille = host.submap_tiles
      expect(grille.length).to eq 2          # deux lignes (x)
      expect(grille.first.length).to eq 2    # deux colonnes (y)
    end

    specify "recupere les bons id aux bonnes positions de la sous-carte" do
      # Sous-carte (1,2)..(2,3). submap_tiles indexe tile_at(x, y) avec
      # x dans min_x..max_x et y dans min_y..max_y. Cases visitees (x, y) :
      #   (1,2) (1,3)
      #   (2,2) (2,3)
      # Les blocs pleins poses sont en (1,2) et (2,3) -> coins opposes.
      host.c_project_new_move_with(x: 32, y: 64, dx: 0, dy: 0)
      host.find_submap_points
      ids = host.submap_tiles.map { |row| row.map(&:id) }
      expect(ids).to eq [[1, 0],
                         [0, 1]]
    end

    specify "une sous-carte entierement vide ne contient que des 0" do
      # Sous-carte (0,0)..(1,1) : aucune case pleine n'y figure.
      host.c_project_new_move_with(x: 0, y: 0, dx: 0, dy: 0)
      host.find_submap_points
      ids = host.submap_tiles.map { |row| row.map(&:id) }
      expect(ids).to eq [[0, 0],
                         [0, 0]]
    end
  end
end
