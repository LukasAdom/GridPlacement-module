--!strict


local objectPlacementModule = require(game.ReplicatedStorage.objectPlacementModule)

local placement: objectPlacementModule.path = objectPlacementModule.new(
	2,
	game.ReplicatedStorage.objs,
	Enum.KeyCode.R, 
	Enum.KeyCode.X
)

task.wait(1)

objectPlacementModule:active("Chair", workspace.objHolder, workspace.Baseplate, false)