#[
int num = (rand() % (upper - lower + 1)) + lower; // range
]#

import times


when defined(windows):
    proc rand(): cint {.header:"conio.h", importc.}
    proc srand(x: cint) {.header:"conio.h", importc.}

when defined(linux):
    proc rand(): cint {.header:"stdlib.h", importc.}
    proc srand(x: cint) {.header:"stdlib.h", importc.}

var
    timeSeconds = now().second
    timeMinutes = now().minute
    timeHours = now().hour
    seed = timeSeconds + timeMinutes + timeHours

srand(seed.cint)

type
    Entity* = object
        model*: char
        xPos*: int
        yPos*: int
        events*: seq[string]
    Player* = object
        model*: char
        inventory*: seq[string]
        xPos*: int
        yPos*: int
        events*: seq[string]     
    Map* = object
        model*: seq[seq[string]]
        width*: int
        height*: int
    
const MAP_CONST*: seq[seq[string]] = @[ # 34x8
    @[". . . . . . . . . . . . . . . . . ."],
    @[". . . . . . . . . . . . . . . . . ."],
    @[". . . . . . . . . . . . . . . . . ."],
    @[". . . . . . . . . . . . . . . . . ."],
    @[". . . . . . . . . . . . . . . . . ."],
    @[". . . . . . . . . . . . . . . . . ."],
    @[". . . . . . . . . . . . . . . . . ."],
    @[". . . . . . . . . . . . . . . . . ."],
    ]

var
    entities*: seq[Entity] = @[]


proc random*(x: int): int =
    return rand() mod x

proc newPlayer*(this: type Player, model: char, inventory: seq[string], xPos: int, yPos: int, events: seq[string]): Player = 
    # add name and networking stuff
    result.model = model
    result.inventory = inventory
    result.xPos = xPos
    result.yPos = yPos
    result.events = events

proc newEntity*(this: type Entity, model: char, xPos: int, yPos: int, events: seq[string]): Entity = 
    result.model = model
    result.xPos = xPos
    result.yPos = yPos
    result.events = events

proc addEntity*(model: char, xPos: int, yPos: int, events: seq[string]) = 
    entities.add(Entity.newEntity(model, xPos, yPos, events))

proc removeEntityAtPosition(xPos: int, yPos: int) =
    var
        i = 0
    for entity in entities:
        if entity.xPos == xPos and entity.yPos == yPos:
            break
        #i += 1
    echo "before ", entities
    entities.delete(i)
    echo "after ", entities

proc newMap*(this: type Map, model: seq[seq[string]]): Map =
    result.model = model
    result.width = model[0][0].len - 1
    result.height = model.len - 1

proc update*(map: var seq[seq[string]]) =
    for i in map:
        echo i[0]

proc blit*(map: var seq[seq[string]], entity: Entity) =
    map[entity.yPos][0][entity.xPos] = entity.model

proc blit*(map: var seq[seq[string]], entity: Player) =
    map[entity.yPos][0][entity.xPos] = entity.model

proc removeEntitiesAtIndex*(index: int) =
    var i = 0
    for entity in entities:
        if entity.model == 'X':
            break
        i += 1
    entities.delete(i)

proc actions*(player: var Player, action: char = '\0') =
    var
        i = 0
        entityIndex: int = -1
    for entity in entities:
        if player.xPos == entity.xPos and player.yPos == entity.yPos:
            for event in entity.events:
                if event[0..3] == "NAME":
                    echo event[5..(event.len - 1)]
                elif event[0..3] == "GIVE" and action == 'f':
                    add(player.inventory, event[5..(event.len - 1)])
                    echo "gave yuh sum `", event[5..(event.len - 1)], "` nigguh"
                    entityIndex = i
        else:
            discard
                        
            i += 1
    
    if entityIndex > -1:
        entities.delete(entityIndex)




#[
#DELETE_ENTITY

addEntity('G', random(board.width), random(board.height), @["NAME:Gold ore", "GIVE:goldOre"])
addEntity('X', random(board.width), random(board.height), @["xd"])
addEntity('G', random(board.width), random(board.height), @["NAME:Gold ore", "GIVE:goldOre"])

var i = 0
for entity in entities:
    if entity.model == 'X':
        break
    i += 1
entities.delete(i)
]#

