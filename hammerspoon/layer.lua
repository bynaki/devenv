local Indicator = require('indicator')


local KeyboardLayer = {}

function KeyboardLayer.new(color)
  local _self = {
    -- indicator = Indicator.new(hs.drawing.color.lists()['Apple'][color]),
    _binds = {}
  }
  setmetatable(_self, {__index = KeyboardLayer})
  return _self
end

function KeyboardLayer:bind(origin, replace)
  self._binds[origin] = replace
end


local WhenHoldKey = {}
WhenHoldKey._binds = {
}

function WhenHoldKey.register(key, layer)
  WhenHoldKey._binds[key] = layer
end


local activatedLayer = nil
local usedLayer = false

_hold_down = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  local flags = evt:getFlags()
  if activatedLayer then
    if activatedLayer._binds[key] then
      local obj = activatedLayer._binds[key]
      usedLayer = true
      _hold_up:start()
      if type(obj) == 'function' then
        return obj()
      else
        hs.eventtap.keyStroke({}, obj)
        return true
      end
    end
  else
    if WhenHoldKey._binds[key] then
      activatedLayer = WhenHoldKey._binds[key]
      return true
    end
  end
end)

_hold_up = hs.eventtap.new({hs.eventtap.event.types.keyUp}, function (evt)
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  local flags = evt:getFlags()
  if WhenHoldKey._binds[key] then
    activatedLayer = nil
    _hold_up:stop()
    if usedLayer then
      usedLayer = false
      return true
    end
  end
end)

local layer = KeyboardLayer.new()
layer:bind('2', '1')

WhenHoldKey.register('1', layer)

_hold_down:start()

