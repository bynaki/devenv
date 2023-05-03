do -- Reload Hammerspoon
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'r', hs.reload)
end

local toggle = false
local Indicator = require('indicator')
local indi = Indicator.new(hs.drawing.color.osx_green)
hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 't', function ()
  if toggle then
    indi:desable()
    toggle = false
  else
    indi:enable()
    toggle = true
  end
end)


local prevWin = nil
do -- Launch or Focus Terminal
  hs.hotkey.bind({'cmd'}, 'return', function()
    local front = hs.application.frontmostApplication()
    print(front:name())
    if front:name() == 'Alacritty' then
      if prevWin ~= nil then
        prevWin:focus()
      end
    else
      prevWin = hs.window.focusedWindow()
      hs.application.launchOrFocus('Alacritty')
    end
  end)
end

do -- Window Hints
  hs.hints.hintChars = {'A', 'S', 'D', 'F', 'Q', 'W', 'E', 'R'}
  hs.hotkey.bind({'shift'}, 'tab', hs.hints.windowHints)
end

do -- 윈도우창 크기 조절
  local function moveToLeft()
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    local screen = win:screen():frame()
    if frame.x == screen.x and frame.w == math.floor(screen.w / 2) then
      frame.w = screen.w / 3
    elseif frame.x == screen.x and frame.w == math.floor(screen.w / 3) then
      frame.w = screen.w / 1.5
    else
      frame.w = screen.w / 2
    end
    frame.x = screen.x
    frame.y = screen.y
    frame.h = screen.h
    win:setFrame(frame)
  end

  local function moveToRight()
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    local screen = win:screen():frame()
    if frame.x ~= screen.x and frame.w == math.floor(screen.w / 2) then
      frame.w = screen.w / 3
    elseif frame.x ~= screen.x and frame.w == math.floor(screen.w / 3) then
      frame.w = screen.w / 1.5
    else
      frame.w = screen.w / 2
    end
    frame.x = screen.x + (screen.w - frame.w)
    frame.y = screen.y
    frame.h = screen.h
    win:setFrame(frame)
  end

  local function moveToTop()
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    local screen = win:screen():frame()
    if frame.y == screen.y and frame.h == math.floor(screen.h / 2) then
      frame.h = screen.h / 3
    elseif frame.y == screen.y and frame.h == math.floor(screen.h / 3) then
      frame.h = screen.h / 1.5
    else
      frame.h = screen.h / 2
    end
    frame.y = screen.y
    win:setFrame(frame)
  end

  local function moveToBottom()
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    local screen = win:screen():frame()
    if frame.y ~= screen.y and frame.h == math.floor(screen.h / 2) then
      frame.h = screen.h / 3
    elseif frame.y ~= screen.y and frame.h == math.floor(screen.h / 3) then
      frame.h = screen.h / 1.5
    else
      frame.h = screen.h / 2
    end
    frame.y = screen.y + (screen.h - frame.h)
    win:setFrame(frame)
  end

  local function maxWindow()
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    local screen = win:screen():frame()
    frame.x = screen.x
    frame.y = screen.y
    frame.w = screen.w
    frame.h = screen.h
    win:setFrame(frame)
  end

  -- 키 맵핑
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'left', moveToLeft)
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'Right', moveToRight)
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'Up', moveToTop)
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'Down', moveToBottom)
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'Down', moveToBottom)
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'Return', maxWindow)
end

-- do -- 현제 입력소스 확인
--   hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'i', function()
--     local input_source = hs.keycodes.currentSourceID()
--     print(input_source)
--   end)
-- end

do  -- Change Input Source :: 한영키 지정
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
  -- hs.hotkey.bind({'shift'}, 'space', changeInput)
  hs.hotkey.bind({}, 'f13', changeInput)
end

do -- Esc키 눌렀을때 강제로 영문키로 변경 for Vim
  local inputEng = 'com.apple.keylayout.ABC'
  local function escapeWithChangedInput()
    local input_source = hs.keycodes.currentSourceID()
    if not (input_source == inputEng) then
        hs.keycodes.currentSourceID(inputEng)
    end
    hs.eventtap.keyStroke({}, 'escape')
  end
  -- hs.hotkey.bind({'ctrl'}, 'c', escapeWithChangedInput)
  hs.hotkey.bind({}, 'f14', escapeWithChangedInput)
end

local function layoutApple() -- Remapping Keyboard Layout: Apple
  local FRemap = require('foundation_remapping')
  local remapper = FRemap.new()
  remapper:remap('rcmd', 'f13')
  remapper:remap('capslock', 'f14')
  remapper:register()
end

local function layout68Keys() -- Remapping Keyboard Layout: 68Keys
  local FRemap = require('foundation_remapping')
  local remapper = FRemap.new()
  remapper:remap('lcmd', 'lalt')
  remapper:remap('lalt', 'lcmd')
  remapper:remap('rctl', 'ralt')
  remapper:remap('ralt', 'f13')
  remapper:remap('capslock', 'f14')
  remapper:register()
end

local function layoutAlice80() -- Remapping Keyboard Layout: Alice80
  local FRemap = require('foundation_remapping')
  local remapper = FRemap.new()
  remapper:remap('capslock', 'f14')
  remapper:remap('escape', '`')
  remapper:register()
end

local chooser = hs.chooser.new(function(choice)
  if choice.text == 'Keyboard Layout: Apple' then
    layoutApple()
    hs.alert.show(choice.text)
  elseif choice.text == 'Keyboard Layout: 68Keys' then
    layout68Keys()
    hs.alert.show(choice.text)
  elseif choice.text == 'Keyboard Layout: Alice80' then
    layoutAlice80()
    hs.alert.show(choice.text)
  else
    hs.alert.show('I don\'t know about "' + choice.text + '"')
  end
end)

do -- Open Chooser
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, '\\', function()
    local list = {}
    table.insert(list, {
      text = 'Keyboard Layout: Apple',
      subText = 'Apple Keyboard Layout'
    })
    table.insert(list, {
      text = 'Keyboard Layout: 68Keys',
      subText = '68 Keys Keyboard Layout'
    })
    table.insert(list, {
      text = 'Keyboard Layout: Alice80',
      subText = 'Alice80 Keyboard Layout'
    })
    chooser:choices(list)
    chooser:show()
  end)
end

layoutApple() -- default apple keyboard layout
