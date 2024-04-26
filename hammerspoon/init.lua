local cc = require('commander')
local trigger = cc.trigger
local Commander = cc.Commander
local snippet = cc.snippet
local custom = require('custom')
require('layer')

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
  cmd:bind({'ctrl', 'cmd'}, 'h', moveToLeftForScreenshot)
  cmd:bind({'ctrl', 'cmd'}, 'l', moveToRightForScreenshot)
end


-- do -- 현제 입력소스 확인
--   hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'i', function()
--     local input_source = hs.keycodes.currentSourceID()
--     print(input_source)
--   end)
-- end


-- Custom Key
--
do
  -- toggle capslock
  custom:bind({'ctrl'}, 'a', function ()
    hs.hid.capslock.toggle()
    return true
  end)

  -- copy
  custom:bind({'ctrl'}, 'y', function (evt)
    hs.eventtap.keyStroke({'cmd'}, 'c')
    return true
  end)

  -- paste
  custom:bind({'ctrl'}, 'p', function (evt)
    hs.eventtap.keyStroke({'cmd'}, 'v')
    return true
  end)

  -- right tap
  custom:bind({'ctrl'}, 'k', function (evt)
    hs.eventtap.keyStroke({'alt', 'cmd'}, 'right')
    return true
  end)

  -- left tap
  custom:bind({'ctrl'}, 'j', function (evt)
    hs.eventtap.keyStroke({'alt', 'cmd'}, 'left')
    return true
  end)

  -- full size
  custom:bind({'ctrl'}, 'm', function (evt)
    hs.eventtap.keyStroke({'ctrl', 'cmd'}, 'f')
    return true
  end)

  -- left swap
  -- custom:bind({'ctrl'}, 'h', function (evt)
  --   -- evt:keyStroke({'ctrl'}, 'left')
  --   print('hello')
  --   hs.eventtap.keyStroke({'ctrl'}, 'left')
  --   return false
  -- end)


  -- Keyboard-driven expose
  --
  -- default windowfilter
  local expose = hs.expose.new(nil, {showThumbnail=true})
  custom:bind({'ctrl'}, ';', function (evt)
    expose:toggleShow()
    return true
  end)
  -- Active application
  local expose_app = hs.expose.new(nil, {onlyActiveApplication=true})
  custom:bind({'ctrl', 'shift'}, ';', function ()
    expose_app:toggleShow()
    return true
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

  custom:bind({'ctrl'}, 'd', function ()
    toggleCheatsheet("./assets/keyboard-layers.png")
    return true
  end)

  custom:bind({'ctrl'}, 's', function ()
    toggleCheatsheet("./assets/vim-cheatsheet.png")
    return true
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

  local function new_remapper()
    local remapper = FRemap.new()
    remapper:remap('capslock', 'rctl')
    return remapper
  end

  local function layoutDefault() -- Remapping Default Layout
    unregisterLayout()
    local remapper = new_remapper()
    remapper:register()
    current_map = remapper
  end

  local function layoutApple() -- Remapping Keyboard Layout: Apple
    layoutDefault()
  end

  local function layoutWindows() -- Remapping Keyboard Layout: WindowsKeys 
    unregisterLayout()
    local remapper = new_remapper()
    remapper:remap('lcmd', 'lalt')
    remapper:remap('lalt', 'lcmd')
    remapper:remap('rctl', 'ralt')
    remapper:register()
    current_map = remapper
  end

  local function layout68Keys() -- Remapping Keyboard Layout: 68Keys
    unregisterLayout()
    local remapper = new_remapper()
    remapper:remap('escape', '`')
    remapper:remap('lcmd', 'lalt')
    remapper:remap('lalt', 'lcmd')
    remapper:remap('rctl', 'ralt')
    remapper:register()
    current_map = remapper
  end

  local function layoutAlice80() -- Remapping Keyboard Layout: Alice80
    unregisterLayout()
    local remapper = new_remapper()
    remapper:remap('escape', '`')
    remapper:remap('rctl', 'f15')
    remapper:register()
    current_map = remapper
    -- tmux key
    hs.hotkey.bind({}, 'f15', function()
      hs.eventtap.keyStroke({'ctrl'}, 'b')
    end)
  end

  local chooser = hs.chooser.new(function(choice)
    if not choice then
      return
    end
    if choice.text == 'Keyboard Layout: Default' then
      layoutDefault()
    elseif choice.text == 'Keyboard Layout: Apple' then
      layoutApple()
      hs.alert.show(choice.text)
    elseif choice.text == 'Keyboard Layout: Windows' then
      layoutWindows()
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
      text = 'Keyboard Layout: Default',
      subText = 'Default Keyboard Layout'
    })
    table.insert(list, {
      text = 'Keyboard Layout: Apple',
      subText = 'Apple Keyboard Layout'
    })
    table.insert(list, {
      text = 'Keyboard Layout: Windows',
      subText = 'Windows Keyboard Layout'
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
  layoutWindows() -- default keyboard layout
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

  cmd:bind({}, 'd', getColors)
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

  custom:bind({'ctrl'}, 'h', leftSwap)
  custom:bind({'ctrl'}, 'l', rightSwap)
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
