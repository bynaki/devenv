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
  local focused = hs.window.focusedWindow()
  self._evt:post(focused:application())
  -- self.block = false
  self.block = true
end

function KeyEvent:post(focused)
  self._evt:post(focused)
end

local enabledCmd = nil

_event = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (evt)
  if not enabledCmd then
    return false
  end
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  local flags = evt:getFlags()
  if key == 'escape' then
    enabledCmd:disable()
    return true
  end
  local list = enabledCmd.binds[key]
  if list then
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


local function equalModifiers(mod1, mod2)
  if #mod1 ~= #mod2 then
    return false
  end
  for i = 1, #mod1 do
    local be = false
    for j = 1, #mod2 do
      if mod1[i] == mod2[j] then
        be = true
        break
      end
    end
    if be == false then
      return false
    end
  end
  return true
end


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
  -- todo: list
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
  -- local key = evt:getCharacters()
  local code = evt:getKeyCode()
  local key = hs.keycodes.map[code]
  if trigger._binds[key] then
    oneKey = {
      key = key,
      binds = trigger._binds[key],
      timer = hs.timer.doAfter(1, function ()
        hs.eventtap.keyStrokes('a' .. evt:getCharacters())
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
  if key == 'escape' then
    hs.eventtap.keyStroke({}, oneKey.key)
    hs.eventtap.keyStroke({}, 'escape')
    oneKey = nil
    _task1:start()
    return true
  end
  local cb = oneKey.binds[key]
  if not cb then
    keyStrokes(oneKey.key .. evt:getCharacters(), function()
      oneKey = nil
      _task1:start()
    end)
    return true
  end
  oneKey = nil
  cb()
  _task1:start()
  return true
end)


local vim_leader = {
  modifiers = {},
  chars = 'space',
}
local tmux_prefix = {
  modifiers = {'ctrl'},
  chars = 'b',
}

local function classifyStroke(stroke)
  if stroke == '<vim_leader>' or stroke == '<leader>' then
    return vim_leader
  end
  if stroke == '<tmux_prefix>' or stroke == '<prefix>' then
    return tmux_prefix
  end
  local pattern = '<([^<>]+)>'
  local extracted = {}
  -- for match in strokes:gmatch(pattern) do
  for match in string.gmatch(stroke, pattern) do
    -- for word in match:gmatch("[^+]+") do
    for word in string.gmatch(match, '[^+]+') do
      table.insert(extracted, word:lower())
    end
  end
  if #extracted == 0 then
    return {
      chars = stroke,
    }
  end
  local modifiers = {}
  for i = 1, #extracted - 1 do
    table.insert(modifiers, extracted[i])
  end
  local chars = extracted[#extracted]
  return {
    modifiers = modifiers,
    chars = chars,
  }
end


local function readStrokes(strokes, tasks)
  tasks = tasks or {}
  if #strokes == 0 then
    return tasks
  end
  local pattern = '(<[^<>]+>)'
  local ss, ee, str = strokes:find(pattern)
  if not ss then
    table.insert(tasks, strokes)
    return tasks
  end
  if ss == 1 then
    table.insert(tasks, str)
    return readStrokes(string.sub(strokes, ee + 1), tasks)
  end
  table.insert(tasks, string.sub(strokes, 1, ss - 1))
  return readStrokes(string.sub(strokes, ss), tasks)
end


local function splitSentence(str)
  local sentences = {}
  for token in string.gmatch(str, "[^\n]+") do
    table.insert(sentences, token)
  end
  return sentences
end


local past = nil

local function snippet()
  local pasted = hs.pasteboard.getContents()
  if not pasted then
    if past then
      pasted = past
    else
      return
    end
  end
  if string.sub(pasted, 1, 1) ~= '@' then
    if past then
      pasted = past
    else
      return
    end
  end
  pasted = splitSentence(pasted)[1]
  past = pasted
  local ss = string.sub(pasted, 2)
  local tasks = readStrokes(ss)
  local idx = 0
  local timer
  timer = hs.timer.new(0.1, function()
    idx = idx + 1
    if idx > #tasks then
      timer:stop()
      return
    end
    print(tasks[idx])
    local stroke = classifyStroke(tasks[idx])
    if stroke.modifiers then
      hs.eventtap.keyStroke(stroke.modifiers, stroke.chars)
    else
      hs.eventtap.keyStrokes(stroke.chars)
    end
  end)
  timer:start()
  -- for _, t in ipairs(tasks) do
  --   local stroke = classifyStroke(t)
  --   if stroke.modifiers then
  --     -- hs.eventtap.keyStroke(stroke.modifiers, stroke.chars)
  --     keyStroke(stroke.modifiers, stroke.chars)
  --   else
  --     -- hs.eventtap.keyStrokes(stroke.chars)
  --     keyStrokes(stroke.chars)
  --   end
  -- end
end


return {
  trigger = trigger,
  Commander = Commander,
  KeyEvent = KeyEvent,
  keyStroke = keyStroke,
  keyStrokes = keyStrokes,
  snippet = snippet,
}
