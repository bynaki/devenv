local Indicator = require('indicator')


local function keyStroke(modifiers, character, callback)
  hs.timer.doAfter(0, function()
    hs.eventtap.keyStroke(modifiers, character)
    if callback then
      callback()
    end
  end)
end

local function keyStrokes(text, callback)
  hs.timer.doAfter(0, function()
    hs.eventtap.keyStrokes(text)
    if callback then
      callback()
    end
  end)
end


local KeyEvent = {}

function KeyEvent.new(evt)
  local _self = {
    _evt = evt,
    block = true,
  }
  setmetatable(_self, {__index = KeyEvent})
  return _self
end

function KeyEvent:getKey()
  local code = self._evt:getKeyCode()
  return hs.keycodes.map(code)
end

function KeyEvent:getFlags()
  return self._evt:getFlags()
end

function KeyEvent:keyStroke(modifiers, key)
  self._evt:setFlags(modifiers)
  self._evt:setKeyCode(hs.keycodes.map[key])
  self.block = false
end

local enabledCmd = nil

_event = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  if not enabledCmd then
    return false
  end
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  local flags = evt:getFlags()
  if key == 'escape' or key == 'f14' then
    enabledCmd:disable()
    return true
  end
  if enabledCmd.binds[key] then
    local list = enabledCmd.binds[key]
    for i = 1, #list do
      if flags:containExactly(list[i].modifiers) then
        local e = KeyEvent.new(evt)
        local continue = list[i].callback(e)
        if continue then
          return e.block
        end
        if enabledCmd then
          enabledCmd:disable()
        end
        return true
      end
    end
  end
  enabledCmd:disable()
  return false
end)
_event:start()



local Commander = {}

function Commander.new(color)
  local _self = {
    indicator = Indicator.new(hs.drawing.color.lists()['Apple'][color]),
    binds = {},
  }
  setmetatable(_self, {__index = Commander})
  return _self
end

function Commander:bind(modifiers, key, callback)
  if not self.binds[key] then
    self.binds[key] = {}
  end
  table.insert(self.binds[key], {
    modifiers = modifiers,
    callback = callback,
  })
end
function Commander:enable()
  if enabledCmd and enabledCmd == self then
    return
  end
  if enabledCmd then
    enabledCmd:disable()
  end
  self.indicator:enable()
  enabledCmd = self
end

function Commander:disable()
  if enabledCmd == self then
    self.indicator:disable()
    -- self._event:stop()
    enabledCmd = nil
    _task1:start()
  end
end



local trigger = {
  _binds = {}
}

-- triger:bind()
function trigger.bind(oneKey, twoKey, callback)
  if not trigger._binds[oneKey] then
    trigger._binds[oneKey] = {}
  end
  trigger._binds[oneKey][twoKey] = callback
end



local oneKey = nil

_task1 = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  local flags = evt:getFlags()
  if not flags:containExactly({}) then
    return false
  end
  local char = evt:getCharacters()
  if trigger._binds[char] then
    oneKey = {
      key = char,
      binds = trigger._binds[char],
      timer = hs.timer.doAfter(1, function ()
        hs.eventtap.keyStrokes('a' .. char)
        _task2:stop()
        oneKey = nil
        _task1:start()
      end)
    }
    _task1:stop()
    _task2:start()
    return true
  end
  return false
end)
_task1:start()



_task2 = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  _task2:stop()
  oneKey.timer:stop()
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  if key == 'escape' or key == 'f14' then
    hs.eventtap.keyStroke({}, oneKey.key)
    hs.eventtap.keyStroke({}, 'escape')
    oneKey = nil
    _task1:start()
    return true
  end
  local char = evt:getCharacters()
  -- print('task2: ', key)
  local cb = oneKey.binds[char]
  if not cb then
    keyStrokes(oneKey.key .. char, function()
      oneKey = nil
      _task1:start()
    end)
    return true
  end
  oneKey = nil
  cb()
  return true
end)



return {
  trigger = trigger,
  Commander = Commander,
  keyStroke = keyStroke,
  keyStrokes = keyStrokes,
}
