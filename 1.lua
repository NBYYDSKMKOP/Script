-- 第一个脚本 (1-899行)
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "1.HUBKM Dit it",
    Footer = "这么长时间其实我就一个都没做 就花了几分钟给你缝合了哈哈 25r还想要啥 这么久你以为我做了很久 其实只有几分",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("主要功能", "user"),
    Plotki = Window:AddTab("玩家功能", "user"),
    UISettings = Window:AddTab("UI设置", "settings")
}

local AutoLoops = {
    BuyEgg = nil,
    BuyShovels = nil,
    BuyEvents = nil,
    SellAll = nil,
    SellHolding = nil,
    WithdrawPets = nil,
    LevelPets = nil,
    MiningMinigame = nil,
    Mining = nil
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("自动购买", "boxes")

LeftGroupBox:AddToggle("AutoBuyEgg", {
    Text = "自动购买蛋",
    Tooltip = "自动购买基础蛋",
    Default = false,
    Callback = function(Value)
        if Value then
            AutoLoops.BuyEgg = task.spawn(function()
                while Toggles.AutoBuyEgg.Value do
                    local args = {"Basic Egg"}
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("TryToBuyEgg"):FireServer(unpack(args))
                    end)
                    task.wait(1)
                end
            end)
        else
            if AutoLoops.BuyEgg then
                task.cancel(AutoLoops.BuyEgg)
                AutoLoops.BuyEgg = nil
            end
        end
    end
})

LeftGroupBox:AddToggle("AutoBuyShovels", {
    Text = "自动购买铲子",
    Tooltip = "自动购买所有铲子",
    Default = false,
    Callback = function(Value)
        if Value then
            AutoLoops.BuyShovels = task.spawn(function()
                while Toggles.AutoBuyShovels.Value do
                    local foundShovels = {}
                    local function searchForShovels(parent)
                        for _, child in pairs(parent:GetChildren()) do
                            if not Toggles.AutoBuyShovels.Value then break end
                            local name = child.Name:lower()
                            local shovelKeywords = {
                                "shovel", "spade", "dig", "excavate", "挖", "铲"
                            }
                            for _, keyword in ipairs(shovelKeywords) do
                                if name:find(keyword) and not table.find(foundShovels, child.Name) then
                                    table.insert(foundShovels, child.Name)
                                    break
                                end
                            end
                            if #child:GetChildren() > 0 then
                                searchForShovels(child)
                            end
                        end
                    end
                    searchForShovels(workspace)
                    searchForShovels(game:GetService("ReplicatedStorage"))
                    searchForShovels(game:GetService("ServerStorage"))
                    local guiService = game:GetService("GuiService")
                    for _, screenGui in pairs(workspace:FindFirstChildWhichIsA("PlayerGui") or {}):GetDescendants() do
                        if screenGui:IsA("TextLabel") or screenGui:IsA("TextButton") then
                            local text = screenGui.Text:lower()
                            if text:find("shovel") and not table.find(foundShovels, screenGui.Text) then
                                table.insert(foundShovels, screenGui.Text)
                            end
                        end
                    end
                    if #foundShovels > 0 then
                    end
                    local shop = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteFunctions")
                    if shop then
                        shop = shop:FindFirstChild("Shop")
                    end
                    if shop then
                        for _, shovel in ipairs(foundShovels) do
                            if not Toggles.AutoBuyShovels.Value then break end
                            pcall(function()
                                local args = {{Command = "Purchase", Product = shovel}}
                                local result = shop:InvokeServer(unpack(args))
                                if result and result.Success then
                                end
                            end)
                            task.wait(0.3)
                        end
                    else
                    end
                    task.wait(5)
                end
            end)
        else
            if AutoLoops.BuyShovels then
                task.cancel(AutoLoops.BuyShovels)
                AutoLoops.BuyShovels = nil
            end
        end
    end
})

local RightGroupBox = Tabs.Main:AddRightGroupbox("刷钱[全部开启]一局游戏一次", "boxes")

RightGroupBox:AddToggle("AutoSellAll", {
    Text = "自动出售仓库",
    Tooltip = "自动出售所有宝藏",
    Default = false,
    Callback = function(Value)
        if Value then
            AutoLoops.SellAll = task.spawn(function()
                while Toggles.AutoSellAll.Value do
                    local FUNCTION_NAME = "Sell inventory success"
                    local function executeSellInventorySuccessFunctions()
                        local allObjects = workspace:GetDescendants()
                        for _, obj in ipairs(allObjects) do
                            if obj:IsA("ModuleScript") and obj.Name == FUNCTION_NAME then
                                local success, module = pcall(function()
                                    return require(obj)
                                end)
                                if success and type(module) == "function" then
                                    local executeSuccess, errorMsg = pcall(module)
                                end
                            elseif obj:IsA("BindableFunction") and obj.Name == FUNCTION_NAME then
                                local executeSuccess, errorMsg = pcall(function()
                                    obj:Invoke()
                                end)
                            elseif obj:IsA("BindableEvent") and obj.Name == FUNCTION_NAME then
                                local executeSuccess, errorMsg = pcall(function()
                                    obj:Fire()
                                end)
                            elseif obj:IsA("Script") and obj.Name == FUNCTION_NAME and obj:IsA("LocalScript") == false then
                                local executeSuccess, errorMsg = pcall(function()
                                    local scriptClone = obj:Clone()
                                    scriptClone.Parent = workspace
                                    scriptClone.Disabled = false
                                    task.wait(0.1)
                                    scriptClone:Destroy()
                                end)
                            end
                        end
                    end
                    executeSellInventorySuccessFunctions()
                    task.wait(5)
                end
            end)
        else
            if AutoLoops.SellAll then
                task.cancel(AutoLoops.SellAll)
                AutoLoops.SellAll = nil
            end
        end
    end
})

RightGroupBox:AddToggle("AutoMiningMinigame", {
    Text = "自动收集所有僵尸",
    Tooltip = "自动挖矿",
    Default = false,
    Callback = function(Value)
        if Value then
            AutoLoops.MiningMinigame = task.spawn(function()
                while Toggles.AutoMiningMinigame.Value do
                    local RunService = game:GetService("RunService")
                    local UserInputService = game:GetService("UserInputService")
                    local Players = game:GetService("Players")
                    local LocalPlayer = Players.LocalPlayer
                    local config = {
                        checkInterval = 0.1,
                        clickDelay = 0.05,
                        doubleClickDelay = 0.08,
                        clickCount = 2,
                        detectionArea = {
                            x = 0.3,
                            y = 0.2,
                            width = 0.4,
                            height = 0.6
                        }
                    }
                    local targetColors = {
                        Color3.fromRGB(255, 100, 100),
                        Color3.fromRGB(100, 255, 100),
                        Color3.fromRGB(100, 100, 255),
                        Color3.fromRGB(255, 255, 100),
                        Color3.fromRGB(200, 100, 255),
                        Color3.fromRGB(100, 255, 255),
                        Color3.fromRGB(255, 150, 50),
                    }
                    local ignoreColors = {
                        Color3.fromRGB(120, 180, 120),
                        Color3.fromRGB(100, 150, 255),
                        Color3.fromRGB(150, 100, 50),
                        Color3.fromRGB(180, 180, 180),
                    }
                    local isRunning = true
                    local connection = nil
                    local lastClickTime = 0
                    local targetFound = false
                    local consecutiveMissCount = 0
                    local maxConsecutiveMiss = 3
                    local function isColorSimilar(color1, color2, threshold)
                        local rDiff = math.abs(color1.R * 255 - color2.R * 255)
                        local gDiff = math.abs(color1.G * 255 - color2.G * 255)
                        local bDiff = math.abs(color1.B * 255 - color2.B * 255)
                        return (rDiff + gDiff + bDiff) / 3 < 20
                    end
                    local function shouldIgnoreColor(color)
                        for _, ignoreColor in ipairs(ignoreColors) do
                            if isColorSimilar(color, ignoreColor, 25) then
                                return true
                            end
                        end
                        return false
                    end
                    local function findTargetBlocks()
                        local targets = {}
                        local camera = workspace.CurrentCamera
                        local viewportSize = camera.ViewportSize
                        local startX = viewportSize.X * config.detectionArea.x
                        local startY = viewportSize.Y * config.detectionArea.y
                        local endX = startX + (viewportSize.X * config.detectionArea.width)
                        local endY = startY + (viewportSize.Y * config.detectionArea.height)
                        local gridSize = 8
                        local stepX = (endX - startX) / gridSize
                        local stepY = (endY - startY) / gridSize
                        for i = 0, gridSize - 1 do
                            for j = 0, gridSize - 1 do
                                local screenX = startX + (i * stepX) + (stepX / 2)
                                local screenY = startY + (j * stepY) + (stepY / 2)
                                local ray = camera:ViewportPointToRay(screenX, screenY)
                                local raycastResult = workspace:Raycast(
                                    ray.Origin,
                                    ray.Direction * 500,
                                    RaycastParams.new()
                                )
                                if raycastResult then
                                    local part = raycastResult.Instance
                                    if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
                                        local partColor = part.Color
                                        if not shouldIgnoreColor(partColor) then
                                            for _, targetColor in ipairs(targetColors) do
                                                if isColorSimilar(partColor, targetColor, 25) then
                                                    table.insert(targets, {
                                                        position = Vector2.new(screenX, screenY),
                                                        part = part,
                                                        color = partColor
                                                    })
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        return targets
                    end
                    local function performClick(position)
                        UserInputService:SetMouseLocation(position.X, position.Y)
                        local mouseButton1 = Enum.UserInputType.MouseButton1
                        pcall(function()
                            UserInputService.InputBegan:Fire({
                                UserInputType = mouseButton1,
                                KeyCode = Enum.KeyCode.Unknown,
                                Position = UserInputService:GetMouseLocation()
                            })
                        end)
                        wait(0.01)
                        pcall(function()
                            UserInputService.InputEnded:Fire({
                                UserInputType = mouseButton1,
                                KeyCode = Enum.KeyCode.Unknown,
                                Position = UserInputService:GetMouseLocation()
                            })
                        end)
                        lastClickTime = tick()
                        return true
                    end
                    local function performDoubleClick(position)
                        local mouseButton1 = Enum.UserInputType.MouseButton1
                        pcall(function()
                            UserInputService.InputBegan:Fire({
                                UserInputType = mouseButton1,
                                KeyCode = Enum.KeyCode.Unknown,
                                Position = position
                            })
                        end)
                        wait(config.doubleClickDelay)
                        pcall(function()
                            UserInputService.InputEnded:Fire({
                                UserInputType = mouseButton1,
                                KeyCode = Enum.KeyCode.Unknown,
                                Position = position
                            })
                        end)
                        pcall(function()
                            UserInputService.InputBegan:Fire({
                                UserInputType = mouseButton1,
                                KeyCode = Enum.KeyCode.Unknown,
                                Position = position
                            })
                        end)
                        wait(0.01)
                        pcall(function()
                            UserInputService.InputEnded:Fire({
                                UserInputType = mouseButton1,
                                KeyCode = Enum.KeyCode.Unknown,
                                Position = position
                            })
                        end)
                        lastClickTime = tick()
                        return true
                    end
                    local function mainLoop()
                        while isRunning do
                            local targets = findTargetBlocks()
                            if #targets > 0 then
                                consecutiveMissCount = 0
                                if not targetFound then
                                    targetFound = true
                                end
                                for _, target in ipairs(targets) do
                                    if isRunning then
                                        performDoubleClick(target.position)
                                        wait(config.clickDelay)
                                    else
                                        break
                                    end
                                end
                            else
                                consecutiveMissCount = consecutiveMissCount + 1
                                if targetFound and consecutiveMissCount >= maxConsecutiveMiss then
                                    targetFound = false
                                end
                            end
                            wait(config.checkInterval)
                        end
                    end
                    spawn(mainLoop)
                    task.wait(0.1)
                end
            end)
        else
            if AutoLoops.MiningMinigame then
                task.cancel(AutoLoops.MiningMinigame)
                AutoLoops.MiningMinigame = nil
            end
        end
    end
})

RightGroupBox:AddToggle("AutoWithdrawPets", {
    Text = "自动挖矿[需要在土地上]",
    Tooltip = "自动从宠物仓库提取",
    Default = false,
    Callback = function(Value)
        if Value then
            AutoLoops.WithdrawPets = task.spawn(function()
                while Toggles.AutoWithdrawPets.Value do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("WithdrawFromPet"):FireServer()
                    end)
                    task.wait(1)
                end
            end)
        else
            if AutoLoops.WithdrawPets then
                task.cancel(AutoLoops.WithdrawPets)
                AutoLoops.WithdrawPets = nil
            end
        end
    end
})

RightGroupBox:AddToggle("AutoLevelPets", {
    Text = "自动升级宠物",
    Tooltip = "自动升级宠物",
    Default = false,
    Callback = function(Value)
        if Value then
            AutoLoops.LevelPets = task.spawn(function()
                while Toggles.AutoLevelPets.Value do
                    pcall(function()
                        local args = {"f9f4fad4af"}
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("TryToLevelUpPet"):FireServer(unpack(args))
                    end)
                    task.wait(0.5)
                end
            end)
        else
            if AutoLoops.LevelPets then
                task.cancel(AutoLoops.LevelPets)
                AutoLoops.LevelPets = nil
            end
        end
    end
})


MiningGroupBox:AddToggle("AutoMining", {
    Text = "启用配置",
    Tooltip = "自动挖矿",
    Default = false,
    Callback = function(Value)
        if Value then
            AutoLoops.Mining = task.spawn(function()
                while Toggles.AutoMining.Value do
                    local Players = game:GetService("Players")
                    local player = Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local humanoid = character:WaitForChild("Humanoid")
                    local rootPart = character:WaitForChild("HumanoidRootPart")
                    local function getTargetObjects()
                        local targets = {}
                        local ronksFolder = workspace:FindFirstChild("_Ronks")
                        if ronksFolder then
                            for _, obj in ipairs(ronksFolder:GetChildren()) do
                                if obj:IsA("BasePart") then
                                    table.insert(targets, obj)
                                elseif obj:IsA("Model") and obj.PrimaryPart then
                                    table.insert(targets, obj.PrimaryPart)
                                end
                            end
                        end
                        local effectsFolder = workspace:FindFirstChild("_Effects")
                        if effectsFolder then
                            local effectsChildren = effectsFolder:GetChildren()
                            if #effectsChildren >= 10 then
                                local tenthEffect = effectsChildren[10]
                                if tenthEffect:IsA("BasePart") then
                                    table.insert(targets, tenthEffect)
                                elseif tenthEffect:IsA("Model") and tenthEffect.PrimaryPart then
                                    table.insert(targets, tenthEffect.PrimaryPart)
                                end
                            end
                        end
                        return targets
                    end
                    spawn(function()
                        while wait(0.1) do
                            if not character or not character:IsDescendantOf(workspace) or humanoid.Health <= 0 then
                                character = player.Character or player.CharacterAdded:Wait()
                                humanoid = character:WaitForChild("Humanoid")
                                rootPart = character:WaitForChild("HumanoidRootPart")
                            end
                            local targets = getTargetObjects()
                            for _, target in ipairs(targets) do
                                if target and target.Parent then
                                    local success, err = pcall(function()
                                        rootPart.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
                                    end)
                                    if not success then
                                    end
                                    wait(0.1)
                                end
                            end
                        end
                    end)
                    spawn(function()
                        while wait(0.5) do
                            if not character or humanoid.Health <= 0 then
                                repeat wait() until character and humanoid.Health > 0
                            end
                            local vim = game:GetService("VirtualInputManager")
                            local camera = workspace.CurrentCamera
                            local viewport = camera.ViewportSize
                            local centerX = viewport.X / 2
                            local centerY = viewport.Y / 2
                            pcall(function()
                                vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                                wait(0.05)
                                vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                            end)
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            if AutoLoops.Mining then
                task.cancel(AutoLoops.Mining)
                AutoLoops.Mining = nil
            end
        end
    end
})

local ExtraGroupBox = Tabs.Main:AddRightGroupbox("其他功能", "boxes", 2)

ExtraGroupBox:AddButton({
    Text = "停止所有功能",
    Func = function()
        for toggleName, loop in pairs(AutoLoops) do
            if loop then
                task.cancel(loop)
                AutoLoops[toggleName] = nil
            end
        end
        for _, toggle in pairs(Toggles) do
            if toggle then
                toggle:SetValue(false)
            end
        end
        Library:Notify("所有自动功能已停止", 3)
    end,
    DoubleClick = false
})

local PlayerGroupBox = Tabs.Plotki:AddLeftGroupbox("移动", "boxes")

local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

getgenv().TpwalkSpeed = 10
getgenv().TpwalkEnabled = false

PlayerGroupBox:AddToggle("Speed", {
    Text = "快速冲刺",
    Tooltip = "按住移动键快速冲刺",
    Default = false,
    Callback = function(state)
        getgenv().TpwalkEnabled = state
    end
})

PlayerGroupBox:AddSlider("SpeedValue", {
    Text = "冲刺速度",
    Tooltip = "设置冲刺速度",
    Default = 10,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        getgenv().TpwalkSpeed = value
    end
})

RunService.Heartbeat:Connect(function(delta)
    if getgenv().TpwalkEnabled and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if hrp and hum then
            local dir = hum.MoveDirection
            if dir.Magnitude > 0 then
                local newPos = hrp.Position + dir.Unit * getgenv().TpwalkSpeed * delta
                hrp.CFrame = CFrame.new(newPos, newPos + hrp.CFrame.LookVector)
            end
        end
    end
end)

local TeleportGroupBox = Tabs.Plotki:AddLeftGroupbox("传送", "boxes", 2)

local teleportLocations = {
    ["Volkayno"] = "workspace.LODModels.Volkayno",
    ["Nookville"] = "workspace.LODModels.Nookville",
    ["Relica"] = "workspace.LODModels.Relica",
    ["Piratesburg"] = "workspace.LODModels.Piratesburg",
    ["Permafrost"] = "workspace.LODModels.Permafrost",
    ["Jurassic Island"] = "workspace.LODModels.Jurassic Island",
    ["Badlands"] = "workspace.LODModels.Badlands"
}

local SelectedTeleportLocation = nil

local function teleportToLocation(locationName)
    local path = teleportLocations[locationName]
    if not path then
        Library:Notify("传送位置不存在: " .. locationName, 3)
        return
    end
    local parts = {}
    for part in path:gmatch("[^.]+") do
        table.insert(parts, part)
    end
    local targetModel = workspace
    for i = 2, #parts do
        if targetModel then
            if parts[i] == "Jurassic Island" then
                targetModel = targetModel:FindFirstChild("LODModels")
                if targetModel then
                    targetModel = targetModel:FindFirstChild("Jurassic Island")
                end
            else
                targetModel = targetModel:FindFirstChild(parts[i])
            end
        end
    end
    if targetModel and targetModel:IsA("Model") then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local targetCFrame
            if targetModel:FindFirstChild("Spawn") then
                targetCFrame = targetModel.Spawn.CFrame
            else
                for _, spawnPart in pairs(targetModel:GetChildren()) do
                    if spawnPart.Name:lower():find("spawn") or spawnPart.Name:lower():find("teleport") then
                        targetCFrame = spawnPart.CFrame
                        break
                    end
                end
            end
            if not targetCFrame then
                local modelSize = targetModel:GetExtentsSize()
                local modelCenter = targetModel:GetBoundingBox().Position
                targetCFrame = CFrame.new(modelCenter + Vector3.new(0, 5, 0))
            end
            hrp.CFrame = targetCFrame
            Library:Notify("已传送到: " .. locationName, 3)
        else
            Library:Notify("角色不存在或缺少HumanoidRootPart", 3)
        end
    else
        Library:Notify("无法找到传送点: " .. locationName, 3)
    end
end

TeleportGroupBox:AddDropdown("TeleportLocation", {
    Values = {"Volkayno", "Nookville", "Relica", "Piratesburg", "Permafrost", "Jurassic Island", "Badlands"},
    Default = "Volkayno",
    Multi = false,
    Text = "选择传送地点",
    Tooltip = "选择一个地点进行传送",
    Callback = function(Value)
        SelectedTeleportLocation = Value
    end
})

TeleportGroupBox:AddButton({
    Text = "立即传送",
    Func = function()
        if SelectedTeleportLocation then
            teleportToLocation(SelectedTeleportLocation)
        else
            Library:Notify("请先选择一个传送地点", 3)
        end
    end,
    DoubleClick = false
})

-- 第二个脚本 (900行开始)
local StatsGroupBox = Tabs.Plotki:AddRightGroupbox("美化包", "boxes")

StatsGroupBox:AddToggle("AutoChangeLevel", {
    Text = "自动修改等级",
    Tooltip = "自动设置等级为指定值",
    Default = false,
    Callback = function(Value)
        getgenv().AutoLevelEnabled = Value
        if Value then
            getgenv().AutoLevelLoop = task.spawn(function()
                while getgenv().AutoLevelEnabled do
                    pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player:FindFirstChild("leaderstats") then
                            local levelStat = player.leaderstats:FindFirstChild("Level")
                            if levelStat then
                                levelStat.Value = getgenv().TargetLevel
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            if getgenv().AutoLevelLoop then
                task.cancel(getgenv().AutoLevelLoop)
                getgenv().AutoLevelLoop = nil
            end
        end
    end
})

StatsGroupBox:AddSlider("TargetLevel", {
    Text = "目标等级",
    Tooltip = "设置要修改的等级值",
    Default = 100,
    Min = 1,
    Max = 1000,
    Rounding = 1,
    Callback = function(value)
        getgenv().TargetLevel = value
    end
})

StatsGroupBox:AddToggle("AutoChangeMoney", {
    Text = "自动修改金钱",
    Tooltip = "自动设置金钱为指定值",
    Default = false,
    Callback = function(Value)
        getgenv().AutoMoneyEnabled = Value
        if Value then
            getgenv().AutoMoneyLoop = task.spawn(function()
                while getgenv().AutoMoneyEnabled do
                    pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player:FindFirstChild("leaderstats") then
                            local moneyStat = player.leaderstats:FindFirstChild("Doolars")
                            if moneyStat then
                                moneyStat.Value = getgenv().TargetMoney
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            if getgenv().AutoMoneyLoop then
                task.cancel(getgenv().AutoMoneyLoop)
                getgenv().AutoMoneyLoop = nil
            end
        end
    end
})

StatsGroupBox:AddSlider("TargetMoney", {
    Text = "目标金钱",
    Tooltip = "设置要修改的金钱值",
    Default = 10000,
    Min = 1,
    Max = 9999999,
    Rounding = 1,
    Callback = function(value)
        getgenv().TargetMoney = value
    end
})

StatsGroupBox:AddToggle("Kelongpets", {
    Text = "克隆宠物",
    Tooltip = "随机复制一个宠物",
    Default = false,
    Callback = function(Value)
        if Value then
            getgenv().KelongpetsEnabled = true
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local player = Players.LocalPlayer
            if not workspace:FindFirstChild("_Pets") then
                return
            end
            local originalPets = {}
            local clonedPets = {}
            local clonedModels = {}
            local function deepClone(object)
                if not object or typeof(object) ~= "Instance" then
                    return object
                end
                local clone
                if object:IsA("BasePart") then
                    clone = object:Clone()
                    clone:ClearAllChildren()
                    for _, prop in ipairs({"Size", "Color", "Transparency", "Material", "Reflectance"}) do
                        pcall(function()
                            clone[prop] = object[prop]
                        end)
                    end
                    for _, child in ipairs(object:GetChildren()) do
                        if child:IsA("SpecialMesh") or child:IsA("Decal") or child:IsA("Texture") then
                            local childClone = child:Clone()
                            childClone.Parent = clone
                        end
                    end
                elseif object:IsA("Model") then
                    clone = Instance.new("Model")
                    clone.Name = object.Name .. "_Clone"
                    for _, child in ipairs(object:GetChildren()) do
                        if child:IsA("BasePart") or child:IsA("Model") then
                            local childClone = deepClone(child)
                            if childClone then
                                childClone.Parent = clone
                            end
                        end
                    end
                    if object.PrimaryPart then
                        local primaryClone = clone:FindFirstChild(object.PrimaryPart.Name)
                        if primaryClone then
                            clone.PrimaryPart = primaryClone
                        end
                    end
                else
                    clone = object:Clone()
                end
                return clone
            end
            local function clonePet(petModel)
                if not petModel or typeof(petModel) ~= "Instance" then
                    return nil
                end
                if clonedPets[petModel] then
                    return clonedPets[petModel]
                end
                local petClone = deepClone(petModel)
                if not petClone then
                    return nil
                end
                petClone.Name = petModel.Name .. "_Dupe"
                if petClone:IsA("Model") then
                    local tag = Instance.new("StringValue")
                    tag.Name = "ClonedPet"
                    tag.Value = "LocalClone"
                    tag.Parent = petClone
                end
                if petClone:IsA("BasePart") then
                    petClone.LocalTransparencyModifier = 0
                    petClone.CanCollide = false
                    petClone.Anchored = false
                    petClone.CastShadow = false
                elseif petClone:IsA("Model") then
                    for _, part in ipairs(petClone:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.LocalTransparencyModifier = 0
                            part.CanCollide = false
                            part.Anchored = false
                            part.CastShadow = false
                        end
                    end
                end
                clonedPets[petModel] = petClone
                table.insert(clonedModels, petClone)
                return petClone
            end
            local function monitorPets()
                local petsFolder = workspace._Pets
                for _, pet in ipairs(petsFolder:GetChildren()) do
                    if not originalPets[pet] then
                        originalPets[pet] = true
                        spawn(function()
                            wait(1)
                            local clone = clonePet(pet)
                            if clone then
                                clone.Parent = workspace
                                spawn(function()
                                    while clone and clone.Parent and pet and pet.Parent do
                                        pcall(function()
                                            if clone:IsA("BasePart") then
                                                clone.CFrame = pet.CFrame * CFrame.new(2, 0, 2)
                                            elseif clone:IsA("Model") and clone.PrimaryPart and pet.PrimaryPart then
                                                clone:SetPrimaryPartCFrame(
                                                    pet.PrimaryPart.CFrame * CFrame.new(2, 0, 2)
                                                )
                                            end
                                        end)
                                        RunService.RenderStepped:Wait()
                                    end
                                end)
                            end
                        end)
                    end
                end
                local connection
                connection = petsFolder.ChildAdded:Connect(function(child)
                    wait(2)
                    if not originalPets[child] then
                        originalPets[child] = true
                        local clone = clonePet(child)
                        if clone then
                            clone.Parent = workspace
                            spawn(function()
                                while clone and clone.Parent and child and child.Parent do
                                    pcall(function()
                                        if clone:IsA("BasePart") then
                                            clone.CFrame = child.CFrame * CFrame.new(-2, 0, -2)
                                        elseif clone:IsA("Model") and clone.PrimaryPart and child.PrimaryPart then
                                            clone:SetPrimaryPartCFrame(
                                                child.PrimaryPart.CFrame * CFrame.new(-2, 0, -2)
                                            )
                                        end
                                    end)
                                    RunService.RenderStepped:Wait()
                                end
                            end)
                        end
                    end
                end)
                petsFolder.ChildRemoved:Connect(function(child)
                    if clonedPets[child] then
                        pcall(function()
                            clonedPets[child]:Destroy()
                        end)
                        clonedPets[child] = nil
                    end
                end)
                return connection
            end
            local function setupCleanup()
                game:BindToClose(function()
                    for _, clone in pairs(clonedPets) do
                        pcall(function()
                            clone:Destroy()
                        end)
                    end
                end)
                player.CharacterRemoving:Connect(function()
                    for _, clone in pairs(clonedPets) do
                        pcall(function()
                            clone:Destroy()
                        end)
                    end
                end)
            end
            local function main()
                setupCleanup()
                local success, err = pcall(function()
                    monitorPets()
                end)
                if not success then
                end
                while wait(5) do
                    local petCount = #workspace._Pets:GetChildren()
                    local cloneCount = #clonedModels
                end
            end
            local success, err = pcall(main)
            if not success then
            end
        else
            getgenv().KelongpetsEnabled = false
        end
    end
})

getgenv().TargetLevel = 100
getgenv().TargetMoney = 10000
getgenv().AutoLevelEnabled = false
getgenv().AutoMoneyEnabled = false
getgenv().KelongpetsEnabled = false

local VisualGroupBox = Tabs.Plotki:AddRightGroupbox("视觉效果", "boxes", 2)

local Lighting = game:GetService("Lighting")
getgenv().FullBright_Enabled = false
getgenv().FullBright_Original = {
    Sky = Lighting:FindFirstChildOfClass("Sky") and Lighting:FindFirstChildOfClass("Sky"):Clone() or nil,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime
}

local function applyFullBright()
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.ClockTime = 14
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then obj:Destroy() end
    end
end

local function restoreLighting()
    Lighting.Brightness = getgenv().FullBright_Original.Brightness
    Lighting.Ambient = getgenv().FullBright_Original.Ambient
    Lighting.OutdoorAmbient = getgenv().FullBright_Original.OutdoorAmbient
    Lighting.ClockTime = getgenv().FullBright_Original.ClockTime
    if getgenv().FullBright_Original.Sky and not Lighting:FindFirstChildOfClass("Sky") then
        getgenv().FullBright_Original.Sky:Clone().Parent = Lighting
    end
end

RunService.RenderStepped:Connect(function()
    if getgenv().FullBright_Enabled then applyFullBright() end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if getgenv().FullBright_Enabled then
        task.wait(0.5)
        applyFullBright()
    end
end)

VisualGroupBox:AddToggle("FullBright", {
    Text = "屏幕光亮",
    Tooltip = "使游戏场景变亮",
    Default = false,
    Callback = function(state)
        getgenv().FullBright_Enabled = state
        if not state then restoreLighting() else applyFullBright() end
    end
})

local UtilityGroupBox = Tabs.Plotki:AddLeftGroupbox("实用功能", "boxes", 3)

UtilityGroupBox:AddToggle("Noclip", {
    Text = "穿墙",
    Tooltip = "允许穿墙",
    Default = false,
    Callback = function(Value)
        if Value then
            getgenv().Noclip = true
            local connection
            connection = game.RunService.Stepped:Connect(function()
                if getgenv().Noclip then
                    for _, b in pairs(game.Workspace:GetChildren()) do
                        if b.Name == LocalPlayer.Name then
                            for _, v in pairs(game.Workspace[LocalPlayer.Name]:GetChildren()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                end
                            end
                        end
                    end
                else
                    connection:Disconnect()
                end
            end)
        else
            getgenv().Noclip = false
        end
    end
})

UtilityGroupBox:AddToggle("Fly", {
    Text = "飞行",
    Tooltip = "启用飞行",
    Default = false,
    Callback = function(Value)
        if Value then
            loadstring(game:HttpGet'https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt')()
        end
    end
})

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place")
SaveManager:BuildConfigSection(Tabs.UISettings)
ThemeManager:ApplyToTab(Tabs.UISettings)
SaveManager:LoadAutoloadConfig()

game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    for toggleName, loop in pairs(AutoLoops) do
        if loop then
            task.cancel(loop)
            AutoLoops[toggleName] = nil
        end
    end
    if getgenv().AutoLevelLoop then
        task.cancel(getgenv().AutoLevelLoop)
        getgenv().AutoLevelLoop = nil
    end
    if getgenv().AutoMoneyLoop then
        task.cancel(getgenv().AutoMoneyLoop)
        getgenv().AutoMoneyLoop = nil
    end
    getgenv().KelongpetsEnabled = false
    getgenv().FullBright_Enabled = false
    getgenv().TpwalkEnabled = false
    getgenv().Noclip = false
    restoreLighting()
end)

Library:Notify("脚本加载完成！", 3)