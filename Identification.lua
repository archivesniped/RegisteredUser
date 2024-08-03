function notifyDesirableJoin()
    local Players = game:GetService("Players")
local userIds = [19, 7139298780, 7095321934]
    local desirableJoined = false

    local function checkDesirableJoin(player)
        if table.find(userIds, player.UserId) and not desirableJoined then
            desirableJoined = true
            Fluent:Notify({
                Title = "vital.wtf desirable detected",
                Content = player.Name .. " has joined the server",
                Duration = 120
            })
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if table.find(userIds, player.UserId) then
            checkDesirableJoin(player)
        end
    end

    Players.PlayerAdded:Connect(checkDesirableJoin)

    while true do
        wait(30)
        if not desirableJoined then
            for _, player in ipairs(Players:GetPlayers()) do
                if table.find(userIds, player.UserId) then
                    checkDesirableJoin(player)
                    break
                end
            end
        end
    end
end
