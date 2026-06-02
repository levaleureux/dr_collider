# Spec de DrColiderDraw#draw_rect : verifie que le rectangle trace respecte
# bien la HAUTEUR passee en 4e parametre (et non la largeur). draw_rect ecrit
# dans args.outputs.lines ; l'hote de test fournit une doublure capturante
# (FakeArgs) dont on inspecte les lignes accumulees.
#
# Convention des lignes DragonRuby : [x1, y1, x2, y2].
#
# `lines` est un `let` qui EXECUTE le trace puis renvoie les lignes capturees :
# memoise par exemple, il est calcule une fois et relu plusieurs fois. Les
# contextes surchargent rect_w / rect_h pour varier le rectangle trace.

spec :dr_colider_draw_rect do
  let(:tile)   { 32 }
  let(:w)      { 32 }
  let(:h)      { 32 }
  let(:rect_w) { 4 }
  let(:rect_h) { 2 }
  let(:map)    { FakeMap.new(tilewidth: tile, tileheight: tile, width: 3, height: 3) }
  let(:host)   { build_collider_host(map: map, w: w, h: h) }
  let(:lines) do
    host.draw_rect(0, 0, rect_w, rect_h)
    host.args.outputs.lines.lines
  end

  context "rectangle non carre (largeur 4, hauteur 2)" do
    specify "l'arete haute suit la hauteur, pas la largeur" do
      expect(lines).to include([0, 2, 4, 2])      # bord superieur a y = h = 2
    end

    specify "n'utilise jamais la largeur comme hauteur (pas de carre)" do
      expect(lines).not_to include([0, 4, 4, 4])  # serait le bord d'un carre 4x4
    end

    specify "trace les quatre aretes du rectangle 4x2" do
      expect(lines).to include([0, 0, 4, 0])      # bas
      expect(lines).to include([0, 0, 0, 2])      # gauche
      expect(lines).to include([0, 2, 4, 2])      # haut
      expect(lines).to include([4, 0, 4, 2])      # droite
    end
  end

  context "hauteur omise (appel a deux dimensions)" do
    # h defaut a 0 -> draw_rect doit retomber sur un carre de cote w.
    specify "h absente => carre de cote w" do
      host.draw_rect(0, 0, 3)
      drawn = host.args.outputs.lines.lines
      expect(drawn).to include([0, 3, 3, 3])      # bord superieur a y = 3
      expect(drawn).to include([3, 0, 3, 3])      # bord droit a x = 3
    end
  end
end
