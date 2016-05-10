local classic = require 'classic'

local StochasticDeepChain, super = classic.class('StochasticDeepChain', Env)


-- Constructor
function StochasticDeepChain:_init(opts)
  opts = opts or {length = 6}
  self.length = opts.length
end

-- 1 states returned, of type 'int', of dimensionality 1, between 1 and length of the chain (the terminal states)
function StochasticDeepChain:getStateSpec()
  return {'int', 1, {1, self.length}} -- Position
end

-- 1 action required, of type 'int', of dimensionality 1, between 0 and 1 (left or right)
function StochasticDeepChain:getActionSpec()
  return {'int', 1, {0, 1}}
end

-- Min and max reward
function StochasticDeepChain:getRewardSpec()
  return 0, 1
end

-- Reset position
function StochasticDeepChain:start()
  self.position = 1
  self.stepN = 1
  return self.position
end

-- Move left or right
function StochasticDeepChain:step(action)
  local reward = 0
  local terminal = false
  -- increase step count and check termination
  self.stepN = self.stepN + 1
  if self.stepN >= self.length + 9 then
    terminal = true
  end
  
  if action == 1 then -- 50% chance changing right to left
    action = math.random(2) - 1
  end
  
  if action == 0 then
    self.position = self.position - 1
    if self.position == 0 then
      self.position = 1
    end
  else
    self.position = self.position + 1
    if self.position == self.length + 1 then
      self.position = self.length
    end
  end
  
  if self.position == self.length then
    reward = 1
  elseif self.position == 1 then
    reward = 0.01
  end
  
  return reward, self.position, terminal
end

return StochasticDeepChain
