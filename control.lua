commands.add_command("start-afk", "Starts the AFK mode", function()
    game.auto_save("AFK")
    game.print("AFK mode started")
end)