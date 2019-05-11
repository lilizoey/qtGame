import engine
from os import execShellCmd
from terminal import getch

when defined(windows):
    proc clearScreen() =
        discard execShellCmd("cls")

when defined(linux):
    proc clearScreen() =
        discard execShellCmd("clear")

var
    board = Map.newMap(MAP_CONST)
    input: char
    pl = Player.newPlayer('P', @[], 0, 0, @["placeholder"])

#[
entities.add(pl)
#blit(board.model, entities) # add this to the while loop(but find a way to change player's coordinates when it's in the `entities` variable)
]#

#[
echo Entity.newPlayer('X', 1, 1, @["x"])
addEntity('X', 1, 0, @["xd"])
echo entities
]#

addEntity('G', random(board.width), random(board.height), @["NAME:Gold ore", "GIVE:goldOre"])
addEntity('G', random(board.width), random(board.height), @["NAME:Gold ore", "GIVE:goldOre"])
addEntity('F', random(board.width), random(board.height), @["NAME:Furriest"])

while input != 'q':
    clearScreen()
    board.model = MAP_CONST
    for entity in entities:
        blit(board.model, entity)
    blit(board.model, pl)
    update(board.model)
    pl.actions(input)

    input = getch()
    if input == 'd' and pl.xPos < board.width:
        pl.xPos += 1
    elif input == 'a' and pl.xPos > 0:
        pl.xPos -= 1
    elif input == 'w' and pl.yPos > 0:
        pl.yPos -= 1
    elif input == 's' and pl.yPos < board.height:
        pl.yPos += 1
    elif input == 't':
        discard # make this chat and commands(like in minecraft)
    elif input == 'i':
        if len(pl.inventory) == 0:
            echo "Empty inventory"
        else:
            echo pl.inventory
        if stdin.readLine() == "q":
            break

