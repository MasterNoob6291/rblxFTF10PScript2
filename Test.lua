local R=loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local P,RS,US,RepS=game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("ReplicatedStorage")
local LP=P.LocalPlayer
local PChar=LP.Character or LP.CharacterAdded:Wait()
local Hum,HRP=PChar:WaitForChild("Humanoid"),PChar:WaitForChild("HumanoidRootPart")
local Map=workspace:WaitForChild("Map")
local N,I=false,false
local ScriptVersion="1.2.454"
local Mode="Testing"

-- Window
local W=R:CreateWindow({Name="Flee Hub TEST VERSION",LoadingTitle="Loading...",LoadingSubtitle="by Nugget",Theme="AmberGlow",ConfigurationSaving={Enabled=false},KeySystem=false})
R:Notify({Title="Success!",Content="Flee Hub Loaded! Use 'K' to toggle UI",Duration=6,Image="check"})

-- Player Tab
local PT=W:CreateTab("Player Controls","circle-user")
PT:CreateSection("Basic Controls") PT:CreateDivider()
PT:CreateInput({Name="WalkSpeed",PlaceholderText="Enter WalkSpeed",RemoveTextAfterFocusLost=true,Callback=function(t) local v=tonumber(t) if v then Hum.WalkSpeed=v end end})
PT:CreateInput({Name="JumpHeight",PlaceholderText="Enter JumpHeight",RemoveTextAfterFocusLost=true,Callback=function(t) local v=tonumber(t) if v then Hum.JumpHeight=v end end})
PT:CreateSection("Movement Enhancements") PT:CreateDivider()
PT:CreateToggle({Name="Noclip",CurrentValue=false,Flag="Noclip",Callback=function(v) N=v end})
PT:CreateToggle({Name="Infinite Jump",CurrentValue=false,Flag="InfiniteJump",Callback=function(v) I=v end})

-- Self Protection Section
PT:CreateSection("Self Protection") PT:CreateDivider()

PT:CreateButton({
    Name = "Un Freeze",
    Callback = function()
        local FreezePodRemote = RepS:FindFirstChild("FreezePod")
        if FreezePodRemote then
            for _, obj in ipairs(workspace.Map:GetDescendants()) do
                if obj.Name == "FreezePod" then
                    FreezePodRemote:FireServer(obj)
                end
            end
        end
    end
})

-- Invisibility Toggle
local invis_on = false
local savedpos

PT:CreateToggle({
    Name = "Toggle Invisibility",
    CurrentValue = false,
    Flag = "Invisibility",
    Callback = function(v)
        invis_on = v
        if invis_on then
            savedpos = HRP.CFrame
            task.wait()
            PChar:MoveTo(Vector3.new(-25.95, 84, 3537.55))
            task.wait(0.15)

            local Seat = Instance.new('Seat', workspace)
            Seat.Anchored = false
            Seat.CanCollide = false
            Seat.Name = 'invischair'
            Seat.Transparency = 1
            Seat.Position = Vector3.new(-25.95, 84, 3537.55)

            local Weld = Instance.new("Weld", Seat)
            Weld.Part0 = Seat
            Weld.Part1 = PChar:FindFirstChild("Torso") or PChar:FindFirstChild("UpperTorso")

            task.wait()
            Seat.CFrame = savedpos

            R:Notify({Title="Invis On",Content="",Duration=2,Image="check"})
        else
            local seat = workspace:FindFirstChild('invischair')
            if seat then seat:Destroy() end
            R:Notify({Title="Invis Off",Content="",Duration=2,Image="check"})
        end
    end
})


-- Teleport Tab
local TT=W:CreateTab("Teleports","map-pin")
TT:CreateSection("Teleport To Players") TT:CreateDivider()
local Sel
local DD=TT:CreateDropdown({Name="Select Player",Options={},CurrentOption="",Flag="PlayerDropdown",Callback=function(v) Sel=P:FindFirstChild(v[1]) end})
local function UpDD()
    local t={}
    for _,plr in ipairs(P:GetPlayers()) do
        if plr~=LP then table.insert(t,plr.Name) end
    end
    DD:Refresh(t)
end
P.PlayerAdded:Connect(UpDD) P.PlayerRemoving:Connect(UpDD) UpDD()

TT:CreateButton({Name="Teleport to Player",Callback=function() 
    if Sel and Sel.Character and Sel.Character:FindFirstChild("HumanoidRootPart") then 
        HRP.CFrame=Sel.Character.HumanoidRootPart.CFrame+Vector3.new(0,1,0) 
    end 
end})

TT:CreateButton({Name="Teleport to Random Player",Callback=function()
    local ps={}
    for _,plr in ipairs(P:GetPlayers()) do
        if plr~=LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then 
            table.insert(ps,plr) 
        end
    end
    if #ps>0 then 
        local c=ps[math.random(#ps)] 
        HRP.CFrame=c.Character.HumanoidRootPart.CFrame+Vector3.new(0,5,0)
    else 
        R:Notify({Title="Error",Content="No players to teleport to",Duration=3,Image="triangle-alert"}) 
    end
end})

TT:CreateButton({Name="Teleport to Beast",Callback=function()
    for _,plr in ipairs(P:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Hammer") then
            HRP.CFrame=plr.Character.HumanoidRootPart.CFrame+Vector3.new(0,5,0)
            return
        end
    end
    R:Notify({Title="Error",Content="No Beast found",Duration=3,Image="triangle-alert"})
end})

TT:CreateSection("Teleport To Objects") TT:CreateDivider()
TT:CreateButton({Name="Teleport to Player in Pod",Callback=function()
    local f=false
    for _,plr in ipairs(P:GetPlayers()) do
        local hrp=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if plr.Character and plr.Character~=PChar and plr.Character:GetAttribute("InPod") and hrp then 
            HRP.CFrame=hrp.CFrame 
            f=true 
            break 
        end
    end
    if not f then 
        R:Notify({Title="Error",Content="No player was in pod",Duration=3,Image="triangle-alert"}) 
    end
end})

TT:CreateButton({Name="Teleport to Incomplete Computer",Callback=function()
    for _,c in pairs(Map:GetChildren()) do
        local s,t=c:FindFirstChild("Screen"),c:FindFirstChild("ComputerTrigger1")
        if c.Name=="ComputerTable" and s and t and s.Color~=Color3.fromRGB(60,255,0) then
            HRP.CFrame=t.CFrame+Vector3.new(0,5,0)
            break
        end
    end
end})

TT:CreateButton({Name="Teleport to Random ExitDoor",Callback=function()
    local exits={}
    for _,door in pairs(workspace.Map:GetChildren()) do
        if door.Name=="ExitDoor" and door:FindFirstChild("ExitDoorTrigger") then
            table.insert(exits,door.ExitDoorTrigger)
        end
    end
    if #exits>0 then
        HRP.CFrame=exits[math.random(#exits)].CFrame
    else 
        R:Notify({Title="Error",Content="No ExitDoors found",Duration=3,Image="triangle-alert"}) 
    end
end})

-- Trolling Tab
local TTroll = W:CreateTab("Trolling","skull")
TTroll:CreateSection("Doors") 
TTroll:CreateDivider()

local function OpenCloseDoor(State)
    for _, obj in pairs(Map:GetDescendants()) do
        if obj.Name:find("DoorTrigger") and obj.Parent then
                local args1 = { [1] = obj.Parent, [2] = State, [3] = 0 }
                local args2 = { [1] = obj.Parent, [2] = State, [3] = 1 }
                RepS.Door:FireServer(unpack(args1))
                RepS.Door:FireServer(unpack(args2))
            end
    end
end

-- Button: Open Near Doors
TTroll:CreateButton({
    Name = "Open Near Doors",
    Callback = function()
        OpenCloseDoor(true)
    end
})

-- Button: Close Near Doors
TTroll:CreateButton({
    Name = "Close Near Doors",
    Callback = function()
        OpenCloseDoor(false)
    end
})

-- Button: Teleport + Open Door
TTroll:CreateButton({
    Name = "Open all Doors",
    Callback = function()
        for _, obj in pairs(Map:GetDescendants()) do
            if obj.Name:find("DoorTrigger") and obj.Parent then
                HRP.CFrame = obj.CFrame
                wait(0.02)
                OpenCloseDoor(true)
                OpenCloseDoor(true)
                wait(0.035)
            end
        end
    end
})

-- Button: Teleport + Close Door
TTroll:CreateButton({
    Name = "Close all Doors",
    Callback = function()
        for _, obj in pairs(Map:GetDescendants()) do
            if obj.Name:find("DoorTrigger") and obj.Parent then
                HRP.CFrame = obj.CFrame
                wait(0.02)
                OpenCloseDoor(false)
                OpenCloseDoor(false)
                OpenCloseDoor(false)
                wait(0.05)
            end
        end
    end
})

-- Section for Pods
TTroll:CreateSection("Pods") 
TTroll:CreateDivider()

local AutoPod = false

TTroll:CreateToggle({
    Name = "Auto Unfreeze",
    CurrentValue = false,
    Flag = "AutoPodRescue",
    Callback = function(v)
        AutoPod = v
    end
})

-- Auto Unfreeze function (fires server for all pods)
local function AutoUnfreeze()
    local FreezePodRemote = RepS:FindFirstChild("FreezePod")
    if FreezePodRemote then
        for _, pod in pairs(Map:GetDescendants()) do
            if pod.Name == "FreezePod" then
                FreezePodRemote:FireServer(pod)
            end
        end
    end
end

-- Loop for AutoPod
task.spawn(function()
    while task.wait(1) do
        if AutoPod then
            local savedCFrame = HRP.CFrame
            for _,plr in ipairs(P:GetPlayers()) do
                if plr ~= LP and plr.Character and plr.Character:GetAttribute("InPod") then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- offset 3 studs forward relative to the player's look direction
                        HRP.CFrame = hrp.CFrame * CFrame.new(0,0,-3)
                        wait(0.2)
                        -- fire remote(s) to unfreeze
                        AutoUnfreeze()
                        AutoUnfreeze()
                        AutoUnfreeze()
                        wait(0.3)
                    end
                end
            end
            -- restore your original position
            HRP.CFrame = savedCFrame
        end
    end
end)




-- Statistics Tab
local ST=W:CreateTab("Statistics","circle-user")
ST:CreateSection("Script Statistics") ST:CreateDivider()
ST:CreateLabel("Version: "..ScriptVersion,"hash")
ST:CreateLabel("Mode: "..Mode,"arrow-big-right-dash")
ST:CreateLabel("Created by Nugget","book-user")
ST:CreateSection("Game Statistics") ST:CreateDivider()
local Beast1,Beast2,MapLabel=ST:CreateLabel("Beast1: LOADING..","skull"),ST:CreateLabel("Beast2: LOADING..","skull"),ST:CreateLabel("Map: LOADING..","map")

-- Heartbeat for stats and enhancements
RS.Heartbeat:Connect(function()
    if RepS:FindFirstChild("Beast1") then Beast1:Set("Beast1: "..tostring(RepS.Beast1.Value)) end
    if RepS:FindFirstChild("Beast2") then Beast2:Set("Beast2: "..tostring(RepS.Beast2.Value)) end
    if RepS:FindFirstChild("MapName") then MapLabel:Set("Map: "..tostring(RepS.MapName.Value)) end
end)

-- Enhancements
RS.Stepped:Connect(function()
    if N and PChar then
        if PChar:FindFirstChild("Torso") then PChar.Torso.CanCollide=false end
        if HRP then HRP.CanCollide=false end
    end
end)
US.JumpRequest:Connect(function()
    if I and Hum and Hum:GetState()==Enum.HumanoidStateType.Freefall then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
LP.CharacterAdded:Connect(function(c) PChar,Hum,HRP=c,c:WaitForChild("Humanoid"),c:WaitForChild("HumanoidRootPart") end)
