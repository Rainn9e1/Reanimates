setfpscap(60)

getgenv()._SETTINGS = {
    NoAnimations = false
}

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local RemovedInstances = {}

local env = {
	Movement = function(LocalCharacter, ScriptCharacter)
		RunService.Stepped:Connect(function()
			if LocalCharacter.Humanoid.Jump == true then
				ScriptCharacter.Humanoid.Jump = true
			end
		
			ScriptCharacter.Humanoid:Move(LocalCharacter.Humanoid.MoveDirection)
		end)
	end,

    SimulationNet = function(Player, Value)
        RunService.RenderStepped:Connect(function()
            sethiddenproperty(Player, "SimulationRadius", Value)
        end)
    end,

    ClearAnimations = function(Character, Bool)
        if Bool == true then
            for _,Animation in pairs(Character.Humanoid:GetPlayingAnimationTracks()) do
                Animation:Stop()
            end
        end
    end,

    CleanUp = function(Character)
        for _,Instance_ in pairs(Character:GetDescendants()) do
            if Instance_:IsA("Decal") or Instance_:IsA("Part") or Instance_:IsA("MeshPart") then
                Instance_.Transparency = 1
            end
        end
    end,

    NoclipCharacter = function(Character) 
        for _,Instance_ in pairs(Character:GetDescendants()) do
            if Instance_:IsA("Part") or Instance_:IsA("MeshPart") then
                RunService.Stepped:Connect(function()
                    Instance_.CanCollide = false
                end)
            end
        end
    end,

    Align = function(Part0, Part1)
		local function vel(Instance_, Character)		
			local Signal = game.RunService.Heartbeat:connect(function()
				Instance_.Velocity = Vector3.new(-62.89786648237, 0, -62.89786648237)
			end)
		end

		local Attachment0 = Instance.new("Attachment", Part0)
		local Attachment1 = Instance.new("Attachment", Part1)

		local AlignPosition = Instance.new("AlignPosition", Part0)
		local AlignOrientation = Instance.new("AlignOrientation", Part0)
		
		AlignPosition.MaxForce = 9e9
		AlignPosition.Responsiveness = 200
		AlignOrientation.MaxTorque = 9e9
		AlignOrientation.Responsiveness = 200

		AlignPosition.Attachment0 = Attachment0
		AlignPosition.Attachment1 = Attachment1
		AlignOrientation.Attachment0 = Attachment0
		AlignOrientation.Attachment1 = Attachment1

		if Part0.Name == "Handle" then
			Part0:BreakJoints()

			Attachment0.Position = Vector3.new(0, 0, 0)
			Attachment0.Orientation = Vector3.new(90, 0, 0)

			if Part0.Parent.Name == "Pal Hair" then
				Part0.Mesh:Destroy()
			end
		else
			Attachment0.Position = Vector3.new(0, 0, 0)
			Attachment0.Orientation = Vector3.new(0, 0, 0)
		end

		vel(Part0, game.Players.LocalPlayer.Character)
	end,

    UnAnchorCharacter = function(Character)
        for _,Instance_ in pairs(Character:GetDescendants()) do
            if Instance_:IsA("Part") or Instance_:IsA("MeshPart") then
                Instance_.Anchored = false
            end
        end
    end,

	ClearWelds = function(Character)
		local Welds = {
			RightArm = Character.Torso["Right Shoulder"],
			RightLeg = Character.Torso["Right Hip"],
			LeftArm = Character.Torso["Left Shoulder"],
			LeftLeg = Character.Torso["Left Hip"],
			Torso = Character.HumanoidRootPart.RootJoint
		}

		for _,Weld in pairs(Welds) do
			Weld:Remove()
		end
	end,

	Cframe = function(Part0, Part1, Methods)
		local Cframe = game.RunService["Heartbeat"]:Connect(function()
			Part0.CFrame = Part1.CFrame
		end)

		if not Part0 then
			Cframe:disconnect()
			Cframe = nil
		end
	end,

	Remove = function(Part)
		table.insert(RemovedInstances, Part.Name)

		Part:Destroy()
	end,

	setCamera = function(Part)
		Workspace.Camera.CameraSubject = Part
	end,

	bodyCollision = function(Humanoid)
		Humanoid:ChangeState(16)
	end
}

local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character
local Animate = LocalCharacter.Animate
local Humanoid = LocalCharacter.Humanoid
local HumanoidRootPart = LocalCharacter.HumanoidRootPart

LocalCharacter.Archivable = true

local ScriptCharacter = LocalCharacter:Clone()
ScriptCharacter.Name = "ScriptCharacter"
ScriptCharacter.Parent = LocalCharacter

env.CleanUp(ScriptCharacter)
env.NoclipCharacter(ScriptCharacter)
env.NoclipCharacter(LocalCharacter)
env.UnAnchorCharacter(ScriptCharacter)
env.UnAnchorCharacter(LocalCharacter)
env.SimulationNet(LocalPlayer, 1000)
env.ClearWelds(LocalCharacter)
env.Remove(LocalCharacter["HumanoidRootPart"])
env.Movement(LocalCharacter, ScriptCharacter)
env.setCamera(ScriptCharacter.Humanoid)
env.bodyCollision(LocalCharacter.Humanoid)

if _SETTINGS.NoAnimations == true then
    env.ClearAnimations(ScriptCharacter, true)
end

env.Align(LocalCharacter["Torso"], ScriptCharacter["Torso"])
env.Align(LocalCharacter["Left Arm"], ScriptCharacter["Left Arm"])
env.Align(LocalCharacter["Left Leg"], ScriptCharacter["Left Leg"])
env.Align(LocalCharacter["Right Arm"], ScriptCharacter["Right Arm"])
env.Align(LocalCharacter["Right Leg"], ScriptCharacter["Right Leg"])

local FlingPart = nil
