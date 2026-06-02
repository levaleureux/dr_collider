# Définition de la tile map (0 = vide, 1 = solide)
TILE_MAP = [
  [1, 1, 1, 1, 1],
  [1, 0, 0, 0, 1],
  [1, 0, 0, 0, 1],
  [1, 0, 0, 0, 1],
  [1, 1, 1, 1, 1]
]

TILE_SIZE = 32

def tile_at(x, y)
  tile_x = (x / TILE_SIZE).floor
  tile_y = (y / TILE_SIZE).floor
  TILE_MAP[tile_y][tile_x] rescue 1  # Si hors limites, considérer comme solide
end

def check_collision(x, y, width, height)
  left   = tile_at(x, y)
  right  = tile_at(x + width - 1, y)
  top    = tile_at(x, y + height - 1)
  bottom = tile_at(x + width - 1, y + height - 1)

  left == 1 || right == 1 || top == 1 || bottom == 1
end

def tick args
  # Position et taille du sprite
  args.state.player.x ||= 50
  args.state.player.y ||= 50
  args.state.player.w ||= 20
  args.state.player.h ||= 20

  # Déplacement du sprite
  speed = 2
  args.state.player.x += speed if args.inputs.right
  args.state.player.x -= speed if args.inputs.left
  args.state.player.y += speed if args.inputs.up
  args.state.player.y -= speed if args.inputs.down

  # Vérification de collision
  if check_collision(args.state.player.x, args.state.player.y, args.state.player.w, args.state.player.h)
    # En cas de collision, annuler le dernier mouvement
    args.state.player.x -= speed if args.inputs.right
    args.state.player.x += speed if args.inputs.left
    args.state.player.y -= speed if args.inputs.up
    args.state.player.y += speed if args.inputs.down
  end

  # Affichage du sprite
  args.outputs.solids << [args.state.player.x, args.state.player.y, args.state.player.w, args.state.player.h, 255, 0, 0]

  # Affichage de la tile map
  TILE_MAP.each_with_index do |row, y|
    row.each_with_index do |tile, x|
      if tile == 1
        args.outputs.solids << [x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE, 0, 0, 0]
      end
    end
  end
end
