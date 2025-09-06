local R=loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local P,RS,US,RepS=game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("ReplicatedStorage")
local LP,PChar=P.LocalPlayer,P.LocalPlayer.Character or P.LocalPlayer.CharacterAdded:Wait()
local Hum,HRP=PChar:WaitForChild("Humanoid"),PChar:WaitForChild("HumanoidRootPart")
local Map=workspace:WaitForChild("Map")
local N,I=false,false

-- Window
local W=R:CreateWindow({Name="Flee Hub",LoadingTitle="Loading...",LoadingSubtitle="by Nugget",Theme="AmberGlow",ConfigurationSaving={Enabled=false},KeySystem=false})
R:Notify({Title="Success!",Content="Flee Hub Loaded! Use 'K' to toggle UI",Duration=6,Image="check"})

-- Player Tab
local PT=W:CreateTab("Player Controls","circle-user")
PT:CreateSection("Basic Controls") PT:CreateDivider()
PT:CreateSlider({Name="WalkSpeed",Range={8,500},Increment=1,Suffix="Speed",CurrentValue=16,Flag="WalkSpeed",Callback=function(v) Hum.WalkSpeed=v end})
PT:CreateSlider({Name="JumpHeight",Range={5,30},Increment=1,Suffix="Height",CurrentValue=7.2,Flag="JumpHeight",Callback=function(v) Hum.JumpHeight=v end})
PT:CreateSection("Movement Enhancements") PT:CreateDivider()
PT:CreateToggle({Name="Noclip",CurrentValue=false,Flag="Noclip",Callback=function(v) N=v end})
PT:CreateToggle({Name="Infinite Jump",CurrentValue=false,Flag="InfiniteJump",Callback=function(v) I=v end})

-- Teleports
PT:CreateSection("Teleport Menu") PT:CreateDivider()
local Sel,nilDD=nil,nil
local DD=PT:CreateDropdown({Name="Select Player",Options={},CurrentOption="",Flag="PlayerDropdown",Callback=function(v) Sel=P:FindFirstChild(v[1]) end})
local function UpDD() local t={} for _,p in pairs(P:GetPlayers()) do if p~=LP then table.insert(t,p.Name) end end DD:Refresh(t) end
P.PlayerAdded:Connect(UpDD) P.PlayerRemoving:Connect(UpDD) UpDD()
PT:CreateButton({Name="Teleport to Player",Callback=function() if Sel and Sel.Character and Sel.Character:FindFirstChild("HumanoidRootPart") then HRP.CFrame=Sel.Character.HumanoidRootPart.CFrame+Vector3.new(0,5,0) end end})
PT:CreateButton({Name="Teleport to Incomplete Computer",Callback=function() for _,c in pairs(Map:GetChildren()) do local s,t=c:FindFirstChild("Screen"),c:FindFirstChild("ComputerTrigger1") if c.Name=="ComputerTable" and s and t and s.Color~=Color3.fromRGB(60,255,0) then HRP.CFrame=t.CFrame+Vector3.new(0,5,0) break end end end})
PT:CreateButton({Name="Teleport to Player in Pod",Callback=function() local f=false for _,p in pairs(P:GetPlayers()) do local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart") if p.Character and p.Character~=PChar and p.Character:GetAttribute("InPod") and hrp then HRP.CFrame=hrp.CFrame+Vector3.new(0,5,0) f=true break end end if not f then R:Notify({Title="Error",Content="No player was in pod",Duration=3,Image="triangle-alert"}) end end})

-- Statistics
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
LP.CharacterAdded:Connect(function(char) PChar,H,HRP=char,char:WaitForChild("Humanoid"),char:WaitForChild("HumanoidRootPart") end)
