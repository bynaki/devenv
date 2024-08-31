-- Init Hammerspoon

local ly = require('layout')
local KeyLayer = ly.KeyLayer
local Layout = ly.Layout



local inputSource = {
  english = 'com.apple.keylayout.ABC',
  korean  = 'com.apple.inputmethod.Korean.2SetKorean',
}
-- Customize Esc Key & Custom Key
-- Esc키 눌렀을때 강제로 영문키로 변경, Capslock off for vim
--
-- local function escapeWithChangedInput()
--   local input_source = hs.keycodes.currentSourceID()
--   if not (input_source == inputSource.english) then
--     hs.keycodes.currentSourceID(inputSource.english)
--   end
--   hs.hid.capslock.set(false)
--   hs.eventtap.keyStroke({},'escape')
-- end

-- Change Input Source :: 한영키 지정
--
-- local function changeInput()
--   local current = hs.keycodes.currentSourceID()
--   local nextInput = nil
--   if current == inputSource.english then
--     nextInput = inputSource.korean
--   else
--     nextInput = inputSource.english
--   end
--   hs.keycodes.currentSourceID(nextInput)
-- end

-- 영어키로& Capslock off for vim
--
local function changeEngInput()
  local input_source = hs.keycodes.currentSourceID()
  if not (input_source == inputSource.english) then
    hs.keycodes.currentSourceID(inputSource.english)
  end
  hs.hid.capslock.set(false)
end

KeyDownEvt = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  local raw = evt:rawFlags()
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  if key == 'escape' then
    changeEngInput()
  end
end)
KeyDownEvt:start()


local layer01 = KeyLayer.new()

-- Reload Hammerspoon --
--
do
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'r', hs.reload)
  layer01:bind('r', hs.reload)
end

-- Toggle Hammerspoon Console --
--
do
  hs.hotkey.bind({'ctrl', 'option', 'cmd'}, 'c', hs.toggleConsole)
  layer01:bind('c', hs.toggleConsole)
end

-- Launch or Focus Terminal --
--
local prevWin = nil
do
  local function focusTerminal()
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

  layer01:bind("'", focusTerminal)
  hs.hotkey.bind({'cmd'}, ';', focusTerminal)
end


-- 윈도우창 크기  조절 --
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
  layer01:bind('h', moveToLeft)
  layer01:bind('l', moveToRight)
  layer01:bind('k', moveToTop)
  layer01:bind('j', moveToBottom)
  layer01:bind('m', maxWindow)
  layer01:bind('u', moveToLeftForScreenshot)
  layer01:bind('i', moveToRightForScreenshot)
end


-- Customize Key --
--
do
  -- copy
  layer01:bind('y', function(evt)
    hs.eventtap.keyStroke({'cmd'}, 'c')
  end)

  -- paste
  layer01:bind('p', function(evt)
    hs.eventtap.keyStroke({'cmd'}, 'v')
  end)

  -- toggle full size
  layer01:bind('f', function(evt)
    hs.eventtap.keyStroke({'ctrl', 'cmd'}, 'f')
  end)

  -- Keyboard-driven expose
  --
  -- default windowfilter
  local expose = hs.expose.new(nil, {showThumbnail=true})
  layer01:bind('space', function(evt)
    expose:toggleShow()
  end)
  -- Active application
  local expose_app = hs.expose.new(nil, {onlyActiveApplication=true})
  layer01:bind(',', function(evt)
    expose_app:toggleShow()
  end)
end


-- Cheatsheet --
--
do
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
      print("not be image.")
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
      print("not be template.")
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

  -- cheatsheet keyboard layer
  layer01:bind('e', function()
    toggleCheatsheet("./assets/keyboard-layout.png")
  end)

  -- cheatsheet vim map
  layer01:bind('v', function()
    toggleCheatsheet("./assets/vim-cheatsheet.png")
  end)

  -- cheatsheet tmux
  layer01:bind('x', function()
    toggleCheatsheet("./assets/tmux-cheatsheet.png")
  end)
end


-- Window Hints --
--
do
  hs.hints.hintChars = {'A', 'S', 'D', 'F', 'Q', 'W', 'E', 'R'}
  layer01:bind('.', hs.hints.windowHints)
end


-- Naver Dictionary --
--
do
  local url = 'https://en.dict.naver.com/#/search?query='
  local blinkUrl = 'https://en.dict.naver.com'
  local win = hs.window.focusedWindow()
  local screen = win:screen():frame()
  local w = math.min(1020, screen.w)
  local naver = hs.webview.new({
    x = screen.w - w,
    y = 0,
    w = w,
    h = screen.h,
  })
  naver:shadow(true)
  naver:windowStyle('resizable')
  naver:allowTextEntry(true)

  layer01:bind('d', function()
    if naver:isVisible() then
      naver:hide()
      return
    end
    local pasted = hs.pasteboard.readString()
    if pasted then
      if string.len(pasted) > 30 then
        naver:url(blinkUrl)
        return
      end
      pasted = string.gsub(pasted, ' ', '%%20')
      naver:url(url .. pasted)
    else
      naver:url(blinkUrl)
    end
    naver:show()
  end)
end


local layout = Layout.new(ly.rightctrl)
layout:add({}, layer01)
