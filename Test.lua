local R=loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local P,RS,US,RepS=game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("ReplicatedStorage")
local LP=P.LocalPlayer local C=LP.Character or LP.CharacterAdded:Wait() local H,HRP=C:WaitForChild("Humanoid"),C:WaitForChild("HumanoidRootPart")
local Map,N,I=workspace:WaitForChild("Map"),false,false

local W=R:CreateWindow({Name="Flee Hub",LoadingTitle="Loading...",LoadingSubtitle="by Nugget",Theme="AmberGlow"})
R:Notify({Title="Success!",Content="Flee Hub Loaded! Use 'K' to toggle UI",Duration=6,Image="check"})

local PT=W:CreateTab("Player","circle-user")
PT:CreateInput({Name="WalkSpeed",PlaceholderText="Enter WalkSpeed",Callback=function(t)H.WalkSpeed=tonumber(t)or H.WalkSpeed end})
PT:CreateInput({Name="JumpHeight",PlaceholderText="Enter JumpHeight",Callback=function(t)H.JumpHeight=tonumber(t)or H.JumpHeight end})
PT:CreateToggle({Name="Noclip",CurrentValue=false,Callback=function(v)N=v end})
PT:CreateToggle({Name="Infinite Jump",CurrentValue=false,Callback=function(v)I=v end})

local TT=W:CreateTab("Teleports","map-pin") local Sel
local DD=TT:CreateDropdown({Name="Select Player",Options={},CurrentOption="",Callback=function(v)Sel=P:FindFirstChild(v[1])end})
local function UpDD()local t={}for _,plr in pairs(P:GetPlayers())do if plr~=LP then table.insert(t,plr.Name)end end DD:Refresh(t)end
P.PlayerAdded:Connect(UpDD) P.PlayerRemoving:Connect(UpDD) UpDD()
TT:CreateButton({Name="Teleport to Player",Callback=function()if Sel and Sel.Character and Sel.Character:FindFirstChild("HumanoidRootPart")then HRP.CFrame=Sel.Character.HumanoidRootPart.CFrame+Vector3.new(0,5,0)end end})
TT:CreateButton({Name="Teleport to Random",Callback=function()local t={}for _,plr in pairs(P:GetPlayers())do if plr~=LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")then table.insert(t,plr)end end if #t>0 then HRP.CFrame=t[math.random(#t)].Character.HumanoidRootPart.CFrame+Vector3.new(0,5,0)else R:Notify({Title="Error",Content="No players",Duration=3})end end})
TT:CreateButton({Name="Teleport to Beast",Callback=function()local bv=(RepS:FindFirstChild("Beast1")and RepS.Beast1.Value)or(RepS:FindFirstChild("Beast2")and RepS.Beast2.Value) local b=bv and P:FindFirstChild(bv) if b and b.Character and b.Character:FindFirstChild("HumanoidRootPart")then HRP.CFrame=b.Character.HumanoidRootPart.CFrame+Vector3.new(0,5,0)else R:Notify({Title="Error",Content="No Beast",Duration=3})end end})
TT:CreateButton({Name="Teleport to Incomplete Computer",Callback=function()for _,c in pairs(Map:GetChildren())do local s,t=c:FindFirstChild("Screen"),c:FindFirstChild("ComputerTrigger1") if c.Name=="ComputerTable"and s and t and s.Color~=Color3.fromRGB(60,255,0)then HRP.CFrame=t.CFrame+Vector3.new(0,5,0)break end end end})
TT:CreateButton({Name="Teleport to Player in Pod",Callback=function()local f for _,plr in pairs(P:GetPlayers())do local hrp=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") if plr~=LP and hrp and plr.Character:GetAttribute("InPod")then HRP.CFrame=hrp.CFrame f=true break end end if not f then R:Notify({Title="Error",Content="No player in pod",Duration=3})end end})

local ST=W:CreateTab("Statistics","circle-user")
local B1,B2,M=ST:CreateLabel("Beast1: LOADING.."),ST:CreateLabel("Beast2: LOADING.."),ST:CreateLabel("Map: LOADING..")
RS.Heartbeat:Connect(function()if RepS:FindFirstChild("Beast1")then B1:Set("Beast1: "..tostring(RepS.Beast1.Value))end if RepS:FindFirstChild("Beast2")then B2:Set("Beast2: "..tostring(RepS.Beast2.Value))end if RepS:FindFirstChild("MapName")then M:Set("Map: "..tostring(RepS.MapName.Value))end end)

RS.Stepped:Connect(function()if N and C then if C:FindFirstChild("Torso")then C.Torso.CanCollide=false end if HRP then HRP.CanCollide=false end end end)
US.JumpRequest:Connect(function()if I and H and H:GetState()==Enum.HumanoidStateType.Freefall then H:ChangeState(Enum.HumanoidStateType.Jumping)end end)
LP.CharacterAdded:Connect(function(ch)C,H,HRP=ch,ch:WaitForChild("Humanoid"),ch:WaitForChild("HumanoidRootPart")end)
