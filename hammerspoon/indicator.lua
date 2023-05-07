local box_height = 23
local box_alpha = 0.35


local function draw_rectangle(target_draw, x, y, width, height, fill_color)
  target_draw:setSize(hs.geometry.rect(x, y, width, height))
  target_draw:setTopLeft(hs.geometry.point(x, y))
  target_draw:setFillColor(fill_color)
  target_draw:setFill(true)
  target_draw:setAlpha(box_alpha)
  target_draw:setLevel(hs.drawing.windowLevels.overlay)
  target_draw:setStroke(false)
  target_draw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
  target_draw:show()
end


local Indicator = {}
Indicator = {
  enable = function(self)
    hs.fnutils.each(Indicator._indicators, function(indi)
      indi:disable()
    end)
    hs.fnutils.each(hs.screen.allScreens(), function(scr)
      local frame = scr:fullFrame()
      local box = hs.drawing.rectangle(hs.geometry.rect(0, 0, 0, 0))
      draw_rectangle(box, frame.x, frame.y, frame.w, box_height, self.color)
      table.insert(self.boxes, box)
    end)
  end,

  disable = function (self)
    hs.fnutils.each(self.boxes, function(box)
      if box ~= nil then
        box:delete()
      end
    end)
    self.boxes = {}
  end,

  _indicators = {},
}

Indicator.new = function(color)
  local _self = {
    color = color,
    boxes = {},
  }
  setmetatable(_self, {__index = Indicator})
  table.insert(Indicator._indicators, _self)
  return _self
end



return Indicator
