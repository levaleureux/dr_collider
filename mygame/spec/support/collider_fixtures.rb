# Doublures legeres pour tester les modules DrColider en isolation, sans le
# runtime DragonRuby (pas de vrai sprite, pas d'args.outputs).
#
# Une "carte de collision" doit repondre a tilewidth / tileheight / tile_at.
# tile_at(tile_x, tile_y) renvoie une tuile dont .id vaut 0 (vide) ou 1 (plein).

# Tuile minimale : porte un id (0 = vide, 1 = bloc plein).
class FakeTile
  attr_reader :id

  def initialize id
    @id = id
  end
end

# Carte de collision factice. `tiles` est un hash { [tx, ty] => id } ; toute
# case absente vaut `default_id` (0). Indexation en coordonnees tuiles.
class FakeMap
  attr_reader :tilewidth, :tileheight, :width, :height

  def initialize tilewidth: 32, tileheight: 32, width: 3, height: 3,
                 tiles: {}, default_id: 0
    @tilewidth  = tilewidth
    @tileheight = tileheight
    @width      = width
    @height     = height
    @tiles      = tiles
    @default_id = default_id
  end

  # Les modules calculent parfois des index Float (division entiere mRuby ->
  # Float). On normalise en Integer pour que la cle du hash soit stable : on
  # teste la tuile SELECTIONNEE, pas l'aléa de typage de la division.
  def tile_at tile_x, tile_y
    FakeTile.new @tiles.fetch([tile_x.to_i, tile_y.to_i], @default_id)
  end
end

# Hote minimal : un objet qui inclut les mixins de collision et expose les
# attributs qu'ils manipulent (@x, @y, @w, @h, @tile_w, @tile_h). Les methodes
# de dessin (label_data, draw_rect) sont neutralisees : on teste la logique,
# pas le rendu.
class ColliderHost
  include DrColider          # tire aussi DrColiderDraw + DrColiderSubmap
  include DrColiderCenter

  attr_accessor :x, :y, :w, :h, :tile_w, :tile_h

  def initialize w: 32, h: 32
    @w = w
    @h = h
    @x = 0
    @y = 0
  end

  # Neutralise le couplage au rendu (DrColiderDraw).
  def label_data(*); end
  def draw_rect(*);  end
  def args; nil; end
end

# Fabrique un hote pret a l'emploi, carte branchee et dr_colider_init lance.
# La position se regle ensuite via host.c_set_position dans chaque exemple.
def build_collider_host map:, w: 32, h: 32
  host = ColliderHost.new(w: w, h: h)
  host.set_colision_map map
  host.dr_colider_init
  host
end
