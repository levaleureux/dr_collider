# Specs de DrColiderDraw : seules les fonctions PURES sont testables ici. La
# plupart des methodes de ce module produisent du rendu (args.outputs.*,
# draw_tile, label_data) et exigent le runtime DragonRuby ; l'hote de test
# expose args = nil, elles sont donc hors de portee.
#
# Seule fonction reellement pure : y_reverse(y) = height - y - 1, le miroir
# vertical d'un indice de ligne (axe Tiled vers axe ecran). On la teste sur
# plusieurs hauteurs de carte en SURCHARGEANT le `let(:height)`.

spec :dr_colider_draw do
  let(:tile)   { 32 }
  let(:w)      { 32 }
  let(:h)      { 32 }
  let(:height) { 5 }
  let(:map) do
    FakeMap.new(tilewidth: tile, tileheight: tile, width: 3, height: height)
  end
  let(:host) { build_collider_host(map: map, w: w, h: h) }

  context "inversion verticale (y_reverse) sur une carte de 5 lignes" do
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

  context "carte de hauteur differente" do
    let(:height) { 3 }                        # surcharge : carte de 3 lignes
    specify "l'inversion s'adapte a la nouvelle hauteur" do
      expect(host.y_reverse(0)).to eq 2       # 3 - 0 - 1
      expect(host.y_reverse(2)).to eq 0       # 3 - 2 - 1
    end
  end
end
