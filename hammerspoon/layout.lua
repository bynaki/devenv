local alt = 'alt'
local cmd = 'cmd'
local ctrl = 'ctrl'
local shift = 'shift'
local rightalt = 'rightalt'
local rightcmd = 'rightcmd'
local rightctrl = 'rightctrl'
local rightshift = 'rightshift'


local function flagMask(raw, mask)
  return raw & mask ~= 0
end

local function flag(raw, mod)
  local masks = hs.eventtap.event.rawFlagMasks
  if mod == alt then
    return flagMask(raw, masks['deviceLeftAlternate'])
  end
  if mod == cmd then
    return flagMask(raw, masks['deviceLeftCommand'])
  end
  if mod == ctrl then
    return flagMask(raw, masks['deviceLeftControl'])
  end
  if mod == shift then
    return flagMask(raw, masks['deviceLeftShift'])
  end
  if mod == rightalt then
    return flagMask(raw, masks['deviceRightAlternate'])
  end
  if mod == rightcmd then
    return flagMask(raw, masks['deviceRightCommand'])
  end
  if mod == rightctrl then
    return flagMask(raw, masks['deviceRightControl'])
  end
  if mod == rightshift then
    return flagMask(raw, masks['deviceRightShift'])
  end
  return false
end

_Test = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function (evt)
  local raw = evt:rawFlags()
  print('alt        =', flag(raw, alt))
  print('cmd        =', flag(raw, cmd))
  print('ctrl       =', flag(raw, ctrl))
  print('shift      =', flag(raw, shift))
  print('rightalt   =', flag(raw, rightalt))
  print('rightcmd   =', flag(raw, rightcmd))
  print('rightctrl  =', flag(raw, rightctrl))
  print('rightshift =', flag(raw, rightshift))
end)
-- _Test:start()


-- 특정 문자가 배열에 있는지 확인하는 함수
local function containsChar(arr, target)
  for _, char in ipairs(arr) do
      if char == target then
          return true -- 문자가 발견되면 true 반환
      end
  end
  return false -- 문자가 없으면 false 반환
end

local function strFlags(flags)
  local str = ':only:'
  if containsChar(flags, cmd) then
    str = str .. ':cmd:'
  end
  if containsChar(flags, ctrl) then
    str = str .. ':ctrl:'
  end
  if containsChar(flags, alt) then
    str = str .. ':alt:'
  end
  if containsChar(flags, shift) then
    str = str .. ':shift:'
  end
  return str
end


local KeyLayer = {}

function KeyLayer.new()
  local _self = {
    _binds = {}
  }
  setmetatable(_self, {__index = KeyLayer})
  return _self
end

function KeyLayer:bind(key, act)
  if self._binds[key] then
    print("이미 키가 저장되어 있다.: ", key)
  end
  self._binds[key] = act
end


local _layouts = {}

local Layout = {}

-- prefix는 rightalt, rightcmd, rightctrl, rightshift
function Layout.new(prefix)
  local _self = {
    _prefix = prefix,
    _layers = {},
  }
  setmetatable(_self, {__index = Layout})
  _layouts[prefix] = _self
  return _self
end

function Layout:add(flags, layer)
  local str = strFlags(flags)
  self._layers[str] = layer
end


local flagsState = {
  rightcmd   = false,
  rightctrl  = false,
  rightalt   = false,
  rightshift = false,
  cmd        = false,
  ctrl       = false,
  alt        = false,
  shift      = false,
}

KeyEvt = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  local raw = evt:rawFlags()
  -- print('flags state ---------------------')
  -- print('alt        =', flag(raw, alt))
  -- print('cmd        =', flag(raw, cmd))
  -- print('ctrl       =', flag(raw, ctrl))
  -- print('shift      =', flag(raw, shift))
  -- print('rightalt   =', flag(raw, rightalt))
  -- print('rightcmd   =', flag(raw, rightcmd))
  -- print('rightctrl  =', flag(raw, rightctrl))
  -- print('rightshift =', flag(raw, rightshift))
  ---
  local layout = nil
  if flag(raw, rightcmd) then
    layout = _layouts[rightcmd]
  end
  if not layout and flag(raw, rightctrl) then
    layout = _layouts[rightctrl]
  end
  if not layout and flag(raw, rightalt) then
    layout = _layouts[rightalt]
  end
  if not layout and flag(raw, rightshift) then
    layout = _layouts[rightshift]
  end
  if not layout then
    return
  end
  ---
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  local flags = {}
  if flag(raw, cmd) then
    table.insert(flags, cmd)
  end
  if flag(raw, ctrl) then
    table.insert(flags, ctrl)
  end
  if flag(raw, alt) then
    table.insert(flags, alt)
  end
  if flag(raw, shift) then
    table.insert(flags, shift)
  end
  local layer = layout._layers[strFlags(flags)]
  if not layer then
    return
  end
  local act = layer._binds[key]
  if act then
    act()
    return true
  end
end)
KeyEvt:start()

return {
  KeyLayer = KeyLayer,
  Layout = Layout,
  alt = alt,
  cmd = cmd,
  ctrl = ctrl,
  shift = shift,
  rightalt = rightalt,
  rightcmd = rightcmd,
  rightctrl = rightctrl,
  rightshift = rightshift,
}
