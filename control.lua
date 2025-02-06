local afk_mode = false

commands.add_command("start-afk", "Starts the AFK mode", function() --Adds start-afk command
    if not afk_mode then --If the AFK mode is off then the following will run, else the one below
        game.auto_save("AFK") --Saves the game with the name _autosave-AFK
        game.print("AFK mode started") --Writes a message in the console
        afk_mode = true --Turns on the variable so that it can be used later
    else
        game.print("You need to turn off AFK mode to be able to turn it on") --Writes a message in the console
    end
end)

commands.add_command("stop-afk", "Stops the AFK mode", function() --Adds stop-afk command
   if afk_mode then --If the AFK mode is on then the following will run, else the one below
    game.print("AFK mode stopped") --Writes a message in the console
    afk_mode = false --Turns off the variable
    game.autosave_enabled = true --Turns autosave back
    game.tick_paused = false --Unpauses the game in case it was paused
   else
    game.print("You need to turn on AFK mode to be able to turn it off") --Writes a message in the console
   end
end)

script.on_event(defines.events.on_entity_died, function(event)
    if afk_mode and event.entity then --Check if the AFK mode is on and if the "event" has an entity
        local entity_type = event.entity.prototype.type  --Gets the entity type
        
        --List of defensive entities, which are allowed to be destroyed
        local defensive_entities = {
            wall = true, gate = true, ["land-mine"] = true, ["ammo-turret"] = true, 
            ["electric-turret"] = true, ["fluid-turret"] = true, ["artillery-turret"] = true, 
            ["construction-robot"] = true, pipe = true, ["pipe-to-ground"] = true, radar = true
        }

        if not defensive_entities[entity_type] then --Check if the destroyed entity is NOT in the defensive list
            game.print("Game stopped because a non-defensive entity was destroyed")
            game.tick_paused = true --Pauses the game so that the biters dont destroy the base
            game.autosave_enabled = false --Turns off autosave, so that the player can load the last save
        end
    end
end)