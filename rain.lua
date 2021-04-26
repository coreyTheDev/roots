function splashSpawn(dropletX, dropletY)
  splash = {}
  splash.x = dropletX - 10
  splash.y = dropletY + 5
  splash.timer = splashTimer
  table.insert(splashes, splash)
end

function dropletSpawn()
  droplet = {}
  droplet.x = math.random(1, gridWidth)
  droplet.musicIndex = droplet.x
  droplet.x = (droplet.x * tileSize) - 15 --limit it to and center it on tile
  droplet.y = -dropletHeight
  droplet.acc = dropletAcc
  table.insert(droplets, droplet)
end