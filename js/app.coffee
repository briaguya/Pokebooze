$(document).ready ->
  # Draw plotter helper points on their own layer
  window.plotter = new Plotter $("#table"), stage
  game = setupGame(tileCoords)
  stage = setupStage()
  group = stage.children[0].children[0]
  game.board.node = group
  window.game = game
  drawBoard(group, game)
  drawTiles(group, game)
  drawPlayers(group, game)

  setTimeout( -> 
    panToStart(game)
  , 1000)


setupGame = (tileCoords) ->
  game = new Game
  for i in [0..3]
    p = new Player
    game.players.push(p)

  for pair in window.tileCoords
    tile = new Tile(pair.x, pair.y)
    game.tiles.push tile

  return game

setupStage = ->
  window.stage = new Kinetic.Stage {
          container: 'table'
          width: window.innerWidth
          height: window.innerHeight
        }
  layer = new Kinetic.Layer
  topGroup = new Kinetic.Group
  layer.add(topGroup)
  stage.add(layer)
  stage

drawBoard = (group, game) ->
  # Draw the board on its own layer
  boardObj = new Image
  boardObj.onload = =>
    board = new Kinetic.Image {
      x: game.board.edgeLength/2
      y: game.board.edgeLength/2
      offsetX: game.board.edgeLength/2
      offsetY: game.board.edgeLength/2
      image: boardObj
      width: game.board.edgeLength
      height: game.board.edgeLength
    }
    group.add(board)
    board.moveToBottom()
    group.draw()

  boardObj.src = "/images/game.jpg"

drawTiles = (group, game) ->
  for tile in game.tiles
    circle = new Kinetic.Circle {
      x: game.board.edgeLength * tile.x
      y: game.board.edgeLength * tile.y
      # radius: 5
      # fill: 'red'
      # stroke: 'black'
      # strokeWidth: 2
    }
    group.add(circle)
  group.draw()

drawPlayers = (group, game) ->
  for player in game.players
    rect = new Kinetic.Rect {
      x: game.board.edgeLength * game.tiles[player.position].x
      y: game.board.edgeLength * game.tiles[player.position].y
      width: game.board.playerLength
      height: game.board.playerLength
      fill: 'rgb('+player.color[0]+','+player.color[1]+','+player.color[2]+')'
      stroke: 'black'
      strokeWidth: 2
    }
    player.node = rect
    group.add(rect)

  group.draw()

panToStart = (game) ->
  game.rotateToTile game.tiles[0], ->
    game.zoomToTile game.tiles[0]
    

