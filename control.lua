local afk_mode = false
local defense_entities = local defense_entities or {}

commands.add_command("start-afk", "Starts the AFK mode", function() -- Creates a command to start the AFK mode
    game.auto_save("AFK") -- Saves the game with the name "AFK"
    game.print("AFK mode started") -- Prints "AFK mode started" in the chat for a feedback
    afk_mode = true -- Sets the afk_mode variable to true, so we can use it in the script
end)

local function update defense_entities()
    local defense_entities = {} -- Clears the table

    for name, prototypes in pairs(game.entity_prototypes) do
        if prototype.type == "wall" or prototype.type == "gate" or prototype.type == "land-mine" or prototype.type == "ammo-turret" or prototype.type == "electric-turret" or prototype.type == "fluid-turret" or prototype.type == "artillery-turret" or prototype.type == "construction-robot" or prototype.type == "pipe" or prototype.type == "pipe-to-ground" or prototype.type == "radar" then
            table.insert(local defense_entities, name)
        end
    end
end

function table_contains(tbl, value) -- Function to check if a table contains a value (used above)
    for _, v in pairs(tbl) do --AI gave me this :D, idk what is the _ for
        if v == value then
            return true
        end
    end
    return false
end

script.on_event(defines.events.on_entity_died, function(event)
    if afk_mode then
        local entity = event.entity
        if not table_contains(local defense_entities, entity.name) then
            game.tick_paused = true
        end
    end
end)

script.on_init(function()
    update defense_entities() -- Frissítjük a védelmi entitásokat
end)