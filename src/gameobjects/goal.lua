
local GoalClass = {
    name = "Goal",
    x, y = 0, 0,
    width, height = 0, 0,
    isGoal = true
}

GoalClass.__index = GoalClass

function GoalClass.new(name, x, y, width, height, world)
    local goal = {}
    goal.name = name
    goal.x, goal.y = x, y
    goal.width, goal.height = width, height
    goal.world = world
    goal.world:add(goal, goal.x, goal.y, goal.width, goal.height)
    setmetatable(goal, GoalClass)
    return goal
end

return GoalClass
