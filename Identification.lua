function notifyDeveloperJoin()
    local Players = game:GetService("Players")
    local userId = 7038650395
    local developerJoined = false

    local function checkDeveloperJoin(player)
        if player.UserId == userId and not developerJoined then
            developerJoined = true
            Fluent:Notify({
                Title = "vital.wtf developer detected",
                Content = player.Name .. " has joined the server",
                Duration = 120
            })
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.UserId == userId then
            checkDeveloperJoin(player)
        end
    end

    Players.PlayerAdded:Connect(checkDeveloperJoin)

    while true do
        wait(30)
        if not developerJoined then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.UserId == userId then
                    checkDeveloperJoin(player)
                    break
                end
            end
        end
    end
end

