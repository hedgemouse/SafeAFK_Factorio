local afk_mode = false

commands.add_command("start-afk", "Starts the AFK mode", function(event) --Adds start-afk command
    if not afk_mode then --If the AFK mode is off then the following will run, else the one below
        local player = game.players[event.player_index] -- Get the player who issued the command
        local player_position = player.position -- Store the player's position in a variable
        game.auto_save("AFK") --Saves the game with the name _autosave-AFK
        game.print("AFK mode started") --Writes a message in the console
        afk_mode = true --Turns on the variable so that it can be used later
        game.autosave_enabled = true
        rendering.clear("SafeAFK")
        rendering.draw_text{text = "AFK mode ON", scale_with_zoom = true, surface = player.surface, target = player_position, color = {r = 1, g = 0, b = 0, a = 1}, scale = (3)} --Draws a text on the screen
    else
        game.print("AFK mode already turned on") --Writes a message in the console
    end
end)

commands.add_command("stop-afk", "Stops the AFK mode", function(event) --Adds stop-afk command
   if afk_mode then --If the AFK mode is on then the following will run, else the one below
    local player = game.players[event.player_index] -- Get the player who issued the command
    local player_position = player.position -- Store the player's position in a variable
    game.print("AFK mode stopped") --Writes a message in the console
    afk_mode = false --Turns off the variable
    game.autosave_enabled = true --Turns autosave back
    game.tick_paused = false --Unpauses the game in case it was paused
    rendering.clear("SafeAFK")
    rendering.draw_text{text = "AFK mode OFF", time_to_live = 300, scale_with_zoom = true, surface = player.surface, target = player_position, color = {r = 0, g = 1, b = 0, a = 1}, scale = (3)} --Draws a text on the screen
   else
    game.print("AFK mode already turned off") --Writes a message in the console
   end
end)

script.on_event(defines.events.on_entity_died, function(event)
    local player = game.players[event.player_index] -- Get the player who issued the command
    local player_position = player.position -- Store the player's position in a variable
    if afk_mode and event.entity and event.entity.force.name == "player" then --Check if the AFK mode is on, if the "event" has an entity, and if the entity is not in the player faction
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
            rendering.clear("SafeAFK")
            rendering.draw_text{text = "Game Paused", scale_with_zoom = true, surface = event.entity.surface, target = player_position.position, color = {r = 1, g = 1, b = 0, a = 1}, scale = (3)} --Draws a text on the screen
        end
    end
end)

script.on_load(function()
    afk_mode = false
end)