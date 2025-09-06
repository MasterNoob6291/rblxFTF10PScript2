local R=loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local P,RS,US,RepS=game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("ReplicatedStorage")
local LP=P.LocalPlayer
local PChar=LP.Character or LP.CharacterAdded:Wait()
local Hum,HRP=PChar:WaitForChild("Humanoid"),PChar:WaitForChild("HumanoidRootPart")
local Map=workspace:WaitForChild("Map")
local N,I=false,false

-- Window
local W=R:CreateWindow({Name="Flee Hub TEST",LoadingTitle="Loading...",LoadingSubtitle="by Nugget",Theme="AmberGlow",ConfigurationSaving={Enabled=false},KeySystem=false})
R:Notify({Title="Success!",Content="Flee Hub Loaded! Use 'K' to toggle UI",Duration=6,Image="check"})

-- Player Tab
local PT=W:CreateTab("Player Controls","circle-user")
PT:CreateSection("Basic Controls") PT:CreateDivider()
PT:CreateInput({Name="WalkSpeed",PlaceholderText="Enter WalkSpeed",RemoveTextAfterFocusLost=true,Callback=function(txt) local v=tonumber(txt) if v then Hum.WalkSpeed=v end end})
PT:CreateInput({Name="JumpHeight",PlaceholderText="Enter JumpHeight",RemoveTextAfterFocusLost=true,Callback=function(txt) local v=tonumber(txt) if v then Hum.JumpHeight=v end end})
PT:CreateSection("Movement Enhancements") PT:CreateDivider()
PT:CreateToggle({Name="Noclip",CurrentValue=false,Flag="Noclip",Callback=function(v) N=v end})
PT:CreateToggle({Name="Infinite Jump",CurrentValue=false,Flag="InfiniteJump",Callback=function(v) I=v end})

-- Teleport Tab
local TT=W:CreateTab("Teleports","map-pin")
local Sel
local DD=TT:CreateDropdown({Name="Select Player",Options={},CurrentOption="",Flag="PlayerDropdown",Callback=function(v) Sel=P:FindFirstChild(v[1]) end})
local function UpDD() local t={} for _,plr in pairs(P:GetPlayers()) do if plr~=LP then table.insert(t,plr.Name) end end DD:Refresh(t) end
P.PlayerAdded:Connect(UpDD) P.PlayerRemoving:Connect(UpDD) UpDD()

TT:CreateButton({Name="Teleport to Player",Callback=function() if Sel and Sel.Character and Sel.Character:FindFirstChild("HumanoidRootPart") then HRP.CFrame=Sel.Character.HumanoidRootPart.CFrame+Vector3.new(0,5,0) end end})
TT:CreateButton({Name="Teleport to Random Player",Callback=function()
    local players={} for _,plr in pairs(P:GetPlayers()) do if plr~=LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then table.insert(players,plr) end end
    if #players>0 then local choice=players[math.random(1,#players)] HRP.CFrame=choice.Character.HumanoidRootPart.CFrame+Vector3.new(0,5,0)
    else R:Notify({Title="Error",Content="No players to teleport to",Duration=3,Image="triangle-alert"}) end
end})
TT:CreateButton({Name="Teleport to Beast",Callback=function()
    local beastVal = RepS:FindFirstChild("Beast1") and RepS.Beast1.Value or nil
    if not beastVal or not P:FindFirstChild(beastVal) then beastVal = RepS:FindFirstChild("Beast2") and RepS.Beast2.Value or nil end
    local beast = beastVal and P:FindFirstChild(beastVal) or nil
    if beast and beast.Character and beast.Character:FindFirstChild("HumanoidRootPart") then
        HRP.CFrame=beast.Character.HumanoidRootPart.CFrame+Vector3.new(0,5,0)
    else
        R:Notify({Title="Error",Content="No Beast found",Duration=3,Image="triangle-alert"})
    end
end})
TT:CreateButton({Name="Teleport to Incomplete Computer",Callback=function()
    for _,c in pairs(Map:GetChildren()) do local s,t=c:FindFirstChild("Screen"),c:FindFirstChild("ComputerTrigger1")
        if c.Name=="ComputerTable" and s and t and s.Color~=Color3.fromRGB(60,255,0) then
            HRP.CFrame=t.CFrame+Vector3.new(0,5,0) break
        end
    end
end})
TT:CreateButton({Name="Teleport to Player in Pod",Callback=function()
    local f=false for _,plr in pairs(P:GetPlayers()) do local hrp=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if plr.Character and plr.Character~=PChar and plr.Character:GetAttribute("InPod") and hrp then
            HRP.CFrame=hrp.CFrame f=true break
        end
    end
    if not f then R:Notify({Title="Error",Content="No player was in pod",Duration=3,Image="triangle-alert"}) end
end})

-- Statistics Tab
local ST=W:CreateTab("Statistics","circle-user")
local Beast1,Beast2,MapLabel=ST:CreateLabel("Beast1: LOADING..","skull"),ST:CreateLabel("Beast2: LOADING..","skull"),ST:CreateLabel("Map: LOADING..","map")
RS.Heartbeat:Connect(function()
    if RepS:FindFirstChild("Beast1") then Beast1:Set("Beast1: "..tostring(RepS.Beast1.Value)) end
    if RepS:FindFirstChild("Beast2") then Beast2:Set("Beast2: "..tostring(RepS.Beast2.Value)) end
    if RepS:FindFirstChild("MapName") then MapLabel:Set("Map: "..tostring(RepS.MapName.Value)) end
end)

-- Enhancements
RS.Stepped:Connect(function() if N and PChar then if PChar:FindFirstChild("Torso") then PChar.Torso.CanCollide=false end if HRP then HRP.CanCollide=false end end end)
US.JumpRequest:Connect(function() if I and Hum and Hum:GetState()==Enum.HumanoidStateType.Freefall then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)
LP.CharacterAdded:Connect(function(char) PChar,Hum,HRP=char,char:WaitForChild("Humanoid"),char:WaitForChild("HumanoidRootPart") end)
