local alt = 'alt'
local cmd = 'cmd'
local ctrl = 'ctrl'
local shift = 'shift'
local rightalt = 'rightalt'
local rightcmd = 'rightcmd'
local rightctrl = 'rightctrl'
local rightshift = 'rightshift'

local flick = 'flick'
local hold = 'hold'

local ks = {}
ks['A'] = 'a'
ks['B'] = 'b'
ks['C'] = 'c'
ks['D'] = 'd'
ks['E'] = 'e'
ks['F'] = 'f'
ks['G'] = 'g'
ks['H'] = 'h'
ks['I'] = 'i'
ks['J'] = 'j'
ks['K'] = 'k'
ks['L'] = 'l'
ks['M'] = 'm'
ks['N'] = 'n'
ks['O'] = 'o'
ks['P'] = 'p'
ks['Q'] = 'q'
ks['R'] = 'r'
ks['S'] = 's'
ks['T'] = 't'
ks['U'] = 'u'
ks['V'] = 'v'
ks['W'] = 'w'
ks['X'] = 'x'
ks['Y'] = 'y'
ks['Z'] = 'z'
ks['~'] = '`'
ks['!'] = '1'
ks['@'] = '2'
ks['#'] = '3'
ks['$'] = '4'
ks['%'] = '5'
ks['^'] = '6'
ks['&'] = '7'
ks['*'] = '8'
ks['('] = '9'
ks[')'] = '0'
ks['_'] = '-'
ks['+'] = '='
ks['{'] = '['
ks['}'] = ']'
ks['|'] = '\\'
ks[':'] = ';'
ks['"'] = "'"
ks['<'] = ','
ks['>'] = '.'
ks['?'] = '/'


local function getKey(char)
  if ks[char] == nil then
    return char
  end
  return ks[char]
end

local function isShiftKey(char)
  return not not ks[char]
end

local KeyboardLayer = {}

function KeyboardLayer.new()
  local _self = {
    _binds = {}
  }
  setmetatable(_self, {__index = KeyboardLayer})
  return _self
end

function KeyboardLayer:bind(origin, replace)
  if self._binds[origin] then
    print("이미 키가 저장되어 있다.: ", origin)
  end
  self._binds[origin] = replace
end

local FlickFlag = {}
FlickFlag._layers = {}
FlickFlag._prepares = {}

function FlickFlag.bind(lflag, layer, prepare)
  FlickFlag._layers[lflag] = layer
  FlickFlag._prepares[lflag] = prepare
end

local HoldFlag = {}
HoldFlag._layers = {}
HoldFlag._alternatives = {}

function HoldFlag.bind(rflag, layer, alternative)
  HoldFlag._layers[rflag] = layer
  HoldFlag._alternatives[rflag] = alternative
end


local FlagStates = {
  alt = {
    name = alt,
    type = flick,
    onoff = false,
    time = 0,
  },
  cmd = {
    name = cmd,
    type = flick,
    onoff = false,
    time = 0,
  },
  ctrl = {
    name = ctrl,
    type = flick,
    onoff = false,
    time = 0,
  },
  shift = {
    name = shift,
    type = flick,
    onoff = false,
    time = 0,
  },
  rightalt = {
    name = rightalt,
    type = hold,
    onoff = false,
    time = 0,
  },
  rightcmd = {
    name = rightcmd,
    type = hold,
    onoff = false,
    time = 0,
  },
  rightctrl = {
    name = rightctrl,
    type = hold,
    onoff = false,
    time = 0,
  },
}


local currentFlag = nil
local activatedLayer = nil
local activatedFlag = nil
local withKey = nil
local pressedKey = false

local function startKeyEvent(actFlag, actLayer)
  if actFlag then
    activatedFlag = actFlag
  end
  if actLayer then
    activatedLayer = actLayer
  end
  withKey = nil
  KeyEvt:start()
end

local function stopKeyEvent()
  activatedFlag = nil
  activatedLayer = nil
  withKey = false
  KeyEvt:stop()
end

local flagsEvt = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function (evt)
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  local flags = evt:getFlags()
  --
  if key == alt or key == rightalt then
    if flags.alt == true and FlagStates[alt].onoff == true and FlagStates[rightalt].onoff == true then
      FlagStates[key].onoff = false
    else
      FlagStates[key].onoff = not not flags.alt
    end
  elseif key == cmd or key == rightcmd then
    if flags.cmd == true and FlagStates[cmd].onoff == true and FlagStates[rightcmd].onoff == true then
      FlagStates[key].onoff = false
    else
      FlagStates[key].onoff = not not flags.cmd
    end
  elseif key == ctrl or key == rightctrl then
    if flags.ctrl == true and FlagStates[ctrl].onoff == true and FlagStates[rightctrl].onoff == true then
      FlagStates[key].onoff = false
    else
      FlagStates[key].onoff = not not flags.ctrl
    end
  elseif key == shift or key == rightshift then
    key = shift
    FlagStates[key].onoff = not not flags.shift
  else
    return
  end
  FlagStates[key].time = hs.timer.absoluteTime()
  --
  local holdCount = 0
  local flickCount = 0
  for _, flag in pairs(FlagStates) do
    if flag.onoff == true then
      if flag.type == hold then
        holdCount = holdCount + 1
      else
        flickCount = flickCount + 1
      end
    end
  end
  --
  if FlagStates[key].type == flick then
    if (holdCount + flickCount) == 0 and currentFlag == FlagStates[key] and pressedKey == false then
      currentFlag = FlagStates[key]
      _ObserveEvt:stop()
      activatedLayer = FlickFlag._layers[key]
      activatedFlag = currentFlag
      if type(FlickFlag._prepares[key]) == 'string' then
        hs.eventtap.keyStroke({}, FlickFlag._prepares[key])
        _PreparedEvt:start()
      elseif type(FlickFlag._prepares[key]) == 'function' then
        FlickFlag._prepares[key](evt)
        startKeyEvent()
      else
        startKeyEvent()
      end
      return
    end
    if (holdCount + flickCount) == 1 and FlagStates[key].onoff == true then
      stopKeyEvent()
      pressedKey = false
      _ObserveEvt:start()
    end
    currentFlag = FlagStates[key]
    return
  end
  --
  currentFlag = FlagStates[key]
  --
  if currentFlag.type == hold then
    if currentFlag.onoff == true then
      if (flickCount + holdCount) == 1 then
        startKeyEvent(currentFlag, HoldFlag._layers[key])
      elseif type(HoldFlag._alternatives[key]) == 'string' then
        local mods = {}
        for _, flag in pairs(FlagStates) do
          if flag.type == flick and flag.onoff == true then
            mods[#mods + 1] = flag.name
          end
        end
        if #mods ~= 0 then
          local alternative = HoldFlag._alternatives[key]
          if isShiftKey(alternative) then
            mods[#mods + 1] = shift
          end
          hs.eventtap.keyStroke(mods, getKey(alternative))
        end
      end
      return
    end
    if currentFlag.onoff == false and activatedFlag == currentFlag then
      if withKey == nil then
        stopKeyEvent()
        local alternative = HoldFlag._alternatives[key]
        if type(alternative) == 'string' then
          local mods = {}
          for _, flag in pairs(FlagStates) do
            if flag.type == flick and flag.onoff == true then
              mods[#mods + 1] = flag.name
            end
          end
          if isShiftKey(alternative) then
            mods[#mods + 1] = shift
          end
          hs.eventtap.keyStroke(mods, getKey(alternative))
        elseif type(alternative) == 'function' then
          alternative()
        end
        return
      end
      stopKeyEvent()
      return
    end
  end
end)
flagsEvt:start()


_ObserveEvt = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  pressedKey = true
  _ObserveEvt:stop()
end)

_PreparedEvt = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  _PreparedEvt:stop()
  startKeyEvent()
end)


local keyEvt = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  local flags = evt:getFlags()
  local actFlag = activatedFlag
  local actLayer = activatedLayer
  withKey = key
  --
  if not actFlag then
    stopKeyEvent()
    return
  end
  if not actLayer then
    stopKeyEvent()
    return
  end
  if actFlag.type == flick then
    stopKeyEvent()
    local period = hs.timer.absoluteTime() - actFlag.time
    if period > 1000000000 then
      return
    end
  end
  --
  -- evt:setFlags({})
  local char = actLayer._binds[key]
  if char then
    if type(char) == 'string' then
      local mods = {}
      if FlagStates.alt.onoff == true then
        mods[alt] = true
      end
      if FlagStates.cmd.onoff == true then
        mods[cmd] = true
      end
      if FlagStates.ctrl.onoff == true then
        mods[ctrl] = true
      end
      if FlagStates.shift.onoff == true then
        mods[shift] = true
      end
      if isShiftKey(char) then
        mods[shift] = true
      end
      evt:setFlags(mods)
      evt:setKeyCode(hs.keycodes.map[getKey(char)])
      return
    end
    if type(char) == 'function' then
      char(evt)
      return true
    end
  end
end)

return {
  KeyboardLayer = KeyboardLayer,
  FlickFlag = FlickFlag,
  HoldFlag = HoldFlag,
}
