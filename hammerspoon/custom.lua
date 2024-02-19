local cc = require('commander')
local Commander = cc.Commander
local KeyEvent = cc.KeyEvent


-- Customize Esc Key & Custom Key
-- Esc키 눌렀을때 강제로 영문키로 변경, Capslock off for Vim
--
local custom = Commander.new('')

local inputEng = 'com.apple.keylayout.ABC'
local function escapeWithChangedInput()
  local input_source = hs.keycodes.currentSourceID()
  if not (input_source == inputEng) then
      hs.keycodes.currentSourceID(inputEng)
  end
  hs.hid.capslock.set(false)
  hs.eventtap.keyStroke({}, 'escape')
end

local withKey = nil
_custom_evt = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  local flags = evt:getFlags()
  withKey = key
  print(key)
  local list = custom.binds[key]
  if list then
    for i = 1, #list do
      if flags:containExactly(list[i].modifiers) then
        local e = KeyEvent.new(evt)
        return list[i].callback(e)
      end
    end
  end
  return false
end)

-- Change Input Source :: 한영키 지정 --
--
local inputSource = {
    english = "com.apple.keylayout.ABC",
    korean = "com.apple.inputmethod.Korean.2SetKorean",
}
local function changeInput()
  local current = hs.keycodes.currentSourceID()
  local nextInput = nil
  if current == inputSource.english then
    nextInput = inputSource.korean
  else
    nextInput = inputSource.english
  end
  hs.keycodes.currentSourceID(nextInput)
end

_rctrl_evt = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function (evt)
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  local flags = evt:getFlags()
  -- 한글입력
  if key == 'rightalt' then
    if flags.alt == true then
      changeInput()
      return true
    end
  end
  if key ~= 'rightctrl' then
    return false
  end
  if flags.ctrl == true then
    withKey = nil
    _custom_evt:start()
  else
    _custom_evt:stop()
    if withKey == nil then
      escapeWithChangedInput()
    end
  end
  return false
end)
_rctrl_evt:start()

return custom
