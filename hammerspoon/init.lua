local layer = require('layer')
local KeyboardLayer = layer.KeyboardLayer
local FlickFlag = layer.FlickFlag
local HoldFlag = layer.HoldFlag


-- Customize Esc Key & Custom Key
-- Esc키 눌렀을때 강제로 영문키로 변경, Capslock off for Vim
--
local inputEng = 'com.apple.keylayout.ABC'
local function escapeWithChangedInput()
  local input_source = hs.keycodes.currentSourceID()
  if not (input_source == inputEng) then
      hs.keycodes.currentSourceID(inputEng)
  end
  hs.hid.capslock.set(false)
  hs.eventtap.keyStroke({}, 'escape')
end

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

_TestEvt = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  local flags = evt:getFlags()
  print('key:', key, 'alt:', flags.alt, 'cmd:', flags.cmd, 'ctrl:', flags.ctrl, 'shift:', flags.shift)
  print('-------------------------------------')
end)

local layer01 = KeyboardLayer.new()
layer01:bind('y', '^')
layer01:bind('u', '&')
layer01:bind('i', '*')
layer01:bind('o', '(')
layer01:bind('p', ')')
layer01:bind('[', 'delete')
layer01:bind('h', 'left')
layer01:bind('j', 'down')
layer01:bind('k', 'up')
layer01:bind('l', 'right')
layer01:bind(';', '=')
layer01:bind("'", 'return')
layer01:bind('n', '}')
layer01:bind('m', ']')
layer01:bind(',', '+')
layer01:bind('.', '-')
layer01:bind('/', '_')
layer01:bind('left', 'up')
HoldFlag.bind('rightctrl', layer01, escapeWithChangedInput)

local layer02 = KeyboardLayer.new()
layer02:bind('tab', '`')
layer02:bind('q', '!')
layer02:bind('w', '@')
layer02:bind('e', '#')
layer02:bind('r', '$')
layer02:bind('t', '%')
layer02:bind('a', 'forwarddelete')
layer02:bind('s', 'home')
layer02:bind('d', 'pageup')
layer02:bind('f', 'pagedown')
layer02:bind('g', 'end')
layer02:bind('z', '~')
layer02:bind('x', '\\')
layer02:bind('c', '|')
layer02:bind('v', '[')
layer02:bind('b', '{')
HoldFlag.bind('rightalt', layer02, changeInput)

local layer03 = KeyboardLayer.new()
HoldFlag.bind('rightcmd', layer03, 'return')
layer03:bind('z', '0')
layer03:bind('x', '1')
layer03:bind('c', '2')
layer03:bind('v', '3')
layer03:bind('s', '4')
layer03:bind('d', '5')
layer03:bind('f', '6')
layer03:bind('w', '7')
layer03:bind('e', '8')
layer03:bind('r', '9')
layer03:bind('a', '=')
layer03:bind('q', '+')
layer03:bind('tab', '/')
layer03:bind('b', '.')
layer03:bind('g', '-')
layer03:bind('t', '*')
layer03:bind('m', 'f1')
layer03:bind(',', 'f2')
layer03:bind('.', 'f3')
layer03:bind('j', 'f4')
layer03:bind('k', 'f5')
layer03:bind('l', 'f6')
layer03:bind('u', 'f7')
layer03:bind('i', 'f8')
layer03:bind('o', 'f9')
layer03:bind('/', 'f10')
layer03:bind("'", 'f11')
layer03:bind("p", 'f12')
layer03:bind('n', 'f13')
layer03:bind('h', 'f14')
layer03:bind('y', 'f15')

local layer04 = KeyboardLayer.new()
layer04:bind('t', function ()
  if not _TestEvt:isEnabled() then
    _TestEvt:start()
  else
    _TestEvt:stop()
  end
end)
layer04:bind('b', function ()
  hs.eventtap.keyStroke({'ctrl'}, 'escape')
end)
FlickFlag.bind('cmd', layer04)

-- for tmux --
FlickFlag.bind('ctrl', nil, function()
  hs.eventtap.keyStroke({'ctrl'}, 'b')
end)


-- Reload Hammerspoon --
--
do
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'r', hs.reload)
  layer04:bind('r', hs.reload)
end


-- Toggle Hammerspoon Console --
--
do
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'c', hs.toggleConsole)
  layer04:bind('c', hs.toggleConsole)
end


-- Launch or Focus Terminal --
--
local prevWin = nil
do
  function focusTerminal()
    local front = hs.application.frontmostApplication()
    if front:name() == 'Alacritty' then
      if prevWin ~= nil then
        prevWin:focus()
      end
    else
      prevWin = hs.window.focusedWindow()
      hs.application.launchOrFocus('Alacritty')
    end
  end

  layer04:bind(';', focusTerminal)
  hs.hotkey.bind({'cmd'}, ';', focusTerminal)
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
  layer04:bind('h', moveToLeft)
  layer04:bind('l', moveToRight)
  layer04:bind('k', moveToTop)
  layer04:bind('j', moveToBottom)
  layer04:bind('m', maxWindow)
  layer04:bind('u', moveToLeftForScreenshot)
  layer04:bind('i', moveToRightForScreenshot)
end


-- Custom Key
--
do
  -- toggle capslock
  layer04:bind('a', hs.hid.capslock.toggle)

  -- copy
  layer04:bind('y', function (evt)
    hs.eventtap.keyStroke({'cmd'}, 'c')
  end)

  -- paste
  layer04:bind('p', function (evt)
    hs.eventtap.keyStroke({'cmd'}, 'v')
  end)

  -- -- right tap
  -- layer04:bind('k', function (evt)
  --   hs.eventtap.keyStroke({'alt', 'cmd'}, 'right')
  -- end)

  -- -- left tap
  -- layer04:bind('j', function (evt)
  --   hs.eventtap.keyStroke({'alt', 'cmd'}, 'left')
  -- end)

  -- full size
  layer04:bind('f', function (evt)
    hs.eventtap.keyStroke({'ctrl', 'cmd'}, 'f')
  end)

  -- Keyboard-driven expose
  --
  -- default windowfilter
  local expose = hs.expose.new(nil, {showThumbnail=true})
  layer04:bind('space', function (evt)
    expose:toggleShow()
  end)
  -- Active application
  local expose_app = hs.expose.new(nil, {onlyActiveApplication=true})
  layer04:bind(',', function ()
    expose_app:toggleShow()
  end)


  -- Cheatsheet --
  --
  local v = hs.webview.new()
  v:shadow(true)
  v:bringToFront()

  local function toggleCheatsheet(imgPath)
    if v:isVisible() then
      v:hide()
      return
    end
    local imgObj = hs.image.imageFromPath(imgPath)
    if not imgObj then
      print("not be image")
      return
    end
    local win = hs.window.focusedWindow()
    local screen = win:screen():frame()
    local size = imgObj:size()
    if size.w > screen.w then
      imgObj = imgObj:setSize({w = screen.w, h = 5000})
      size = imgObj:size()
    end
    local img = imgObj:encodeAsURLString()
    local f = io.open("./template.html", 'r')
    if not f then
      print("not be template")
      return
    end
    local template = f:read("*a")
    f:close()
    local html = string.format(template, img)
    local w = size.w
    local h = math.min(size.h, screen.h)
    local x = (screen.w / 2) - (w / 2)
    local y = (screen.h / 2) - (h / 2)
    v:frame({
      x = x,
      y = y,
      w = w,
      h = h,
    })
    v:html(html)
    v:show()
  end

  -- cheatsheet keyboard layer --
  layer04:bind('d', function ()
    toggleCheatsheet("./assets/keyboard-layers.png")
  end)

  -- cheatsheet vim map --
  layer04:bind('v', function ()
    toggleCheatsheet("./assets/vim-cheatsheet.png")
  end)

  -- cheatsheet tmux --
  layer04:bind('x', function ()
    toggleCheatsheet("./assets/tmux-cheatsheet.png")
  end)
end


-- Keyboard Layouts --
--
do
  local FRemap = require('foundation_remapping')
  local current_map = nil

  local function unregisterLayout()  -- Unregister Keyboard Layout
    if current_map then
      current_map:unregister()
      current_map = nil
    end
  end

  local function newRemapper()
    local remapper = FRemap.new()
    remapper:remap('capslock', 'escape')
    return remapper
  end

  local function newRemapperLayer()
    local remapper = FRemap.new()
    remapper:remap('capslock', 'rctl')
    remapper:remap('return', 'rcmd')
    return remapper
  end

  local function layoutDefault() -- Remapping Default Layout
    unregisterLayout()
  end

  local function layoutApple() -- Remapping Keyboard Layout: Apple Keyboard
    unregisterLayout()
    local remapper = newRemapper()
    remapper:register()
    current_map = remapper
  end

  local function layoutAppleLayer() -- Remapping Keyboard Layout: Apple Keyboard (Layer Version)
    unregisterLayout()
    local remapper = newRemapperLayer()
    remapper:register()
    current_map = remapper
  end

  local function layoutWindows() -- Remapping Keyboard Layout: Windows Keyboard
    unregisterLayout()
    local remapper = newRemapper()
    remapper:remap('lcmd', 'lalt')
    remapper:remap('lalt', 'lcmd')
    remapper:remap('rctl', 'ralt')
    remapper:register()
    current_map = remapper
  end

  local function layoutWindowsLayer() -- Remapping Keyboard Layout: Windows Keyboard (Layer Version)
    unregisterLayout()
    local remapper = newRemapperLayer()
    remapper:remap('lcmd', 'lalt')
    remapper:remap('lalt', 'lcmd')
    remapper:remap('rctl', 'ralt')
    remapper:register()
    current_map = remapper
  end

  local function layout68Keys() -- Remapping Keyboard Layout: 68Keys Keyboard
    unregisterLayout()
    local remapper = newRemapper()
    remapper:remap('escape', '`')
    remapper:remap('lcmd', 'lalt')
    remapper:remap('lalt', 'lcmd')
    remapper:remap('rctl', 'ralt')
    remapper:register()
    current_map = remapper
  end

  local function layout68KeysLayer() -- Remapping Keyboard Layout: 68Keys Keyboard (Layer Version)
    unregisterLayout()
    local remapper = newRemapperLayer()
    remapper:remap('escape', '`')
    remapper:remap('lcmd', 'lalt')
    remapper:remap('lalt', 'lcmd')
    remapper:remap('rctl', 'ralt')
    remapper:register()
    current_map = remapper
  end

  local function layoutAlice80() -- Remapping Keyboard Layout: Alice80 Keyboard
    unregisterLayout()
    local remapper = newRemapper()
    remapper:remap('escape', '`')
    remapper:remap('rctl', 'ralt')
    remapper:register()
    current_map = remapper
  end

  local function layoutAlice80Layer() -- Remapping Keyboard Layout: Alice80 Keyboard (Layer Version)
    unregisterLayout()
    local remapper = newRemapperLayer()
    remapper:remap('escape', '`')
    remapper:remap('rctl', 'ralt')
    remapper:register()
    current_map = remapper
  end

  local chooser = hs.chooser.new(function(choice)
    if not choice then
      return
    end
    if choice.text == 'Keyboard Layout: Default' then
      layoutDefault()
      hs.alert.show(choice.text)
    elseif choice.text == 'Keyboard Layout: Apple Keyboard' then
      layoutApple()
      hs.alert.show(choice.text)
    elseif choice.text == 'Keyboard Layout: Apple Keyboard (Layer Version)' then
      layoutAppleLayer()
      hs.alert.show(choice.text)
    elseif choice.text == 'Keyboard Layout: Windows Keyboard' then
      layoutWindows()
      hs.alert.show(choice.text)
    elseif choice.text == 'Keyboard Layout: Windows Keyboard (Layer Version)' then
      layoutWindowsLayer()
      hs.alert.show(choice.text)
    elseif choice.text == 'Keyboard Layout: 68Keys Keyboard' then
      layout68Keys()
      hs.alert.show(choice.text)
    elseif choice.text == 'Keyboard Layout: 68Keys Keyboard (Layer Version)' then
      layout68KeysLayer()
      hs.alert.show(choice.text)
    elseif choice.text == 'Keyboard Layout: Alice80 Keyboard' then
      layoutAlice80()
      hs.alert.show(choice.text)
    elseif choice.text == 'Keyboard Layout: Alice80 Keyboard (Layer Version)' then
      layoutAlice80Layer()
      hs.alert.show(choice.text)
    else
      hs.alert.show('I don\'t know about "' + choice.text + '"')
    end
  end)

  -- Open Layout Chooser
  local function openLayoutChooser()
    local list = {}
    table.insert(list, {
      text = 'Keyboard Layout: Default',
      subText = 'Default Keyboard Layout'
    })
    table.insert(list, {
      text = 'Keyboard Layout: Apple Keyboard',
      subText = 'Apple Keyboard Layout'
    })
    table.insert(list, {
      text = 'Keyboard Layout: Apple Keyboard (Layer Version)',
      subText = 'Apple Keyboard Layout (Layer Version)'
    })
    table.insert(list, {
      text = 'Keyboard Layout: Windows Keyboard',
      subText = 'Windows Keyboard Layout'
    })
    table.insert(list, {
      text = 'Keyboard Layout: Windows Keyboard (Layer Version)',
      subText = 'Windows Keyboard Layout (Layer Version)'
    })
    table.insert(list, {
      text = 'Keyboard Layout: 68Keys Keyboard',
      subText = '68 Keys Keyboard Layout'
    })
    table.insert(list, {
      text = 'Keyboard Layout: 68Keys Keyboard (Layer Version)',
      subText = '68 Keys Keyboard Layout (Layer Version)'
    })
    table.insert(list, {
      text = 'Keyboard Layout: Alice80 Keyboard',
      subText = 'Alice80 Keyboard Layout'
    })
    table.insert(list, {
      text = 'Keyboard Layout: Alice80 Keyboard (Layer Version)',
      subText = 'Alice80 Keyboard Layout (Layer Version)'
    })
    chooser:choices(list)
    chooser:show()
  end
  --
  layer04:bind('o', openLayoutChooser)
  layoutWindowsLayer() -- default keyboard layout
end



-- Window Hints
--
do
  hs.hints.hintChars = {'A', 'S', 'D', 'F', 'Q', 'W', 'E', 'R'}
  layer04:bind('w', function()
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

  layer04:bind('n', function ()
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


-- key info
--
do
  local keyInfoEvt = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
    local code = evt:getKeyCode()
    local key = hs.keycodes.map[code]
    hs.alert.show(key)
  end)
  layer04:bind('/', function ()
    if keyInfoEvt:isEnabled() then
      keyInfoEvt:stop()
    else
      keyInfoEvt:start()
    end
  end)
end
