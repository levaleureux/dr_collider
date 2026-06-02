# Specs de DrColiderDraw : seules les fonctions PURES sont testables ici. La
# plupart des methodes de ce module produisent du rendu (args.outputs.*,
# draw_tile, label_data) et exigent le runtime DragonRuby ; l'hote de test
# expose args = nil, elles sont donc hors de portee.
#
# Seule fonction reellement pure : y_reverse(y) = height - y - 1, le miroir
# vertical d'un indice de ligne (axe Tiled vers axe ecran).

spec :dr_colider_draw do
  # Carte 3x5 en tuiles de 32 px ; aucun bloc plein n'est requis ici, on ne
  # teste que la geometrie d'inversion verticale, qui depend de height.
  let(:map)  { FakeMap.new(tilewidth: 32, tileheight: 32, width: 3, height: 5) }
  let(:host) { build_collider_host(map: map, w: 32, h: 32) }

  context "inversion verticale (y_reverse)" do
    specify "la premiere ligne devient la derniere" do
      expect(host.y_reverse(0)).to eq 4       # 5 - 0 - 1
    end

    specify "la derniere ligne devient la premiere" do
      expect(host.y_reverse(4)).to eq 0       # 5 - 4 - 1
    end

    specify "une ligne intermediaire est reflechie autour du centre" do
      expect(host.y_reverse(1)).to eq 3       # 5 - 1 - 1
      expect(host.y_reverse(3)).to eq 1       # 5 - 3 - 1
    end

    specify "l'inversion est involutive : l'appliquer deux fois rend l'indice" do
      (0..4).each do |row|
        expect(host.y_reverse(host.y_reverse(row))).to eq row
      end
    end
  end
end
