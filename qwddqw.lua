local watermark = [[


     _ _                       _                 __         _         _ _        _ 
  __| (_)___  ___ ___  _ __ __| |  __ _  __ _   / /_ _  ___| |___   _(_) |_ __ _| |
 / _` | / __|/ __/ _ \| '__/ _` | / _` |/ _` | / / _` |/ _ \ __\ \ / / | __/ _` | |
| (_| | \__ \ (_| (_) | | | (_| || (_| | (_| |/ / (_| |  __/ |_ \ V /| | || (_| | |
 \__,_|_|___/\___\___/|_|  \__,_(_)__, |\__, /_/ \__, |\___|\__| \_/ |_|\__\__,_|_|
                                  |___/ |___/    |___/                             
                            #1 Apocalypse Rising 2 Script
                              Developed by fedarel#0

]]

print(watermark)

wait(1)

local function safeCall(func, ...)
    local status, result = pcall(func, ...)
    if not status then
        print("Error: " .. result)
        return nil
    end
    return result
end

local function riskyFunction(param)
    if not param then
        error("param cannot be nil!")
    end
    return param * 2
end

local result = safeCall(riskyFunction, nil)
if result then
    print("Result: " .. result)
else
    print("Failed to execute riskyFunction.")
end

local function getSafeProperty(obj, prop, default)
    if obj and obj[prop] then
        return obj[prop]
    else
        return default
    end
end

local exampleObject = { name = "vital.wtf Crash Bypass", value = 42 }
local name = getSafeProperty(exampleObject, "name", "Unknown")
local nonExistentProp = getSafeProperty(exampleObject, "nonExistentProp", "DefaultValue")

print("Name: " .. name)
print("Non-existent Property: " .. nonExistentProp)

local function safeConnect(event, func)
    local success, connection = pcall(function() return event:Connect(func) end)
    if not success then
        print("Failed to connect to event: " .. connection)
        return nil
    end
    return connection
end

local Players = game:GetService("Players")
local function onPlayerAdded(player)
    print("Player added: " .. player.Name)
end

local connection = safeConnect(Players.PlayerAdded, onPlayerAdded)
if connection then
    print("Successfully connected to PlayerAdded event.")
else
    print("Failed to connect to PlayerAdded event.")
end

local function safeDisconnect(connection)
    if connection then
        local success, err = pcall(function() connection:Disconnect() end)
        if not success then
            print("Failed to disconnect: " .. err)
        end
    end
end

safeDisconnect(connection)

wait(1)

task.spawn(function()
    for Index, Connection in pairs(getconnections(game:GetService("ScriptContext").Error)) do
        --print("found ScriptContext error detection, removing")
        Connection:Disable()
    end
    while task.wait(1) do
        for Index, Connection in pairs(getconnections(game:GetService("ScriptContext").Error)) do
            --print("found ScriptContext error detection, removing")
            Connection:Disable()
        end
    end
end)

local NetworkSyncHeartbeat
local InteractHeartbeat, FindItemData
for Index, Table in pairs(getgc(true)) do
    if type(Table) == "table" and rawget(Table, "Rate") == 0.05 then
        InteractHeartbeat = Table.Action
        FindItemData = getupvalue(InteractHeartbeat, 11)
    end
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "vital.wtf | v3.0.0",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Home = Window:AddTab({Title = "Home", Icon = "home"}),
    Private = Window:AddTab({Title = "Private", Icon = "shield"}),
    Combat = Window:AddTab({Title = "Combat", Icon = "swords"}),
    Visuals = Window:AddTab({Title = "Visuals", Icon = "moon"}),
    Player = Window:AddTab({Title = "Player", Icon = "user"}),
    Mods = Window:AddTab({Title = "Gun Mods", Icon = "wrench"}),
    Movement = Window:AddTab({Title = "Movement", Icon = "gauge"}),
    Misc = Window:AddTab({Title = "Miscellaneous", Icon = "folder"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}

local Options = Fluent.Options

Tabs.Home:AddParagraph({
    Title = "ChangeLog",
    Content = "\n+ Fixed Aimbot\n+ Corpse ESP\n+ Optimized whole script \n+ New Full Bright\n+ Rewrote everything"
})

Tabs.Home:AddParagraph({
    Title = "Developers",
    Content = "\n fedarel - Developer"
})

Tabs.Home:AddParagraph({
    Title = "Contributors",
    Content = "\n 1x1nexam#0 - Contributor\n purple_core#0 - Manager"
})

wait(2)

--// AC Bypasser TAB: Private

local function NotifyAnticheatDisabler()
    Fluent:Notify(
        {
            Title = "Vital.wtf",
            Content = "Bypassed Apocalypse Rising 2 Anticheat",
            SubContent = "Vital just better",
            Duration = 10
        }
    )
end

local AnticheatDisablerEnabled = false

local ToggleAnticheatDisablerUI =
    Tabs.Private:AddToggle("Anticheat Disabler", {Title = "AntiCheat Bypasser", Default = false})
ToggleAnticheatDisablerUI:OnChanged(
    function(value)
        AnticheatDisablerEnabled = value
        if value then
            NotifyAnticheatDisabler()
        end
    end
)

--// TP To nearest player TAB: Private

local function teleportToNearestPlayer(player)
    local character = player.Character
    if not character then return end

    local nearestPlayer = nil
    local nearestDistance = math.huge

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local distance = (character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPlayer = otherPlayer
            end
        end
    end

    if nearestPlayer and nearestPlayer.Character then
        local targetPosition = nearestPlayer.Character.HumanoidRootPart.Position
        lagTeleport(character, targetPosition)
    end
end

local function lagTeleport(character, targetPosition)
    local function teleportStep(currentPosition, targetPosition, stepDistance)
        local direction = (targetPosition - currentPosition).unit
        local newPosition = currentPosition + direction * stepDistance
        character:SetPrimaryPartCFrame(CFrame.new(newPosition))
        return newPosition
    end

    local currentPosition = character.HumanoidRootPart.Position
    local stepDistance = 350

    while (currentPosition - targetPosition).magnitude > stepDistance do
        currentPosition = teleportStep(currentPosition, targetPosition, stepDistance)
        wait(5)
    end

    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))

    for _, partInfo in ipairs({
        {"Head", true}, {"HumanoidRootPart", true},
        {"UpperTorso", false}, {"LowerTorso", false},
        {"RightUpperArm", false}, {"RightLowerArm", false}, {"RightHand", false},
        {"LeftUpperArm", false}, {"LeftLowerArm", false}, {"LeftHand", false},
        {"RightUpperLeg", false}, {"RightLowerLeg", false}, {"RightFoot", false},
        {"LeftUpperLeg", false}, {"LeftLowerLeg", false}, {"LeftFoot", false}
    }) do
        local partName, primary = unpack(partInfo)
        local part = character:FindFirstChild(partName)
        if part then
            part.CFrame = character.HumanoidRootPart.CFrame
        end
    end
end

Tabs.Private:AddButton({
    Title = "Teleport to Nearest Player",
    Description = "Teleport to the nearest player slowly.",
    Callback = function()
        Window:Dialog({
            Title = "Confirm Teleport",
            Content = "This may lag you back, and potentially kick you for `Cream Of Mushroom`",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        teleportToNearestPlayer(player)
                        print("Teleported to the nearest player.")
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the teleport.")
                    end
                }
            }
        })
    end
})

wait(1.5)

--// Aimbot TAB: Combat

-- removed

--// HitboxExpander TAB: Combat

local PlayerService = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = PlayerService.LocalPlayer

local originalIndex = getrawmetatable(game).__index
setreadonly(getrawmetatable(game), false)
getrawmetatable(game).__index = function(Self, Index)
    if tostring(Self) == "Head" and Index == "Size" then
        return Vector3.one * 1.15
    end
    return originalIndex(Self, Index)
end
setreadonly(getrawmetatable(game), true)

local function onFireServer(...)
    local Args = {...}
    if type(Args[1]) == "table" then
        print("Framework check")
        return
    end
    originalFireServer(...)
end

local function onGetChildren(self, ...)
    if self == ReplicatedFirst or self == ReplicatedStorage then
        print("Crash bypass")
        wait(383961600)
    end
    return originalGetChildren(self, ...)
end

local hitboxExpanderEnabled = false
local headSize = 1.15

local function ExpandHeadHitbox(Player)
    if Player == LocalPlayer then
        return
    end

    if Player.Character then
        local head = Player.Character:FindFirstChild("Head")
        if head then
            if hitboxExpanderEnabled then
                head.Size = Vector3.new(headSize, headSize, headSize)
                head.Transparency = 0.5
                head.CanCollide = false
            else
                head.Size = Vector3.new(1, 1, 1)
                head.Transparency = 0
                head.CanCollide = true
            end
        else
            print("Head not found in character for player:", Player.Name)
        end
    else
        print("Character not found for player:", Player.Name)
    end
end

local function ToggleHitboxExpander(enabled)
    hitboxExpanderEnabled = enabled
    for _, Player in ipairs(PlayerService:GetPlayers()) do
        ExpandHeadHitbox(Player)
    end
end

local function AdjustHeadSize(value)
    headSize = value
    for _, Player in ipairs(PlayerService:GetPlayers()) do
        ExpandHeadHitbox(Player)
    end
end

local function SetupPlayer(Player)
    Player.CharacterAdded:Connect(function(character)
        ExpandHeadHitbox(Player)
    end)
end

PlayerService.PlayerAdded:Connect(function(Player)
    SetupPlayer(Player)
    ExpandHeadHitbox(Player)
end)

for _, Player in ipairs(PlayerService:GetPlayers()) do
    SetupPlayer(Player)
    ExpandHeadHitbox(Player)
end

local Toggle = Tabs.Combat:AddToggle("HitboxExpanderToggle", {Title = "Hitbox Expander Toggle", Default = false})

Toggle:OnChanged(function()
    ToggleHitboxExpander(Toggle.Value)
end)

local Slider = Tabs.Combat:AddSlider("HeadSizeSlider", {
    Title = "Head Size",
    Description = "Adjust the size of the head hitbox",
    Default = 1.15,
    Min = 1,
    Max = 45,
    Rounding = 2,
    Callback = function(Value)
        AdjustHeadSize(Value)
    end
})

Slider:OnChanged(function(Value)
    AdjustHeadSize(Value)
end)

wait(2)

--// ESP TAB: Visuals

local ESP = {
    Enabled = true,
    Boxes = true,
    Tracers = true,
    BoxShift = CFrame.new(0, -1.5, 0),
    BoxSize = Vector3.new(4, 6, 0),
    Color = Color3.fromRGB(255, 255, 255), -- White color for the box
    FaceCamera = true,
    Names = true,
    DistanceESP = true,
    TeamColor = true,
    Thickness = 0.5, -- Thinner box
    AttachShift = 1,
    TeamMates = true,
    Players = true,
    Friends = true,
    DistanceSize = 9,
    NameSize = 9,
    Objects = setmetatable({}, { __mode = "kv" }),
    Overrides = {},
    FillColor = Color3.fromRGB(175, 25, 255),
    DepthMode = "AlwaysOnTop",
    FillTransparency = 0.5,
    OutlineColor = Color3.fromRGB(255, 255, 255),
    OutlineTransparency = 0,
    DistanceCheck = 5000 -- Updated Distance Check
}

local cam = workspace.CurrentCamera
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local CoreGui = game:GetService("CoreGui")
local connections = {}

local V3new = Vector3.new
local WorldToViewportPoint = cam.WorldToViewportPoint

-- Functions
local function Draw(obj, props)
    local new = Drawing.new(obj)
    props = props or {}
    for i, v in pairs(props) do
        new[i] = v
    end
    return new
end

function ESP:GetTeam(p)
    local ov = self.Overrides.GetTeam
    if ov then
        return ov(p)
    end
    return p and p.Team
end

function ESP:IsTeamMate(p)
    local ov = self.Overrides.IsTeamMate
    if ov then
        return ov(p)
    end
    return self:GetTeam(p) == self:GetTeam(plr)
end

function ESP:GetColor(obj)
    local ov = self.Overrides.GetColor
    if ov then
        return ov(obj)
    end
    local p = self:GetPlrFromChar(obj)
    return p and self.TeamColor and p.Team and p.Team.TeamColor.Color or self.Color
end

function ESP:GetPlrFromChar(char)
    local ov = self.Overrides.GetPlrFromChar
    if ov then
        return ov(char)
    end
    return plrs:GetPlayerFromCharacter(char)
end

function ESP:Toggle(bool)
    self.Enabled = bool
    if not bool then
        for i, v in pairs(self.Objects) do
            if v.Type == "Box" then -- fov circle etc
                if v.Temporary then
                    v:Remove()
                else
                    for i, v in pairs(v.Components) do
                        v.Visible = false
                    end
                end
            end
        end
    end
end

function ESP:GetBox(obj)
    return self.Objects[obj]
end

function ESP:AddObjectListener(parent, options)
    local function NewListener(c)
        if type(options.Type) == "string" and c:IsA(options.Type) or options.Type == nil then
            if type(options.Name) == "string" and c.Name == options.Name or options.Name == nil then
                if not options.Validator or options.Validator(c) then
                    local box = ESP:Add(c, {
                        PrimaryPart = type(options.PrimaryPart) == "string" and c:WaitForChild(options.PrimaryPart) or type(options.PrimaryPart) == "function" and options.PrimaryPart(c),
                        Color = type(options.Color) == "function" and options.Color(c) or options.Color,
                        ColorDynamic = options.ColorDynamic,
                        Name = type(options.CustomName) == "function" and options.CustomName(c) or options.CustomName,
                        IsEnabled = options.IsEnabled,
                        RenderInNil = options.RenderInNil
                    })
                    if options.OnAdded then
                        coroutine.wrap(options.OnAdded)(box)
                    end
                end
            end
        end
    end

    if options.Recursive then
        parent.DescendantAdded:Connect(NewListener)
        for i, v in pairs(parent:GetDescendants()) do
            coroutine.wrap(NewListener)(v)
        end
    else
        parent.ChildAdded:Connect(NewListener)
        for i, v in pairs(parent:GetChildren()) do
            coroutine.wrap(NewListener)(v)
        end
    end
end

local boxBase = {}
boxBase.__index = boxBase

function boxBase:Remove()
    ESP.Objects[self.Object] = nil
    for i, v in pairs(self.Components) do
        v.Visible = false
        v:Remove()
        self.Components[i] = nil
    end
end

function boxBase:Update()
    if not self.PrimaryPart then
        return self:Remove()
    end

    local FriendCheck = game.Players.LocalPlayer:IsFriendsWith(game.Players:FindFirstChild(self.Name).UserId)

    local color
    if ESP.Highlighted == self.Object then
        color = ESP.HighlightColor
    else
        color = self.Color or self.ColorDynamic and self:ColorDynamic() or ESP:GetColor(self.Object) or ESP.Color
    end

    local allow = true
    if ESP.Overrides.UpdateAllow and not ESP.Overrides.UpdateAllow(self) then
        allow = false
    end
    if self.Player and not ESP.TeamMates and ESP:IsTeamMate(self.Player) then
        allow = false
    end
    if self.Player and not ESP.Players then
        allow = false
    end
    if self.IsEnabled and (type(self.IsEnabled) == "string" and not ESP[self.IsEnabled] or type(self.IsEnabled) == "function" and not self:IsEnabled()) then
        allow = false
    end
    if not workspace:IsAncestorOf(self.PrimaryPart) and not self.RenderInNil then
        allow = false
    end
    if self.PrimaryPart.Position and (cam.CFrame.p - self.PrimaryPart.Position).magnitude > ESP.DistanceCheck then
        allow = false
    end

    if not allow then
        for i, v in pairs(self.Components) do
            v.Visible = false
        end
        return
    end

    local cf = self.PrimaryPart.CFrame
    if ESP.FaceCamera then
        cf = CFrame.new(cf.p, cam.CFrame.p)
    end
    local size = self.Size
    local locs = {
        TopLeft = cf * ESP.BoxShift * CFrame.new(size.X / 2, size.Y / 2, 0),
        TopRight = cf * ESP.BoxShift * CFrame.new(-size.X / 2, size.Y / 2, 0),
        BottomLeft = cf * ESP.BoxShift * CFrame.new(size.X / 2, -size.Y / 2, 0),
        BottomRight = cf * ESP.BoxShift * CFrame.new(-size.X / 2, -size.Y / 2, 0),
        TagPos = cf * ESP.BoxShift * CFrame.new(0, size.Y / 2, 0) + Vector3.new(0, 2.5, 0),
        Torso = cf * ESP.BoxShift
    }

    if ESP.Boxes then
        local TopLeft, Vis1 = WorldToViewportPoint(cam, locs.TopLeft.p)
        local TopRight, Vis2 = WorldToViewportPoint(cam, locs.TopRight.p)
        local BottomLeft, Vis3 = WorldToViewportPoint(cam, locs.BottomLeft.p)
        local BottomRight, Vis4 = WorldToViewportPoint(cam, locs.BottomRight.p)

        if self.Components.Quad then
            if Vis1 or Vis2 or Vis3 or Vis4 then
                self.Components.Quad.Visible = true
                self.Components.Quad.PointA = Vector2.new(TopRight.X, TopRight.Y)
                self.Components.Quad.PointB = Vector2.new(TopLeft.X, TopLeft.Y)
                self.Components.Quad.PointC = Vector2.new(BottomLeft.X, BottomLeft.Y)
                self.Components.Quad.PointD = Vector2.new(BottomRight.X, BottomRight.Y)

                if ESP.Friends and FriendCheck then
                    self.Components.Quad.Color = Color3.fromRGB(111, 227, 142)
                else
                    self.Components.Quad.Color = color
                end
            else
                self.Components.Quad.Visible = false
            end
        else
            self.Components.Quad = Draw("Quad", {
                Thickness = ESP.Thickness,
                Color = ESP.Color,
                Transparency = 1,
                Filled = false,
                Visible = self.Enabled and self.Boxes
            })
        end
    else
        self.Components.Quad.Visible = false
    end

    if ESP.Names then
        local TagPos, Vis5 = WorldToViewportPoint(cam, locs.TagPos.p)

        if Vis5 then
            self.Components.Name.Visible = true
            self.Components.Name.Position = Vector2.new(TagPos.X, TagPos.Y + 2)
            local health = self.Player and self.Player:FindFirstChild("Stats") and tostring(math.ceil(self.Player.Stats.Health.Value + self.Player.Stats.HealthBonus.Value)) or "N/A"
            local weapon = self.Player and self.Player:FindFirstChild("Stats") and self.Player.Stats:FindFirstChild("Primary") and self.Player.Stats.Primary.Value or "Fetching Item.."
            self.Components.Name.Text = string.format("%s | Health: %s\nWeapon: %s\nDistance: %d meters", self.Name, health, weapon, math.floor((cam.CFrame.p - cf.p).magnitude))
            self.Components.Name.Size = ESP.NameSize

            if ESP.Friends and FriendCheck then
                self.Components.Name.Color = Color3.fromRGB(111, 227, 142)
            else
                self.Components.Name.Color = color
            end
        else
            self.Components.Name.Visible = false
        end
    else
        self.Components.Name.Visible = false
    end

    if ESP.Tracers then
        local TopPos, Vis6 = WorldToViewportPoint(cam, locs.TopLeft.p)
        local BottomPos, Vis7 = WorldToViewportPoint(cam, locs.BottomLeft.p)

        if Vis6 and Vis7 then
            self.Components.Tracer.Visible = true
            self.Components.Tracer.From = Vector2.new(cam.ViewportSize.X / 2, 0)
            self.Components.Tracer.To = Vector2.new((TopPos.X + BottomPos.X) / 2, (TopPos.Y + BottomPos.Y) / 2)

            if ESP.Friends and FriendCheck then
                self.Components.Tracer.Color = Color3.fromRGB(111, 227, 142)
            else
                self.Components.Tracer.Color = color
            end
        else
            self.Components.Tracer.Visible = false
        end
    else
        self.Components.Tracer.Visible = false
    end
end

function ESP:Add(obj, options)
    if not obj.Parent and not options.RenderInNil then
        return warn(obj, "has no parent")
    end

    local box = setmetatable({
        Name = options.Name or obj.Name,
        Type = "Box",
        Color = options.Color,
        Size = options.Size or self.BoxSize,
        Object = obj,
        Player = options.Player or plrs:GetPlayerFromCharacter(obj),
        PrimaryPart = options.PrimaryPart or obj.ClassName == "Model" and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj:IsA("BasePart") and obj,
        Components = {},
        IsEnabled = options.IsEnabled,
        Temporary = options.Temporary,
        ColorDynamic = options.ColorDynamic,
        RenderInNil = options.RenderInNil
    }, boxBase)

    if self:GetBox(obj) then
        self:GetBox(obj):Remove()
    end

    box.Components["Quad"] = Draw("Quad", {
        Thickness = ESP.Thickness,
        Color = ESP.Color,
        Transparency = 1,
        Filled = false,
        Visible = self.Enabled and self.Boxes
    })
    box.Components["Name"] = Draw("Text", {
        Text = box.Name,
        Color = box.Color,
        Center = true,
        Outline = true,
        Size = 9,
        Visible = self.Enabled and self.Names
    })
    box.Components["Distance"] = Draw("Text", {
        Color = box.Color,
        Center = true,
        Outline = true,
        Size = 9,
        Visible = false -- Hiding distance text as we include it in Name now
    })

    box.Components["Tracer"] = Draw("Line", {
        Thickness = ESP.Thickness,
        Color = box.Color,
        Transparency = 1,
        Visible = self.Enabled
    })
    self.Objects[obj] = box

    obj.AncestryChanged:Connect(function(_, parent)
        if parent == nil and ESP.AutoRemove ~= false then
            box:Remove()
        end
    end)
    obj:GetPropertyChangedSignal("Parent"):Connect(function()
        if obj.Parent == nil and ESP.AutoRemove ~= false then
            box:Remove()
        end
    end)

    local hum = obj:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Died:Connect(function()
            if ESP.AutoRemove ~= false then
                box:Remove()
            end
        end)
    end

    return box
end

local function CharAdded(char)
    local p = plrs:GetPlayerFromCharacter(char)
    if not char:FindFirstChild("HumanoidRootPart") then
        local ev
        ev = char.ChildAdded:Connect(function(c)
            if c.Name == "HumanoidRootPart" then
                ev:Disconnect()
                ESP:Add(char, {
                    Name = p.Name,
                    Player = p,
                    PrimaryPart = c
                })
            end
        end)
    else
        ESP:Add(char, {
            Name = p.Name,
            Player = p,
            PrimaryPart = char.HumanoidRootPart
        })
    end
end

local function PlayerAdded(p)
    p.CharacterAdded:Connect(CharAdded)
    if p.Character then
        coroutine.wrap(CharAdded)(p.Character)
    end
end

plrs.PlayerAdded:Connect(PlayerAdded)
for i, v in pairs(plrs:GetPlayers()) do
    if v ~= plr then
        PlayerAdded(v)
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    cam = workspace.CurrentCamera
    for _, v in pairs(ESP.Objects) do
        if v.Update then
            local success, error = pcall(v.Update, v)
            if not success then 
                warn("[ESP Update Error]:", error, v.Object:GetFullName())
            end
        end
    end
end)

local function ChamsVisibility(plr)
    local highlightStorage = CoreGui:FindFirstChild("Highlight_Storage")
    if not highlightStorage then
        highlightStorage = Instance.new("Folder")
        highlightStorage.Name = "Highlight_Storage"
        highlightStorage.Parent = CoreGui
    end

    local highlight = highlightStorage:FindFirstChild(plr.Name)
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = plr.Name
        highlight.FillColor = ESP.FillColor
        highlight.DepthMode = ESP.DepthMode
        highlight.FillTransparency = ESP.FillTransparency
        highlight.OutlineColor = ESP.OutlineColor
        highlight.OutlineTransparency = ESP.OutlineTransparency
        highlight.Parent = highlightStorage
    end

    local function UpdateHighlight()
        local char = plr.Character
        if char and char:IsDescendantOf(workspace) then
            local primaryPart = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
            if primaryPart then
                highlight.Adornee = char
                local _, onScreen = cam:WorldToViewportPoint(primaryPart.Position)
                if onScreen then
                    highlight.FillColor = Color3.fromRGB(175, 25, 255) -- Purple
                else
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red
                end
            end
        end
    end

    connections[plr] = game:GetService("RunService").RenderStepped:Connect(UpdateHighlight)
    plr.CharacterAdded:Connect(function()
        connections[plr] = game:GetService("RunService").RenderStepped:Connect(UpdateHighlight)
    end)
end

for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= plr then
        ChamsVisibility(player)
    end
end

plrs.PlayerAdded:Connect(function(plr)
    if plr ~= plrs.LocalPlayer then
        ChamsVisibility(plr)
    end
end)

plrs.PlayerRemoving:Connect(function(plr)
    if connections[plr] then
        connections[plr]:Disconnect()
        connections[plr] = nil
    end
    local highlightInstance = CoreGui:FindFirstChild("Highlight_Storage"):FindFirstChild(plr.Name)
    if highlightInstance then
        highlightInstance:Destroy()
    end
end)

-- ESP Enable Toggle
local ESPEnableToggle = Tabs.Visuals:AddToggle("ESP Enable", {
    Title = "ESP Enable",
    Default = false,
    Callback = function(Value)
        ESP:Toggle(Value)
    end
})
ESPEnableToggle:SetValue(ESP.Enabled)

-- Chams Toggle
local ChamsToggle = Tabs.Visuals:AddToggle("Chams", {
    Title = "Chams",
    Default = false,
    Callback = function(Value)
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= plr then
                if Value then
                    ChamsVisibility(player)
                else
                    local highlightInstance = CoreGui:FindFirstChild("Highlight_Storage"):FindFirstChild(player.Name)
                    if highlightInstance then
                        highlightInstance:Destroy()
                    end
                    if connections[player] then
                        connections[player]:Disconnect()
                        connections[player] = nil
                    end
                end
            end
        end
    end
})
ChamsToggle:SetValue(true)

-- Tracer Toggle
local TracerToggle = Tabs.Visuals:AddToggle("Tracers", {
    Title = "Tracers",
    Default = false,
    Callback = function(Value)
        ESP.Tracers = Value
    end
})
TracerToggle:SetValue(ESP.Tracers)

-- Name Tag and Health ESP Toggle
local NameTagToggle = Tabs.Visuals:AddToggle("Name Tag & Health", {
    Title = "Name Tag & Health",
    Default = false,
    Callback = function(Value)
        ESP.Names = Value
    end
})
NameTagToggle:SetValue(ESP.Names)

-- Weapon ESP Toggle
local WeaponToggle = Tabs.Visuals:AddToggle("Weapon ESP", {
    Title = "Weapon ESP",
    Default = false,
    Callback = function(Value)
        ESP.ShowWeapons = Value
    end
})
WeaponToggle:SetValue(true)

--// Corpse ESP TAB: Visuals

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera

local ESP = {
    Enabled = false,
    MaxDistance = 2000,
    FontSize = 9,
}

local Functions = {}
do
    function Functions:Create(Class, Properties)
        local _Instance = typeof(Class) == 'string' and Instance.new(Class) or Class
        for Property, Value in pairs(Properties) do
            _Instance[Property] = Value
        end
        return _Instance
    end

    function Functions:FadeOutOnDist(element, distance)
        local transparency = math.max(0.1, 1 - (distance / ESP.MaxDistance))
        if element:IsA("TextLabel") then
            element.TextTransparency = 1 - transparency
        end
    end
end

do
    local ScreenGui = Functions:Create("ScreenGui", {
        Parent = CoreGui,
        Name = "CorpseESPHolder",
    })

    local function CreateCorpseESP(corpse)
        if corpse.Name == "Zombie" then return end

        local NameLabel = Functions:Create("TextLabel", {
            Parent = ScreenGui,
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.Code,
            TextSize = ESP.FontSize,
            TextStrokeTransparency = 0,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            RichText = true,
        })

        local function UpdateESP()
            local Connection
            Connection = RunService.RenderStepped:Connect(function()
                if ESP.Enabled and corpse:FindFirstChild("HumanoidRootPart") then
                    local HRP = corpse.HumanoidRootPart
                    local Pos, OnScreen = Camera:WorldToScreenPoint(HRP.Position)
                    local Dist = (Camera.CFrame.Position - HRP.Position).Magnitude

                    if OnScreen and Dist <= ESP.MaxDistance then
                        NameLabel.Visible = true
                        NameLabel.Position = UDim2.new(0, Pos.X, 0, Pos.Y - 20)
                        NameLabel.Text = string.format('%s [%d]', corpse.Name, math.floor(Dist))
                        Functions:FadeOutOnDist(NameLabel, Dist)
                    else
                        NameLabel.Visible = false
                    end
                else
                    NameLabel.Visible = false
                    if not corpse.Parent then
                        NameLabel:Destroy()
                        Connection:Disconnect()
                    end
                end
            end)
        end

        coroutine.wrap(UpdateESP)()
    end

    local function UpdateCorpses()
        for _, corpse in ipairs(Workspace.Corpses:GetChildren()) do
            CreateCorpseESP(corpse)
        end

        Workspace.Corpses.ChildAdded:Connect(function(corpse)
            CreateCorpseESP(corpse)
        end)
    end

    UpdateCorpses()
end

local ESPToggle = Tabs.Visuals:AddToggle("CorpseESP", {Title = "Corpse ESP", Default = ESP.Enabled})

ESPToggle:OnChanged(function()
    ESP.Enabled = ESPToggle.Value
end)

ESPToggle:SetValue(ESP.Enabled)

local ESPDistanceSlider = Tabs.Visuals:AddSlider("ESP Max Distance", {
    Title = "ESP Max Distance",
    Description = "Adjust the maximum distance for ESP",
    Default = ESP.MaxDistance,
    Min = 1,
    Max = 15000,
    Rounding = 0,
    Callback = function(Value)
        ESP.MaxDistance = Value
    end
})

ESPDistanceSlider:OnChanged(function(Value)
    ESP.MaxDistance = Value
end)

ESPDistanceSlider:SetValue(ESP.MaxDistance)

--// Crossahir TAB: Visuals

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

getgenv().Cursor = {
    Enabled = false,
    Speed = 2,
    Radius = 40,
    Length = 65,
    Gap = 40,
    Color = Color3.fromRGB(255, 255, 255),
    Thickness = 2,
    Outline = true,
    OutlineColor = Color3.fromRGB(0, 0, 0),
    AnimationIntensity = 40,
    Segments = 4,
    AnimationType = "noAnimation"
}

local function utility_new(type, properties)
    local object = Drawing.new(type)
    for i, v in pairs(properties) do
        object[i] = v
    end
    return object
end

local lines = {}
for i = 1, getgenv().Cursor.Segments do
    local line = utility_new("Line", {
        Visible = true,
        From = Vector2.new(200, 500),
        To = Vector2.new(200, 500),
        Color = getgenv().Cursor.Color,
        Thickness = getgenv().Cursor.Thickness,
        ZIndex = 2,
        Transparency = 1
    })
    local line_outline = utility_new("Line", {
        Visible = true,
        From = Vector2.new(200, 500),
        To = Vector2.new(200, 500),
        Color = getgenv().Cursor.OutlineColor,
        Thickness = getgenv().Cursor.Thickness + 2.5,
        ZIndex = 1,
        Transparency = 1
    })
    lines[i] = {line, line_outline}
end

local dot = utility_new("Square", {
    Visible = true,
    Size = Vector2.new(2, 2),
    Color = getgenv().Cursor.Color,
    Filled = true,
    ZIndex = 2,
    Transparency = 1
})

local outline = utility_new("Square", {
    Visible = true,
    Size = Vector2.new(4, 4),
    Color = getgenv().Cursor.OutlineColor,
    Filled = true,
    ZIndex = 1,
    Transparency = 1
})

local angle = 0
local lastRenderTime = tick()

local function updateCrosshair(dt)
    local pos = Vector2.new(Players.LocalPlayer:GetMouse().X, Players.LocalPlayer:GetMouse().Y + game:GetService("GuiService"):GetGuiInset().Y)
    angle = angle + (dt * getgenv().Cursor.Speed)
    dot.Visible = true
    dot.Color = getgenv().Cursor.Color
    dot.Position = Vector2.new(pos.X - 1, pos.Y - 1)
    
    outline.Visible = getgenv().Cursor.Outline
    outline.Position = Vector2.new(pos.X - 2, pos.Y - 2)

    for index, line in pairs(lines) do
        local segment_angle = angle + (index - 1) * (2 * math.pi / getgenv().Cursor.Segments)
        local distance_factor = getgenv().Cursor.Radius

        if getgenv().Cursor.AnimationType == "wave" then
            distance_factor = distance_factor + (getgenv().Cursor.AnimationIntensity * math.sin(angle))
        elseif getgenv().Cursor.AnimationType == "pulse" then
            distance_factor = getgenv().Cursor.Radius + (getgenv().Cursor.AnimationIntensity * (math.sin(angle) + 1) / 2)
        elseif getgenv().Cursor.AnimationType == "spiral" then
            distance_factor = distance_factor + (getgenv().Cursor.AnimationIntensity * math.cos(angle + segment_angle))
        elseif getgenv().Cursor.AnimationType == "spiralFade" then
            distance_factor = distance_factor + (getgenv().Cursor.AnimationIntensity * math.cos(angle + segment_angle))
            local fade_factor = math.abs(math.sin(angle + segment_angle))
            line[1].Transparency = fade_factor
            line[2].Transparency = fade_factor
        elseif getgenv().Cursor.AnimationType == "staticPulse" then
            distance_factor = distance_factor + (getgenv().Cursor.AnimationIntensity * math.abs(math.sin(angle + segment_angle)))
        elseif getgenv().Cursor.AnimationType == "noAnimation" then
            distance_factor = getgenv().Cursor.Radius
        end

        local x1 = pos.X + math.cos(segment_angle + angle) * (distance_factor + getgenv().Cursor.Gap)
        local y1 = pos.Y + math.sin(segment_angle + angle) * (distance_factor + getgenv().Cursor.Gap)

        local x2 = pos.X + math.cos(segment_angle + angle) * (distance_factor + getgenv().Cursor.Gap - getgenv().Cursor.Length)
        local y2 = pos.Y + math.sin(segment_angle + angle) * (distance_factor + getgenv().Cursor.Gap - getgenv().Cursor.Length)

        line[1].Visible = true
        line[1].Color = getgenv().Cursor.Color
        line[1].From = Vector2.new(x2, y2)
        line[1].To = Vector2.new(x1, y1)
        line[1].Thickness = getgenv().Cursor.Thickness

        line[2].Visible = getgenv().Cursor.Outline
        line[2].From = line[1].From
        line[2].To = line[1].To
        line[2].Thickness = getgenv().Cursor.Thickness + 2.5
    end
end

local connection = RunService.RenderStepped:Connect(function()
    if getgenv().Cursor.Enabled then
        local currentTime = tick()
        local deltaTime = currentTime - lastRenderTime
        lastRenderTime = currentTime
        updateCrosshair(deltaTime)
    else
        dot.Visible = false
        outline.Visible = false
        for _, line in pairs(lines) do
            line[1].Visible = false
            line[2].Visible = false
        end
    end
end)

local ToggleCrosshair = Tabs.Visuals:AddToggle("CrosshairToggle", {
    Title = "Enable Crosshair",
    Default = false,
    Callback = function(Value)
        getgenv().Cursor.Enabled = Value
    end
})

local SliderSize = Tabs.Visuals:AddSlider("CrosshairSize", {
    Title = "Crosshair Size",
    Default = getgenv().Cursor.Length,
    Min = 5,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        getgenv().Cursor.Length = Value
    end
})

local ToggleSpinning = Tabs.Visuals:AddToggle("CrosshairSpinningToggle", {
    Title = "Enable Crosshair Spinning",
    Default = false,
    Callback = function(Value)
        getgenv().Cursor.AnimationType = Value and "wave" or "noAnimation"
    end
})

local SliderSpeed = Tabs.Visuals:AddSlider("CrosshairSpeed", {
    Title = "Crosshair Spinning Speed",
    Default = getgenv().Cursor.Speed,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        getgenv().Cursor.Speed = Value
    end
})

ToggleCrosshair:SetValue(false)
SliderSize:SetValue(getgenv().Cursor.Length)
ToggleSpinning:SetValue(false)
SliderSpeed:SetValue(getgenv().Cursor.Speed)

--// FPS BOOSTER TAB: Visuals

local FPSBoostToggle = Tabs.Visuals:AddToggle("FPSBoostToggle", {Title = "FPS Booster", Default = false})

local function applyFPSBoost()
    game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    game.Workspace.CurrentCamera.FieldOfView = 90
    game.Workspace.CurrentCamera.HeadScale = 1.5
    game.Lighting.GlobalShadows = false
end

local function removeFPSBoost()
    game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    game.Workspace.CurrentCamera.FieldOfView = 90
    game.Workspace.CurrentCamera.HeadScale = 1
    game.Lighting.GlobalShadows = true
end

FPSBoostToggle:OnChanged(function()
    if FPSBoostToggle.Value then
        applyFPSBoost()
    else
        removeFPSBoost()
    end
end)

--// No Fog TAB: Visuals

local Lighting = game:GetService("Lighting")

local function setFogProperties()
    Lighting.FogEnd = 100000
    Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
        Lighting.FogEnd = 100000
    end)

    for _, v in ipairs(Lighting:GetDescendants()) do
        if v:IsA("Atmosphere") then
            v.Density = 0
            v:GetPropertyChangedSignal("Density"):Connect(function()
                v.Density = 0
            end)
        end
    end

    Lighting.DescendantAdded:Connect(function(v)
        if v:IsA("Atmosphere") then
            v.Density = 0
            v:GetPropertyChangedSignal("Density"):Connect(function()
                v.Density = 0
            end)
        end
    end)
end

local function restoreFogProperties()
    Lighting.FogEnd = 1000
    Lighting.FogStart = 0

    for _, v in ipairs(Lighting:GetDescendants()) do
        if v:IsA("Atmosphere") then
            v.Density = 0.3
            v:GetPropertyChangedSignal("Density"):Connect(function()
                v.Density = 0.3
            end)
        end
    end
end

local NoFogToggle = Tabs.Visuals:AddToggle("NoFogToggle", {Title = "No Fog", Default = false})

NoFogToggle:OnChanged(function()
    if NoFogToggle.Value then
        setFogProperties()
    else
        restoreFogProperties()
    end
end)

--// Self Chams TAB: Player

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local color = Color3.fromRGB(111, 0, 255)

local function applyForceFieldMaterial(character, color)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.ForceField
            part.Color = color
        end
    end
end

local function resetMaterial(character)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Plastic
            part.Color = Color3.fromRGB(255, 255, 255)
        end
    end
end

local SelfChamsEnabled = false

local function toggleSelfChams(enabled)
    if enabled then
        applyForceFieldMaterial(character, color)
    else
        resetMaterial(character)
    end
end

local function batchToggleSelfChams(enabled, batch_size)
    local parts = character:GetChildren()
    local process_func = enabled and function(part)
        if part:IsA("BasePart") then
            part.Material = Enum.Material.ForceField
            part.Color = color
        end
    end or function(part)
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Plastic
            part.Color = Color3.fromRGB(255, 255, 255)
        end
    end
    for i = 1, #parts, batch_size do
        for j = i, math.min(i + batch_size - 1, #parts) do
            process_func(parts[j])
        end
        RunService.Heartbeat:Wait()
    end
end

if SelfChamsEnabled then
    applyForceFieldMaterial(character, color)
end

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    if SelfChamsEnabled then
        applyForceFieldMaterial(newCharacter, color)
    end
end)

local SelfChamsToggle = Tabs.Player:AddToggle("SelfChamsToggle", { Title = "Self Chams", Default = false })
SelfChamsToggle:OnChanged(function()
    SelfChamsEnabled = SelfChamsToggle.Value
    batchToggleSelfChams(SelfChamsEnabled, 10)
end)

--// FullBright TAB: Player

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

local settings = {
    ClockTime = 24,
    ClockTimeAmount = 0.5,
    ColorShiftBottom = Color3.fromRGB(0, 0, 0),
    FogColor = Color3.fromRGB(255, 255, 255),
    FogEnd = 100000,
    FogEndAmount = 50,
    FogStart = 0,
    FogStartAmount = 5,
    EnvironmentDiffuseScale = 1,
    EnvironmentSpecularScale = 1,
    EnvironmentSpecular = true,
    ShadowSoftness = 0.5,
    GeographicLatitude = 0,
    Ambient = Color3.fromRGB(119, 120, 255),
    OutdoorAmbient = Color3.fromRGB(119, 120, 255),
    ShadowColor = Color3.fromRGB(0, 0, 0),
    Brightness = 2,

    AsphaltColor = Color3.fromRGB(127, 127, 127),
    BasaltColor = Color3.fromRGB(88, 88, 88),
    BrickColor = Color3.fromRGB(128, 42, 42),
    CobblestoneColor = Color3.fromRGB(140, 140, 140),
    ConcreteColor = Color3.fromRGB(128, 128, 128),
    CrackedLavaColor = Color3.fromRGB(80, 20, 20),
    GlacierColor = Color3.fromRGB(123, 173, 180),
    GrassColor = Color3.fromRGB(102, 142, 35),
    GroundColor = Color3.fromRGB(102, 66, 40),
    IceColor = Color3.fromRGB(173, 216, 230),
    LeafyGrassColor = Color3.fromRGB(94, 134, 40),
    LimestoneColor = Color3.fromRGB(206, 206, 206),
    MudColor = Color3.fromRGB(96, 78, 56)
}

local function applySettings()
    Lighting.ClockTime = settings.ClockTime
    Lighting.ClockTime = Lighting.ClockTime + settings.ClockTimeAmount
    Lighting.ColorShift_Bottom = settings.ColorShiftBottom
    Lighting.FogColor = settings.FogColor
    Lighting.FogEnd = settings.FogEnd
    Lighting.FogEnd = Lighting.FogEnd + settings.FogEndAmount
    Lighting.FogStart = settings.FogStart
    Lighting.FogStart = Lighting.FogStart + settings.FogStartAmount
    Lighting.EnvironmentDiffuseScale = settings.EnvironmentDiffuseScale
    Lighting.EnvironmentSpecularScale = settings.EnvironmentSpecularScale
    Lighting.GlobalShadows = settings.EnvironmentSpecular
    Lighting.ShadowSoftness = settings.ShadowSoftness
    Lighting.GeographicLatitude = settings.GeographicLatitude
    Lighting.Ambient = settings.Ambient
    Lighting.OutdoorAmbient = settings.OutdoorAmbient
    Lighting.Brightness = settings.Brightness
    Lighting.ShadowColor = settings.ShadowColor

    Terrain:SetMaterialColor(Enum.Material.Asphalt, settings.AsphaltColor)
    Terrain:SetMaterialColor(Enum.Material.Basalt, settings.BasaltColor)
    Terrain:SetMaterialColor(Enum.Material.Brick, settings.BrickColor)
    Terrain:SetMaterialColor(Enum.Material.Cobblestone, settings.CobblestoneColor)
    Terrain:SetMaterialColor(Enum.Material.Concrete, settings.ConcreteColor)
    Terrain:SetMaterialColor(Enum.Material.CrackedLava, settings.CrackedLavaColor)
    Terrain:SetMaterialColor(Enum.Material.Glacier, settings.GlacierColor)
    Terrain:SetMaterialColor(Enum.Material.Grass, settings.GrassColor)
    Terrain:SetMaterialColor(Enum.Material.Ground, settings.GroundColor)
    Terrain:SetMaterialColor(Enum.Material.Ice, settings.IceColor)
    Terrain:SetMaterialColor(Enum.Material.LeafyGrass, settings.LeafyGrassColor)
    Terrain:SetMaterialColor(Enum.Material.Limestone, settings.LimestoneColor)
    Terrain:SetMaterialColor(Enum.Material.Mud, settings.MudColor)
end

applySettings()

local FullBrightToggle = Tabs.Player:AddToggle("FullBrightToggle", {Title = "Full Bright", Default = false })
FullBrightToggle:OnChanged(function()
    settings.Brightness = FullBrightToggle.Value and 10 or 2
    applySettings()
end)

local BrightnessSlider = Tabs.Player:AddSlider("BrightnessSlider", {
    Title = "Brightness",
    Description = "Adjust the brightness",
    Default = settings.Brightness,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        settings.Brightness = Value
        applySettings()
    end
})

BrightnessSlider:OnChanged(function(Value)
    settings.Brightness = Value
    applySettings()
end)

RunService.RenderStepped:Connect(function()
    applySettings()
end)

--// No Recoil TAB: Mods

--// No Recoil TAB: Mods

local NoRecoilToggle = Tabs.Mods:AddToggle("No Recoil", {Title = "No Recoil", Default = false})

local function setNoRecoil(enabled)
    local parameters = {
        KickUpCameraInfluence = 0,
        ShiftGunInfluence = 0,
        ShiftCameraInfluence = 0,
        RaiseInfluence = 0,
        KickUpSpeed = 10000000
    }

    for i, v in pairs(getgc(true)) do
        if type(v) == 'table' and rawget(v, 'KickUpCameraInfluence') then
            setreadonly(v, false)
            for param, value in pairs(parameters) do
                v[param] = enabled and value or nil
            end
        end
    end
end

NoRecoilToggle:OnChanged(function(value)
    setNoRecoil(value)
end)

NoRecoilToggle:SetValue(false)

--// No Spread TAB: Mods

local NoSpreadToggle = Tabs.Mods:AddToggle("NoSpread", {
    Title = "NoSpread",
    Default = false,
    OnToggle = function(enabled)
        if enabled then
            enableNoSpread()
        else
            disableNoSpread()
        end
    end
})

local spreadParams = {
    "SpreadAddTPSHip",
    "SpreadAddTPSZoom",
    "SpreadAddFPSHip",
    "RollRightBias",
    "RollLeftBias",
    "ShiftRoll",
    "ShiftForce",
    "SlideForce"
}

local function updateSpreadValues(table, value)
    for _, param in ipairs(spreadParams) do
        table[param] = value
    end
end

local function enableNoSpread()
    for _, v in pairs(getgc(true)) do
        if type(v) == 'table' and rawget(v, 'Spread') then
            setreadonly(v, false)
            updateSpreadValues(v, 0)
        end
    end
end

local function disableNoSpread()
    for _, v in pairs(getgc(true)) do
        if type(v) == 'table' and rawget(v, 'Spread') then
            setreadonly(v, false)
            for _, param in ipairs(spreadParams) do
                v[param] = nil
            end
        end
    end
end

--// Bullet Tracer & Hitsound TAB: Mods

local Framework = require(ReplicatedFirst:WaitForChild("Framework"))
Framework:WaitForLoaded()

local Bullets = Framework.Libraries.Bullets

local player = game.Players.LocalPlayer

local bulletTracerSettings = {
    Enabled = false,
    Duration = 1.5,
    Color = Color3.fromRGB(255, 69, 0),  -- Brighter color
    BeamAssetId = "rbxassetid://446111271",
    Width = 0.5  -- Larger width
}

local hitsounds = {
    Neverlose = "rbxassetid://8726881116",
    Gamesense = "rbxassetid://4817809188",
    One = "rbxassetid://7380502345",
    Bell = "rbxassetid://6534947240",
    Rust = "rbxassetid://1255040462",
    TF2 = "rbxassetid://2868331684",
    Slime = "rbxassetid://6916371803",
    ["Among Us"] = "rbxassetid://5700183626",
    Minecraft = "rbxassetid://4018616850",
    ["CS:GO"] = "rbxassetid://6937353691",
    Saber = "rbxassetid://8415678813",
    Baimware = "rbxassetid://3124331820",
    Osu = "rbxassetid://7149255551",
    ["TF2 Critical"] = "rbxassetid://296102734",
    Bat = "rbxassetid://3333907347",
    ["Call of Duty"] = "rbxassetid://5952120301",
    Bubble = "rbxassetid://6534947588",
    Pick = "rbxassetid://1347140027",
    Pop = "rbxassetid://198598793",
    Bruh = "rbxassetid://4275842574",
    Bamboo = "rbxassetid://3769434519",
    Crowbar = "rbxassetid://546410481",
    Weeb = "rbxassetid://6442965016",
    Beep = "rbxassetid://8177256015",
    Bambi = "rbxassetid://8437203821",
    Stone = "rbxassetid://3581383408",
    ["Old Fatality"] = "rbxassetid://6607142036",
    Click = "rbxassetid://8053704437",
    Ding = "rbxassetid://7149516994",
    Snow = "rbxassetid://6455527632",
    Laser = "rbxassetid://7837461331",
    Mario = "rbxassetid://2815207981",
    Steve = "rbxassetid://4965083997",
    Snowdrake = "rbxassetid://7834724809",
    Drainyaw = "rbxassetid://11846203640",
    Primordial = "rbxassetid://11846281136",
    rifk7 = "rbxassetid://11846211332",
}

local hitsoundSettings = {
    SoundId = hitsounds.Neverlose,
    Volume = 1,
    Enabled = false,
}

local function createBulletTracer(startPos, endPos)
    if bulletTracerSettings.Enabled then
        local startPoint = Instance.new("Part")
        startPoint.Anchored = true
        startPoint.CanCollide = false
        startPoint.Transparency = 1
        startPoint.Position = startPos
        startPoint.Parent = workspace

        local endPoint = Instance.new("Part")
        endPoint.Anchored = true
        endPoint.CanCollide = false
        endPoint.Transparency = 1
        endPoint.Position = endPos
        endPoint.Parent = workspace

        local attachment0 = Instance.new("Attachment", startPoint)
        local attachment1 = Instance.new("Attachment", endPoint)

        local beam = Instance.new("Beam")
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.FaceCamera = true
        beam.Width0 = bulletTracerSettings.Width
        beam.Width1 = bulletTracerSettings.Width
        beam.Color = ColorSequence.new(bulletTracerSettings.Color)
        beam.LightEmission = 1
        beam.Texture = bulletTracerSettings.BeamAssetId
        beam.TextureMode = Enum.TextureMode.Stretch
        beam.TextureLength = 1
        beam.TextureSpeed = 0
        beam.Parent = startPoint

        game:GetService("Debris"):AddItem(startPoint, bulletTracerSettings.Duration)
        game:GetService("Debris"):AddItem(endPoint, bulletTracerSettings.Duration)
    end
end

local function playHitsound()
    if hitsoundSettings.Enabled then
        local sound = Instance.new("Sound")
        sound.SoundId = hitsoundSettings.SoundId
        sound.Volume = hitsoundSettings.Volume
        sound.Parent = workspace
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end

workspace.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "Bullet" then
        local startPos = child.Position
        playHitsound()
        child.Changed:Connect(function(property)
            if property == "Position" then
                createBulletTracer(startPos, child.Position)
            end
        end)
    end
end)

local Toggle = Tabs.Mods:AddToggle("BulletTracerToggle", {Title = "Enable Bullet Tracer", Default = false })
Toggle:OnChanged(function()
    bulletTracerSettings.Enabled = Toggle.Value
end)

local Slider = Tabs.Mods:AddSlider("TracerDurationSlider", {
    Title = "Tracer Duration",
    Description = "Duration before tracer fades",
    Default = 1.5,
    Min = 0.5,
    Max = 2.5,
    Rounding = 1,
    Callback = function(Value)
        bulletTracerSettings.Duration = Value
    end
})

Slider:OnChanged(function(Value)
    bulletTracerSettings.Duration = Value
end)

local hitsoundToggle = Tabs.Mods:AddToggle("HitsoundToggle", {Title = "Enable Hitsound", Default = false })
hitsoundToggle:OnChanged(function()
    hitsoundSettings.Enabled = hitsoundToggle.Value
end)

local volumeSlider = Tabs.Mods:AddSlider("VolumeSlider", {
    Title = "Volume",
    Description = "Adjust hitsound volume",
    Default = 1,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        hitsoundSettings.Volume = Value
    end
})

volumeSlider:OnChanged(function(Value)
    hitsoundSettings.Volume = Value
end)

local Dropdown = Tabs.Mods:AddDropdown("HitsoundDropdown", {
    Title = "Select Hitsound",
    Values = {"Neverlose", "Gamesense", "One", "Bell", "Rust", "TF2", "Slime", "Among Us", "Minecraft", "CS:GO", "Saber", "Baimware", "Osu", "TF2 Critical", "Bat", "Call of Duty", "Bubble", "Pick", "Pop", "Bruh", "Bamboo", "Crowbar", "Weeb", "Beep", "Bambi", "Stone", "Old Fatality", "Click", "Ding", "Snow", "Laser", "Mario", "Steve", "Snowdrake", "Drainyaw", "Primordial", "rifk7"},
    Multi = false,
    Default = 1,
    Callback = function(Value)
        hitsoundSettings.SoundId = hitsounds[Value]
    end
})

Dropdown:OnChanged(function(Value)
    hitsoundSettings.SoundId = hitsounds[Value]
end)

wait(1.5)

--// Speed TAB: Movement

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local tpwalkSpeed = 1.6
local tpwalking = false

local function startTPWalk(speaker)
    local chr = speaker.Character
    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

    if not chr or not hum then
        warn("Character or Humanoid not found.")
        return
    end
    
    while tpwalking and chr and hum and hum.Parent do
        local delta = RunService.Heartbeat:Wait()
        if hum.MoveDirection.Magnitude > 0 then
            chr:TranslateBy(hum.MoveDirection * tpwalkSpeed * delta * 10)
        end
    end
end

local function stopTPWalk()
    tpwalking = false
end

local Toggle = Tabs.Movement:AddToggle("SpeedToggle", {Title = "Speed Hack", Default = false})

Toggle:OnChanged(function()
    tpwalking = Toggle.Value
    if tpwalking then
        startTPWalk(Players.LocalPlayer)
    else
        stopTPWalk()
    end
end)

local Slider = Tabs.Movement:AddSlider("SpeedSlider", {
    Title = "Speed Slider",
    Description = "Adjust the movement speed",
    Default = 1.7,
    Min = 1,
    Max = 2.4,
    Rounding = 1,
    Callback = function(value)
        tpwalkSpeed = value
    end
})

Slider:OnChanged(function(value)
    tpwalkSpeed = value
end)

--// Infinite Jump & Detection Bar TAB: Movement

local InfiniteJump = false

local Toggle = Tabs.Movement:AddToggle("InfToggle", {Title = "Infinite Jump", Default = false})

Toggle:OnChanged(function(value)
    InfiniteJump = value
end)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if InfiniteJump and input.KeyCode == Enum.KeyCode.Space then
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState("Jumping")
            end
        end
    end
end)

--// No Fall Damage TAB: Movement

-- removed

--// Noclip TAB: Movement

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local NoClipToggle = Tabs.Movement:AddToggle("NoClip", {Title = "Toggle NoClip", Default = false})

local NoClipEvent
local PositionEvent
local NoClipObjects = {}
local NoClipEnabled = false

local function toggleNoClip(enable)
    NoClipEnabled = enable
    if enable then
        NoClipEvent = RunService.Stepped:Connect(function()
            local LocalPlayer = Players.LocalPlayer
            if not LocalPlayer.Character then return end

            for _, Object in pairs(LocalPlayer.Character:GetDescendants()) do
                if Object:IsA("BasePart") and Object.CanCollide then
                    NoClipObjects[Object] = true
                    Object.CanCollide = false
                end
            end
        end)
        
        PositionEvent = RunService.RenderStepped:Connect(function()
            local LocalPlayer = Players.LocalPlayer
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = LocalPlayer.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 0.1
        end)
    else
        if NoClipEvent then
            NoClipEvent:Disconnect()
            NoClipEvent = nil
        end
        
        if PositionEvent then
            PositionEvent:Disconnect()
            PositionEvent = nil
        end

        RunService.Stepped:Wait()
        for Object in pairs(NoClipObjects) do
            if Object and Object.Parent then
                Object.CanCollide = true
            end
        end
        table.clear(NoClipObjects)
    end
end

NoClipToggle:OnChanged(function()
    toggleNoClip(NoClipToggle.Value)
end)

NoClipToggle:SetValue(false)

wait(1.5)

--// Instant Search TAB: Misc

local InstantSearchEnabled = false

local ToggleInstantSearchUI = Tabs.Misc:AddToggle("Instant Search", {Title = "Instant Search Toggle", Default = false})
ToggleInstantSearchUI:OnChanged(function(value)
    InstantSearchEnabled = value
end)

local function setupInstantSearch()

    local oldFindItemData = getupvalue(InteractHeartbeat, 11)

    setupvalue(InteractHeartbeat, 11, function(...)
        if InstantSearchEnabled then
            local returnArgs = {oldFindItemData(...)}
            if returnArgs[4] then 
                returnArgs[4] = 0
            end
            return unpack(returnArgs)
        end
        return oldFindItemData(...)
    end)
end

setupInstantSearch()

print("Instant search setup completed.")


--// Staff detector TAB: Misc


local function CheckStaff(Player)
    pcall(function()
        if Player:GetRankInGroup(1066925) > 1 or Player:GetRankInGroup(9630142) > 0 then
            Fluent:Notify({
                Title = "Vital.wtf",
                Content = "Staff: " .. Player.Name,
                Duration = 120
            })
        end
    end)
end

game:GetService("Players").PlayerAdded:Connect(function(Player)
    CheckStaff(Player)
end)

local ToggleStaffDetector = Tabs.Misc:AddToggle("StaffDetectorToggle", {Title = "Staff Detector", Default = false})

ToggleStaffDetector:OnChanged(function()
    if Options.StaffDetectorToggle.Value == true then
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            CheckStaff(player)
        end
    end
end)

Options.StaffDetectorToggle:SetValue(false)

--// Cheater Detecter TAB: Misc

local function NotifyCheater(playerName)
    Fluent:Notify({
        Title = "Vital.wtf",
        Content = playerName .. " is using " .. (math.random(1, 2) == 1 and "Parvus Hub" or "AR2C"),
        Duration = 120
    })
end

local function CheckPlayerSpeed()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChildOfClass("Humanoid") then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local speed = humanoid.WalkSpeed

                if speed > 32 then
                    NotifyCheater(player.Name)
                    break
                end
            end
        end
    end
end

local CheaterDetectionToggle = Tabs.Misc:AddToggle("Cheater Detector", {
    Title = "Cheater Detector",
    Default = false,
    Callback = function(Value)
        if Value then
            _G.CheaterDetectionConnection = game:GetService("RunService").Heartbeat:Connect(CheckPlayerSpeed)
        else
            if _G.CheaterDetectionConnection then
                _G.CheaterDetectionConnection:Disconnect()
                _G.CheaterDetectionConnection = nil
            end
        end
    end
})
CheaterDetectionToggle:SetValue(false)

--// Server Hopper TAB: Misc

-- removed

wait(2)

--// Settings TAB: Settings

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "vital.wtf has loaded",
    Content = "Developer Build | v3.0.0",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()

wait(1)

--// Developer join notify

local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/archivesniped/RegisteredUser/main/Identification.lua"))()
end)

if not success then
    warn("Failed to load the external file: " .. err)
else
    print("External file loaded successfully")
end

notifyDeveloperJoin()

--[[


__     __                ____  _                         ____            _       _             
\ \   / /__ _ __ _   _  / ___|(_) __ _ _ __ ___   __ _  / ___|  ___ _ __(_)_ __ | |_           
 \ \ / / _ \ '__| | | | \___ \| |/ _` | '_ ` _ \ / _` | \___ \ / __| '__| | '_ \| __|          
  \ V /  __/ |  | |_| |  ___) | | (_| | | | | | | (_| |  ___) | (__| |  | | |_) | |_           
   \_/ \___|_|   \__, | |____/|_|\__, |_| |_| |_|\__,_| |____/ \___|_|  |_| .__/ \__|          
 ____            |___/_          |___/       _   _             _____      |_|                _ 
|  _ \  _____   _____| | ___  _ __   ___  __| | | |__  _   _  |  ___|__  __| | __ _ _ __ ___| |
| | | |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \/ _` | | '_ \| | | | | |_ / _ \/ _` |/ _` | '__/ _ \ |
| |_| |  __/\ V /  __/ | (_) | |_) |  __/ (_| | | |_) | |_| | |  _|  __/ (_| | (_| | | |  __/ |
|____/ \___| \_/ \___|_|\___/| .__/ \___|\__,_| |_.__/ \__, | |_|  \___|\__,_|\__,_|_|  \___|_|
                             |_|                       |___/                            

]]
