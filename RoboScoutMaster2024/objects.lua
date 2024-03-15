require "data"
module("Objects", package.seeall)

local show_debug_text = false

local asset_loc = "Assets/"

local _sceneGroup = nil

function set_scene_group(sceneGroup)
    _sceneGroup = sceneGroup
end

function get_scene_group()
    return _sceneGroup
end

SingleLineInput = {}
function SingleLineInput.init(val_text, font_size, y_val, lft_mrg, spac1, textbox_width, text_hint, input_size, for_qr)
    local self = setmetatable({}, SingleLineInput)
    self.sceneGroup = _sceneGroup

    y_val = y_val + Data.sy
    lft_mrg = lft_mrg + Data.sx

    self.prompt_text = display.newText({parent=self.sceneGroup, text=val_text, x=lft_mrg, y=y_val, font=native.systemFont, fontSize=font_size, align="center"})
    self.prompt_text.anchorX=0
    self.prompt_text.anchorY=0
    self.prompt_text:setFillColor(0,0,0)

    self.click_away_box = display.newRect(self.sceneGroup,display.contentCenterX,display.contentCenterX,display.actualContentWidth,display.actualContentHeight)
    self.click_away_box.alpha=0
    self.click_away_box.isHitTestable = true
    self.click_away_box:addEventListener("tap", function() native.setKeyboardFocus(nil) end)

    self.line_input = native.newTextField(0, y_val, textbox_width, 1)
    self.line_input.anchorX=0
    self.line_input.anchorY=0
    self.line_input.x = self.prompt_text.x + self.prompt_text.width + spac1
    self.line_input.height = self.prompt_text.height
    self.line_input.size = input_size
    self.line_input.placeholder=text_hint
    self.sceneGroup:insert(self.line_input)

    self.debug_text = display.newText({parent=self.sceneGroup, text=tostring(def_val), x=0, y=y_val, font=native.systemFont, fontSize=12, align="left"})
    self.debug_text.anchorX = 0
    self.debug_text.anchorY = 0
    self.debug_text.x = self.line_input.x + self.line_input.width + spac1
    self.debug_text:setFillColor(0,0,0)
    self.debug_text.isVisible = show_debug_text

    self.text_enter = function(event)
        -- if event.phase == "editing" and for_qr then
        --     if math.abs(string.len(event.oldText)-string.len(event.newCharacters)) == 1 then
        --         self.line_input.text = event.oldText
        --     end
        -- else
        if event.phase == "submitted" then
            native.setKeyboardFocus(nil)          
        end
    end

    self.get_text = function()
        return self.line_input.text
    end

    self.line_input:addEventListener("userInput", self.text_enter)

    self.top_y = self.prompt_text.y - Data.sy
    self.bottom_y = self.prompt_text.y + self.prompt_text.height - Data.sy
    self.left_x = self.prompt_text.x - Data.sx
    self.right_x = self.line_input.x + self.line_input.width - Data.sx
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x

    return self
end

SingleLineDisplay = {}
function SingleLineDisplay.init(val_text, font_size, y_val, lft_mrg, spac1, display_size)
    local self = setmetatable({}, SingleLineDisplay)
    self.sceneGroup = _sceneGroup

    y_val = y_val + Data.sy
    lft_mrg = lft_mrg + Data.sx

    self.prompt_text = display.newText({parent=self.sceneGroup, text=val_text, x=lft_mrg, y=y_val, font=native.systemFont, fontSize=font_size, align="center"})
    self.prompt_text.anchorX=0
    self.prompt_text.anchorY=0
    self.prompt_text:setFillColor(0,0,0)

    self.text_display_bckgd = display.newRoundedRect(self.sceneGroup, 0, 0, 1, self.prompt_text.height, 0)
    self.text_display_bckgd:setFillColor(1,1,1)

    self.text_display = display.newText({parent=self.sceneGroup, text="", x=self.prompt_text.x + self.prompt_text.width + spac1 + 5, y=self.prompt_text.y + (self.prompt_text.height/2), font=native.systemFont, fontSize=display_size, align="center"})
    self.text_display.anchorX=0
    self.text_display:setFillColor(0,0,0)
    
    self.update = function(text)
        self.text_display.text = text
        self.text_display.size = display_size
        self.text_display_bckgd.x = self.text_display.x + (self.text_display.width/2)
        self.text_display_bckgd.y = self.text_display.y
        self.text_display_bckgd.width = self.text_display.width + 10
        self.text_display_bckgd.path.radius = 0.1 * math.min(self.text_display_bckgd.height, self.text_display_bckgd.width)
    end

    self.update("N/A")

    self.top_y = self.prompt_text.y - Data.sy
    self.bottom_y = self.prompt_text.y + self.prompt_text.height - Data.sy
    self.left_x = self.prompt_text.x - Data.sx
    self.right_x = self.text_display_bckgd.x + (self.text_display_bckgd.width/2) - Data.sx
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x

    return self
end

EditPopUp = {}
function EditPopUp.init(msg, msg_size, cancel_text, save_text, button_size, curr_value, isNumber, update_method)
    local self = setmetatable({}, EditPopUp)
    self.sceneGroup = _sceneGroup
    self.popup_group = display.newGroup()
    self.sceneGroup:insert(self.popup_group)

    self.tap_catcher = display.newRect(self.popup_group, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    self.tap_catcher:setFillColor(0,0,0)
    self.tap_catcher.alpha = 0
    self.tap_catcher.isHitTestable = true
    self.tap_catcher:addEventListener("tap", function() native.setKeyboardFocus(nil) return true end)

    self.popup = display.newRoundedRect(self.popup_group, display.contentCenterX, display.contentCenterY, 1, 1, 1)
    self.popup:setFillColor(1,1,1)
    self.popup:setStrokeColor(0,0,0)
    self.popup.strokeWidth = 4

    self.message = display.newText({parent=self.popup_group, text=msg, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=msg_size, align="center"})
    self.message:setFillColor(0,0,0)

    self.edit_box = native.newTextField(display.contentCenterX, display.contentCenterY, 1, 1)
    self.popup_group:insert(self.edit_box)
    self.edit_box.text = curr_value
    self.edit_box.size = msg_size
    self.edit_box:resizeHeightToFitFont()
    if is_number == true then
        self.edit_box.inputType = "number"
    end

    self.save = function()
        update_method(self.edit_box.text)
        display.remove(self.popup_group)
    end

    self.edit_box:addEventListener("userInput", function(event) if event.phase == "submitted" then native.setKeyboardFocus(nil) end end)

    self.cancel_button = display.newRect(self.popup_group, display.contentCenterX, display.contentCenterY, 1, 1)
    self.cancel_button:setFillColor(0,0.2,1)
    self.cancel_button.alpha = 0
    self.cancel_button.isHitTestable = true
    self.cancel_button:addEventListener("tap", function() display.remove(self.popup_group) end)

    self.cancel_text = display.newText({parent=self.popup_group, text=cancel_text, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=button_size, align="center"})
    self.cancel_text:setFillColor(0,0,0)

    self.save_button = display.newRect(self.popup_group, display.contentCenterX, display.contentCenterY, 1, 1)
    self.save_button:setFillColor(0,0.2,1)
    self.save_button.alpha = 0
    self.save_button.isHitTestable = true
    self.save_button:addEventListener("tap", self.save)

    self.save_text = display.newText({parent=self.popup_group, text=save_text, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=button_size, align="center"})
    self.save_text:setFillColor(0,0,0)

    -- Popup dimensions
    local horz_spac = 10
    local vert_spac = 20
    self.width = math.max(self.message.width + (2*horz_spac), self.cancel_text.width + self.save_text.width + (4*horz_spac))
    self.popup.width = self.width
    self.height = self.message.height + self.edit_box.height + math.max(self.cancel_text.height, self.save_text.height) + (4*vert_spac)
    self.popup.height = self.height
    self.popup.path.radius = math.floor(0.1*math.min(self.popup.width, self.popup.height))

    -- Message placement
    self.y_top = self.popup.y - (self.popup.height / 2)
    self.x_left = self.popup.x - (self.popup.width / 2)
    self.message.y = self.y_top + vert_spac
    self.message.anchorY=0

    -- TextField placement
    self.edit_box.y = self.y_top + self.message.height + (2*vert_spac)
    self.edit_box.anchorY=0
    self.edit_box.width = self.width - 2*horz_spac

    -- Button placement
    self.button_height = math.max(self.cancel_text.height, self.save_text.height)
    self.cancel_text.y = self.y_top + self.message.height  + self.edit_box.height + (3*vert_spac)
    self.cancel_text.anchorY=0
    self.cancel_text.x = self.x_left + (self.width/2) - (self.width/4)
    self.cancel_button.height = self.button_height + (2*vert_spac)
    self.cancel_button.width = (self.width/2) - 5
    self.cancel_button.y = self.y_top + self.message.height + self.edit_box.height + (2*vert_spac)
    self.cancel_button.anchorY=0
    self.cancel_button.x = display.contentCenterX - 5
    self.cancel_button.anchorX=1
    self.save_text.y = self.y_top + self.message.height + self.edit_box.height + (3*vert_spac)
    self.save_text.anchorY=0
    self.save_text.x = self.x_left + (self.width/2) + (self.width/4)
    self.save_button.height = self.button_height + (2*vert_spac)
    self.save_button.width = (self.width/2) - 5
    self.save_button.y = self.y_top + self.message.height + self.edit_box.height + (2*vert_spac)
    self.save_button.anchorY=0
    self.save_button.x = display.contentCenterX + 5
    self.save_button.anchorX=0
    self.option_line = display.newLine(self.popup_group, display.contentCenterX, self.save_button.y, display.contentCenterX, self.save_button.y + self.save_button.height)
    self.option_line:setStrokeColor(0,0,0)
    self.option_line.strokeWidth = 2
    return self
end

MultilineEditPopUp = {}
function MultilineEditPopUp.init(msg, msg_size, cancel_text, save_text, button_size, text_box, update_method)
    local self = setmetatable({}, MultilineEditPopUp)
    self.sceneGroup = _sceneGroup
    self.popup_group = display.newGroup()
    self.sceneGroup:insert(self.popup_group)

    self.tap_catcher = display.newRect(self.popup_group, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    self.tap_catcher:setFillColor(0,0,0)
    self.tap_catcher.alpha = 0
    self.tap_catcher.isHitTestable = true
    self.tap_catcher:addEventListener("tap", function() native.setKeyboardFocus(nil) return true end)

    self.popup = display.newRoundedRect(self.popup_group, display.contentCenterX, display.contentCenterY, 1, 1, 1)
    self.popup:setFillColor(1,1,1)
    self.popup:setStrokeColor(0,0,0)
    self.popup.strokeWidth = 4

    self.message = display.newText({parent=self.popup_group, text=msg, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=msg_size, align="center"})
    self.message:setFillColor(0,0,0)

    self.edit_box = native.newTextBox(display.contentCenterX, display.contentCenterY, 1, Data.sh/4)
    self.popup_group:insert(self.edit_box)
    self.edit_box.text = text_box.text
    self.edit_box.size = msg_size
    self.edit_box.isEditable = true

    self.save = function()
        update_method(self.edit_box.text)
        text_box.isVisible = true
        display.remove(self.popup_group)
    end

    self.cancel = function()
        text_box.isVisible = true
        text_box.isEditable = true
        display.remove(self.popup_group)
    end

    self.edit_box:addEventListener("userInput", function(event) if event.phase == "submitted" then native.setKeyboardFocus(nil) end end)

    self.cancel_button = display.newRect(self.popup_group, display.contentCenterX, display.contentCenterY, 1, 1)
    self.cancel_button:setFillColor(0,0.2,1)
    self.cancel_button.alpha = 0
    self.cancel_button.isHitTestable = true
    self.cancel_button:addEventListener("tap", self.cancel)

    self.cancel_text = display.newText({parent=self.popup_group, text=cancel_text, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=button_size, align="center"})
    self.cancel_text:setFillColor(0,0,0)

    self.save_button = display.newRect(self.popup_group, display.contentCenterX, display.contentCenterY, 1, 1)
    self.save_button:setFillColor(0,0.2,1)
    self.save_button.alpha = 0
    self.save_button.isHitTestable = true
    self.save_button:addEventListener("tap", self.save)

    self.save_text = display.newText({parent=self.popup_group, text=save_text, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=button_size, align="center"})
    self.save_text:setFillColor(0,0,0)

    -- Popup dimensions
    local horz_spac = 10
    local vert_spac = 20
    self.width = math.max(2*Data.sw/3, math.max(self.message.width + (2*horz_spac), self.cancel_text.width + self.save_text.width + (4*horz_spac)))
    self.popup.width = self.width
    self.height = self.message.height + self.edit_box.height + math.max(self.cancel_text.height, self.save_text.height) + (4*vert_spac)
    self.popup.height = self.height
    self.popup.path.radius = math.floor(0.1*math.min(self.popup.width, self.popup.height))

    -- Message placement
    self.y_top = self.popup.y - (self.popup.height / 2)
    self.x_left = self.popup.x - (self.popup.width / 2)
    self.message.y = self.y_top + vert_spac
    self.message.anchorY=0

    -- TextField placement
    self.edit_box.y = self.y_top + self.message.height + (2*vert_spac)
    self.edit_box.anchorY=0
    self.edit_box.width = self.width - 2*horz_spac

    -- Button placement
    self.button_height = math.max(self.cancel_text.height, self.save_text.height)
    self.cancel_text.y = self.y_top + self.message.height  + self.edit_box.height + (3*vert_spac)
    self.cancel_text.anchorY=0
    self.cancel_text.x = self.x_left + (self.width/2) - (self.width/4)
    self.cancel_button.height = self.button_height + (2*vert_spac)
    self.cancel_button.width = (self.width/2) - 5
    self.cancel_button.y = self.y_top + self.message.height + self.edit_box.height + (2*vert_spac)
    self.cancel_button.anchorY=0
    self.cancel_button.x = display.contentCenterX - 5
    self.cancel_button.anchorX=1
    self.save_text.y = self.y_top + self.message.height + self.edit_box.height + (3*vert_spac)
    self.save_text.anchorY=0
    self.save_text.x = self.x_left + (self.width/2) + (self.width/4)
    self.save_button.height = self.button_height + (2*vert_spac)
    self.save_button.width = (self.width/2) - 5
    self.save_button.y = self.y_top + self.message.height + self.edit_box.height + (2*vert_spac)
    self.save_button.anchorY=0
    self.save_button.x = display.contentCenterX + 5
    self.save_button.anchorX=0
    self.option_line = display.newLine(self.popup_group, display.contentCenterX, self.save_button.y, display.contentCenterX, self.save_button.y + self.save_button.height)
    self.option_line:setStrokeColor(0,0,0)
    self.option_line.strokeWidth = 2
    return self
end

EditableSingleLineDisplay = {}
function EditableSingleLineDisplay.init(val_text, font_size, y_val, lft_mrg, spac1, display_size, is_number)
    local self = setmetatable({}, EditableSingleLineDisplay)
    self.sceneGroup = _sceneGroup

    y_val = y_val + Data.sy
    lft_mrg = lft_mrg + Data.sx
    self.cleared = true

    self.prompt_text = display.newText({parent=self.sceneGroup, text=val_text, x=lft_mrg, y=y_val, font=native.systemFont, fontSize=font_size, align="center"})
    self.prompt_text.anchorX=0
    self.prompt_text.anchorY=0
    self.prompt_text:setFillColor(0,0,0)

    self.text_display_bckgd = display.newRoundedRect(self.sceneGroup, 0, 0, 1, self.prompt_text.height, 0)
    self.text_display_bckgd:setFillColor(1,1,1)

    self.text_display = display.newText({parent=self.sceneGroup, text="", x=self.prompt_text.x + self.prompt_text.width + spac1 + 5, y=self.prompt_text.y + (self.prompt_text.height/2), font=native.systemFont, fontSize=display_size, align="center"})
    self.text_display.anchorX=0
    self.text_display:setFillColor(0,0,0)
    
    self.update = function(text)
        if is_number == true then
            if tonumber(text) == nil then
                error("You cannot update a number field with a text string.", 2)
            else
                text = tostring(tonumber(text))
            end
        end
        self.cleared = false
        self.text_display.text = text
        self.text_display.size = display_size
        self.text_display_bckgd.x = self.text_display.x + (self.text_display.width/2)
        self.text_display_bckgd.y = self.text_display.y
        self.text_display_bckgd.width = self.text_display.width + 10
        self.text_display_bckgd.path.radius = 0.1 * math.min(self.text_display_bckgd.height, self.text_display_bckgd.width)
    end

    self.clear = function(text)
        self.cleared = true
        self.text_display.text = "N/A"
        self.text_display.size = display_size
        self.text_display_bckgd.x = self.text_display.x + (self.text_display.width/2)
        self.text_display_bckgd.y = self.text_display.y
        self.text_display_bckgd.width = self.text_display.width + 10
        self.text_display_bckgd.path.radius = 0.1 * math.min(self.text_display_bckgd.height, self.text_display_bckgd.width)
    end

    self.edit = function(yes)
        if not self.cleared then
            EditPopUp.init(string.sub(val_text,0,-2).."\nWas: "..self.text_display.text, 20, "Cancel", "Save", 20, self.text_display.text, isNumber, self.update)
        end
    end

    self.prompt_text:addEventListener("tap", self.edit)
    self.text_display_bckgd:addEventListener("tap", self.edit)

    self.clear()
    self.edit(false)

    self.top_y = self.prompt_text.y - Data.sy
    self.bottom_y = self.prompt_text.y + self.prompt_text.height - Data.sy
    self.left_x = self.prompt_text.x - Data.sx
    self.right_x = self.text_display_bckgd.x + (self.text_display_bckgd.width/2) - Data.sx
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x

    return self
end

EditableMultiLineDisplay = {}
function EditableMultiLineDisplay.init(val_text, font_size, y_val, lft_mrg, spac1, height, display_size)
    local self = setmetatable({}, EditableMultiLineDisplay)
    self.sceneGroup = _sceneGroup

    y_val = y_val + Data.sy
    lft_mrg = lft_mrg + Data.sx
    self.cleared = true

    self.prompt_text = display.newText({parent=self.sceneGroup, text=val_text, x=display.contentCenterX, y=y_val, font=native.systemFont, fontSize=font_size, align="center"})
    self.prompt_text.anchorY=0
    self.prompt_text:setFillColor(0,0,0)

    self.text_display_bckgd = display.newRoundedRect(self.sceneGroup, 0, 0, 1, 1, 0)
    self.text_display_bckgd:setFillColor(1,1,1)

    self.text_display = native.newTextBox(display.contentCenterX, self.prompt_text.y + self.prompt_text.height + spac1, Data.sw - 2*lft_mrg, height - self.prompt_text.height)
    self.text_display.anchorY=0
	self.text_display.hasBackground = false
	self.text_display.size = display_size
    self.text_display.align = "center"
    self.text_display.isEditable = true

    self.text_display_bckgd.x = self.text_display.x
    self.text_display_bckgd.y = self.text_display.y + (self.text_display.height/2)
    self.text_display_bckgd.height = self.text_display.height + 10
    self.text_display_bckgd.width = self.text_display.width + 10
    self.text_display_bckgd.path.radius = 0.1 * math.min(self.text_display_bckgd.height, self.text_display_bckgd.width)
    
    self.update = function(text)
        if is_number == true then
            print("Checking if this is number... "..tostring(text)..".")
            if tonumber(text) == nil then
                error("You cannot update a number field with a text string.", 2)
            else
                text = tostring(tonumber(text))
            end
        end
        self.cleared = false
        self.text_display.text = text
        self.text_display.size = display_size
    end

    self.clear = function(text)
        self.cleared = true
        self.text_display.text = "N/A"
        self.text_display.size = display_size
    end

    self.edit = function(yes)
        if not self.cleared then
            self.text_display.isVisible = false
            MultilineEditPopUp.init(string.sub(val_text,0,-2), 20, "Cancel", "Save", 20, self.text_display, self.update)
        end
    end

    self.prompt_text:addEventListener("tap", self.edit)
    self.text_display:addEventListener("userInput", function(event) if event.phase == "began" then  self.edit() native.setKeyboardFocus(nil) end end)
    self.text_display_bckgd:addEventListener("tap", self.edit)

    self.clear()
    self.edit(false)

    self.top_y = self.prompt_text.y - Data.sy
    self.bottom_y = self.text_display_bckgd.y + (self.text_display_bckgd.height/2) - Data.sy
    self.left_x = lft_mrg - Data.sx
    self.right_x = Data.sw - lft_mrg - Data.sx
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x

    return self
end

Alert = {}
function Alert.init(msg, msg_size, ok_text, button_size)
    local self = setmetatable({}, Alert)
    self.sceneGroup = _sceneGroup
    self.alert_group = display.newGroup()
    self.sceneGroup:insert(self.alert_group)

    self.tap_catcher = display.newRect(self.alert_group, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    self.tap_catcher:setFillColor(0,0,0)
    self.tap_catcher.alpha = 0.4
    --self.tap_catcher.isHitTestable = true
    self.tap_catcher:addEventListener("tap", function() return true end)

    self.popup = display.newRoundedRect(self.alert_group, display.contentCenterX, display.contentCenterY, 1, 1, 1)
    self.popup:setFillColor(1,1,1)
    self.popup:setStrokeColor(0,0,0)
    self.popup.strokeWidth = 4

    self.message = display.newText({parent=self.alert_group, text=msg, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=msg_size, align="center"})
    self.message:setFillColor(0,0,0)

    self.ok_button = display.newRect(self.alert_group, display.contentCenterX, display.contentCenterY, 1, 1)
    self.ok_button:setFillColor(0,0.2,1)
    self.ok_button.alpha = 0
    self.ok_button.isHitTestable = true
    self.ok_button:addEventListener("tap", function() display.remove(self.alert_group) end)

    self.ok_text = display.newText({parent=self.alert_group, text=ok_text, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=button_size, align="center"})
    self.ok_text:setFillColor(0,0,0)

    -- Popup dimensions
    local horz_spac = 10
    local vert_spac = 20
    self.width = math.max(self.message.width + (2*horz_spac), self.ok_text.width + (2*horz_spac))
    self.popup.width = self.width
    self.height = self.message.height + self.ok_text.height + (4*vert_spac)
    self.popup.height = self.height
    self.popup.path.radius = math.floor(0.1*math.min(self.popup.width, self.popup.height))

    -- Message placement
    self.y_top = self.popup.y - (self.popup.height / 2)
    self.x_left = self.popup.x - (self.popup.width / 2)
    self.message.y = self.y_top + vert_spac
    self.message.anchorY=0

    -- Button placement
    self.button_height = self.ok_text.height
    self.ok_text.y = self.y_top + self.message.height + (3*vert_spac)
    self.ok_text.anchorY=0
    self.ok_text.x = display.contentCenterX
    self.ok_button.height = self.button_height + (2*vert_spac)
    self.ok_button.width = self.width
    self.ok_button.y = self.y_top + self.message.height + (2*vert_spac)
    self.ok_button.anchorY=0
    self.ok_button.x = display.contentCenterX
    return self
end