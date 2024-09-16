# dr_colider

minimaliste and modular 2D colision lib for dragon ruby

# how to install and use it

## Install Manually

1. Copy files. Copy `lib/dr_collider` folder into your dragon ruby project.
2. Requirement

Dragon ruby is a low level tool kit.
It's not a framework like rails. The purpose is to rapidly test an idea without
to much complexity.
To stick to that,
dr_colider is a very modular lib where you have to require all the file yourself.
You can use only what you need and it can adapt to many different projects.
As there is no real official framework for DR I try to provide something
flexible.

in your main file require this

```
    require "lib/dr_colider/dr_colider_draw.rb"
    require "lib/dr_colider/dr_colider_submap.rb"
    require "lib/dr_colider/dr_colider_center.rb"
    require "lib/dr_colider/dr_colider.rb"
```

Than in you sprite you have to include DrColider and some DrColider strategy

```
class CSprite
  include DrColider
  include DrColiderCenter

  attr_gtk
  attr_sprite
  end
```

To work dr_collider expect a sprite who include dr_collider
your sprite need to have some attribut see example (TODO example link)
dr_collider need also a map object who will be attribut of the sprite

That's it!

## how to use it

TODO:

# Example

# Road map

see https://github.com/levaleureux/dr_collider/blob/master/doc/roadmap.md

# Culture and people

# Contribution

# Improve de doc

If you want to help on the doc of this project.
you can use grip to preview your markdown.

```
  pip install grip

```

```
  grip chemin/vers/votre/fichier.md

```
