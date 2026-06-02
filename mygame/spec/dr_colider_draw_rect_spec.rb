# Spec de DrColiderDraw#draw_rect : verifie que le rectangle trace respecte
# bien la HAUTEUR passee en 4e parametre (et non la largeur). draw_rect ecrit
# dans args.outputs.lines ; l'hote de test fournit une doublure capturante
# (FakeArgs) dont on inspecte les lignes accumulees.
#
# Convention des lignes DragonRuby : [x1, y1, x2, y2].

spec :dr_colider_draw_rect do
  let(:map)  { FakeMap.new(tilewidth: 32, tileheight: 32, width: 3, height: 3) }
  let(:host) { build_collider_host(map: map, w: 32, h: 32) }

  context "rectangle non carre (largeur != hauteur)" do
    # draw_rect(0, 0, 4, 2) : coin en (0,0), largeur 4, hauteur 2.
    specify "l'arete haute suit la hauteur, pas la largeur" do
      host.draw_rect(0, 0, 4, 2)
      lines = host.args.outputs.lines.lines
      expect(lines).to include([0, 2, 4, 2])      # bord superieur a y = h = 2
    end

    specify "n'utilise jamais la largeur comme hauteur (pas de carre)" do
      host.draw_rect(0, 0, 4, 2)
      lines = host.args.outputs.lines.lines
      expect(lines).not_to include([0, 4, 4, 4])  # serait le bord d'un carre 4x4
    end

    specify "trace les quatre aretes du rectangle 4x2" do
      host.draw_rect(0, 0, 4, 2)
      lines = host.args.outputs.lines.lines
      expect(lines).to include([0, 0, 4, 0])      # bas
      expect(lines).to include([0, 0, 0, 2])      # gauche
      expect(lines).to include([0, 2, 4, 2])      # haut
      expect(lines).to include([4, 0, 4, 2])      # droite
    end
  end

  context "hauteur omise" do
    # draw_rect(0, 0, 3) : h defaut a 0 -> doit retomber sur un carre 3x3.
    specify "h absente => carre de cote w" do
      host.draw_rect(0, 0, 3)
      lines = host.args.outputs.lines.lines
      expect(lines).to include([0, 3, 3, 3])      # bord superieur a y = 3
      expect(lines).to include([3, 0, 3, 3])      # bord droit a x = 3
    end
  end
end
