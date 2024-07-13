--!strict

-- declared types

export type int64 = number
export type float = number
export type texture = string
export type path = any
export type vec1 = number

-- Basic parameters

local interpolation: boolean = true
local gridMovement: boolean = true
local buildPlacementAllow: boolean = true

local rotation: int64 = 90
local maxHeigth: int64 = 90

local lerpAmount: float = 0.75

local gridTexture: texture = ""
-- parameter end


local objectPlacement = {}
objectPlacement.__index = objectPlacement

local plr = game:GetService("Players")
local runService = game:GetService("RunService")

local localPlayer = plr.LocalPlayer
local playerCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local mouse = localPlayer:GetMouse()

-- DO NOT CHANGE // immutable variables --

local _GRID_SIZE: int64
local _OBJ_PATH: path
local _DELETE_KEY: any
local _ROTATIONAL_KEY: any

local _obj: any
local _placedObjs: any
local _plot: any
local _stackable: boolean

local posX: vec1
local posY: vec1
local posZ: vec1


-- mutable variables --
local speed: int64 = 1

local function snapToPosition(x: int64): ()
	return math.floor((x/_GRID_SIZE) + 0.5) * _GRID_SIZE
end

local function caclModelPosition()
	if gridMovement then
			posX = snapToPosition(mouse.Hit.X)
			posY = 2
			posZ = snapToPosition(mouse.Hit.Z)
		else
			posX = mouse.Hit.X
			posY = mouse.Hit.Y
			posZ = mouse.Hit.Z
	end
end

local function translateObjXYZ()
	if _placedObjs and _obj.Parent == _placedObjs then
		caclModelPosition()

		_obj:PivotTo(_obj.PrimaryPart.CFrame:Lerp(CFrame.new(posX, posY, posZ), speed))
	end
end

local function verifyPlacementArea()
	return _plot.Size.X%_GRID_SIZE == 0 and _plot.Size.Z%_GRID_SIZE == 0
end

local function approve<T>(): ()
	if not verifyPlacementArea() then
		warn("Can't verify placement area")

		return false
	end

	if _GRID_SIZE >= math.min(_plot.Size.X, _plot.Size.Z) then
		error("Grid size larger than plot size")

		return false
	end

	return true
end


function objectPlacement.new<T>(gridSize: int64, objectPath: path, deleteKey: T, rotationalKey: T): ()
	
	local data = {}; local metadata = setmetatable(data,objectPlacement)
	
	_GRID_SIZE = gridSize
	_OBJ_PATH = objectPath
	_DELETE_KEY = deleteKey
	_ROTATIONAL_KEY = rotationalKey
	
	data.grid = _GRID_SIZE
	data.path = _OBJ_PATH
	data.deletekey = _DELETE_KEY
	data.rotatekey = _ROTATIONAL_KEY
	
	return data
end
	
function objectPlacement:active<T, K>(id: T, placedObjs: Folder, plot: K, stackable: boolean): ()
	
	_obj = _OBJ_PATH:FindFirstChild(id):Clone()
	_placedObjs = placedObjs
	_plot = plot::any
	_stackable = stackable
	
	
	if not approve() then
		return print("Placement can't be approved")
	end
	if not stackable then
		mouse.TargetFilter = placedObjs
		else
			mouse.TargetFilter = id
	end

	local defaultSpeed: float = 1.0

	if interpolation then
		defaultSpeed = math.clamp(math.abs(1 - lerpAmount), 0, 0.9)
		speed = 1
	end

	_obj.Parent = _placedObjs

	task.wait()

	speed = defaultSpeed
end

runService:BindToRenderStep("Input", Enum.RenderPriority.Input.Value, translateObjXYZ)

return objectPlacement