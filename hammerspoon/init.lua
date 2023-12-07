local cc = require('commander')
local trigger = cc.trigger
local Commander = cc.Commander
local snippet = cc.snippet

local cmd = Commander.new('Green')



-- Reload Hammerspoon --
--
do
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'r', hs.reload)
  cmd:bind({}, 'r', hs.reload)
end


-- Toggle Hammerspoon Console --
--
do
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'c', hs.toggleConsole)
  cmd:bind({}, 'c', hs.toggleConsole)
end



-- Launch or Focus Terminal --
--
local prevWin = nil
do
  hs.hotkey.bind({'cmd'}, ';', function()
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



-- 윈도우창 크기 조절 --
--
do
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
    return true
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
    return true
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
    return true
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
    return true
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
    return false
  end

  -- for record 16:10 
  local function moveToLeftForScreenshot()
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    local screen = win:screen():frame()
    local full = win:screen():fullFrame()
    frame.x = screen.x
    frame.y = screen.y
    frame.w = math.floor(full.h * 1.6)
    frame.h = screen.h
    win:setFrame(frame)
    return false
  end

  -- for record 16:10 
  local function moveToRightForScreenshot()
    local win = hs.window.focusedWindow()
    local full = win:screen():fullFrame()
    local screen = win:screen():frame()
    local space = math.floor(full.h * 1.6)
    if screen.w - space < 100 then
      return false
    end
    local frame = win:frame()
    frame.x = screen.x + space
    frame.y = screen.y
    frame.w = screen.w - space
    frame.h = screen.h
    win:setFrame(frame)
    return false
  end

  -- 윈도우창 크기 조절
  cmd:bind({'cmd'}, 'h', moveToLeft)
  cmd:bind({'cmd'}, 'l', moveToRight)
  cmd:bind({'cmd'}, 'k', moveToTop)
  cmd:bind({'cmd'}, 'j', moveToBottom)
  cmd:bind({'cmd'}, 'm', maxWindow)
  cmd:bind({'ctrl'}, 'h', moveToLeftForScreenshot)
  cmd:bind({'ctrl'}, 'l', moveToRightForScreenshot)
end



-- do -- 현제 입력소스 확인
--   hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'i', function()
--     local input_source = hs.keycodes.currentSourceID()
--     print(input_source)
--   end)
-- end



-- Change Input Source :: 한영키 지정 --
--
do
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
  trigger.bind(';', 'j', changeInput)
end



-- Esc키 눌렀을때 강제로 영문키로 변경 for Vim --
--
do
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



-- Keyboard Layouts --
--
do
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
    remapper:remap('rctl', 'f15')
    remapper:register()
    -- tmux key
    hs.hotkey.bind({}, 'f15', function()
      hs.eventtap.keyStroke({'ctrl'}, 'b')
    end)
  end

  local chooser = hs.chooser.new(function(choice)
    if not choice then
      return
    end
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

  -- Open Layout Chooser
  local function openLayoutChooser()
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
  end

  cmd:bind({}, 'o', openLayoutChooser)
  layoutAlice80() -- default apple keyboard layout
end



-- Get Colors --
--
do
  local function getColors()
    local colors = ''
    for key, value in pairs(hs.drawing.color.lists()['Apple']) do
      colors = colors .. ' ' .. key
    end
    hs.alert.show(colors)
  end

  cmd:bind({}, 'c', getColors)
end



-- Swap Desktop --
--
do
  -- Left Swap
  local function leftSwap()
    local ids = hs.spaces.spacesForScreen()
    local focus = hs.spaces.focusedSpace()
    local pre = nil
    for i = 1, #ids do
      if ids[i] == focus and pre then
        hs.spaces.gotoSpace(pre)
      end
      pre = ids[i]
    end
    return true
  end

  -- Right Swap
  local function rightSwap()
    local ids = hs.spaces.spacesForScreen() local focus = hs.spaces.focusedSpace()
    for i = 1, #ids do
      if ids[i] == focus and i + 1 <= #ids then
        hs.spaces.gotoSpace(ids[i + 1])
      end
    end
    return true
  end

  cmd:bind({'shift'}, 'j', leftSwap)
  cmd:bind({'shift'}, 'k', rightSwap)
end



-- Window Hints
--
do
  hs.hints.hintChars = {'A', 'S', 'D', 'F', 'Q', 'W', 'E', 'R'}
  cmd:bind({}, 'w', function()
    hs.hints.windowHints()
  end)
  hs.hotkey.bind({'shift'}, 'tab', hs.hints.windowHints)
end



-- Naver Dictionary
--
do
  local url = 'https://en.dict.naver.com/#/search?query='
  local blinkUrl = 'https://en.dict.naver.com'
  local naver = hs.webview.new({
    x = 0,
    y = 10,
    w = 1020,
    h = 1020,
  })
  naver:windowStyle('resizable')
  naver:allowTextEntry(true)

  cmd:bind({}, 'n', function ()
    print(hs.webview.windowMasks)
    if naver:isVisible() then
      naver:hide()
      return
    end
    local pasted = hs.pasteboard.readString()
    if pasted then
      if string.len(pasted) > 30 then
        naver:show()
        return
      end
      pasted = string.gsub(pasted, ' ', "%%20")
      naver:url(url .. pasted)
    end
    naver:show()
  end)
end


local vimMod = Commander.new('Red')

-- Vim Mode --
--
do
  cmd:bind({}, 'h', function (evt)
    evt:keyStroke({}, 'left')
    vimMod:enable()
    return true
  end)

  cmd:bind({}, 'j', function (evt)
    evt:keyStroke({}, 'down')
    vimMod:enable()
    return true
  end)

  cmd:bind({}, 'k', function (evt)
    evt:keyStroke({}, 'up')
    vimMod:enable()
    return true
  end)

  cmd:bind({}, 'l', function (evt)
    evt:keyStroke({}, 'right')
    vimMod:enable()
    return true
  end)

  vimMod:bind({}, 'h', function (evt)
    evt:keyStroke({}, 'left')
    return true
  end)

  vimMod:bind({}, 'j', function (evt)
    evt:keyStroke({}, 'down')
    return true
  end)

  vimMod:bind({}, 'k', function (evt)
    evt:keyStroke({}, 'up')
    return true
  end)

  vimMod:bind({}, 'l', function (evt)
    evt:keyStroke({}, 'right')
    return true
  end)

  vimMod:bind({}, 'i', function ()
    return false
  end)
end


trigger.bind(';', ';', function()
  cmd:enable()
end)


trigger.bind(';', 's', snippet)
