require "data"
module("Objects", package.seeall)

require "qrencode"

local show_debug_text = false

local asset_loc = "Assets/"

local _sceneGroup = nil

function set_scene_group(sceneGroup)
    _sceneGroup = sceneGroup
end

function get_scene_group()
    return _sceneGroup
end

local function add_id_key(id,key)
    if Data.ids[id] then
        error("You cannot have two data objects sharing an id.", 3)
    else
        Data.ids[id] = true
        Data.keys[id] = key
    end
end

local function calcIDNeed(max_num)
    local id_need = 1
    local digit = 2
    while math.floor(max_num / 10^digit) ~= 0 do
        id_need = id_need + 1
        digit = digit + 2
    end
    return id_need
end

local function splitVals(num, ids)
    local vals = {}
    for i=0,ids-1 do
        local short_num = (num/(10^(2*i)))
        vals[i] = math.floor(math.fmod(short_num, 10^(2*i+2)))
    end
    return vals
end

local function setData(split_val, id, id_num)
    for i=0,id_num-1 do
        Data.recorded_data[id+i] = split_val[i]
    end
end

local function getData(id, id_num)
    val = 0
    for i=0,id_num-1 do
        val = val + (Data.recorded_data[id+1] * 100^i)
    end
    return val
end


Inc_Dec = {}
function Inc_Dec.init(id, key, val_text, font_size, y_val, lft_mrg, spac1, spac2, spac3, button_size, val_size, val_font_size, min_val, max_val)
    y_val = y_val + Data.sy
    lft_mrg = lft_mrg + Data.sx
    local self = setmetatable({}, Inc_Dec)
    self.sceneGroup = _sceneGroup
    self.id_need = calcIDNeed(max_val)
    self.def_val = min_val
    for i=0,self.id_need-1 do
        add_id_key(id + i,key)
        Data.recorded_data[id + i] = self.def_val
    end
    self.id_val = self.def_val

    self.id_text = display.newText({parent=self.sceneGroup, text=val_text, x=lft_mrg,y=y_val, font=native.systemFont, fontSize=font_size, align="center"})
    self.id_text.anchorX=0
    self.id_text:setFillColor(0,0,0)
    
    self.id_minus = display.newImageRect(self.sceneGroup, asset_loc.."red_minus.png", button_size, button_size)
    self.id_minus.anchorX=0
    self.id_minus.x=self.id_text.x + self.id_text.width + spac1
    self.id_minus.y=y_val

    local bkgd_height = math.max(self.id_text.height, button_size)
    self.id_val_bkgd = display.newRoundedRect(self.sceneGroup, 0, 0, val_size, 0, 12)
    self.id_val_bkgd.height=bkgd_height
    self.id_val_bkgd.anchorX=0
    self.id_val_bkgd.x=self.id_minus.x + self.id_minus.width + spac3
    self.id_val_bkgd.y=y_val

    self.id_val_text = display.newText({parent=self.sceneGroup,text=tostring(self.id_val),x=0,y=0,font=native.systemFont,fontSize=val_font_size})
    self.id_val_text:setFillColor(0,0,0)
    self.id_val_text.anchorX=0.5
    self.id_val_text.x = self.id_val_bkgd.x + (self.id_val_bkgd.width/2)
    self.id_val_text.y = self.id_val_bkgd.y

    self.id_plus = display.newImageRect(self.sceneGroup, asset_loc.."green_plus.png", button_size, button_size)
    self.id_plus.anchorX=0
    self.id_plus.x=self.id_val_bkgd.x + self.id_val_bkgd.width + spac2
    self.id_plus.y=y_val

    self.tap_id_plus = function ()
        self.id_val = math.min(self.id_val + 1,max_val)
        local data = self.id_val
        split = splitVals(data, self.id_need)
        setData(split, id, self.id_need)
        self.id_val_text.text = tostring(data)
    end

    self.tap_id_minus = function ()
        self.id_val = math.max(self.id_val - 1,min_val)
        local data = self.id_val
        split = splitVals(data, self.id_need)
        setData(split, id, self.id_need)
        self.id_val_text.text = tostring(data)
    end

    self.id_plus:addEventListener("tap", self.tap_id_plus)
    self.id_minus:addEventListener("tap", self.tap_id_minus)

    self.top_y = y_val - (math.max(self.id_text.height,button_size)/2) - Data.sy
    self.bottom_y = y_val + (math.max(self.id_text.height,button_size)/2) - Data.sy
    self.left_x = self.id_text.x - Data.sx
    self.right_x = self.id_plus.x + button_size - Data.sx
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x

    return self
end

Radio = {}
function Radio.init(id, key, val_text, font_size, y_val, lft_mrg, spac1, spac2, label_size, spac_lbl, radio_size, colored, default_val)
    y_val = y_val + Data.sy
    lft_mrg = lft_mrg + Data.sx
    local self = setmetatable({}, Radio)
    self.sceneGroup = _sceneGroup
    add_id_key(id,key)
    Data.recorded_data[id] = (default_val and 1 or 0)
    --self.rad_val = default_val

    self.rad_text = display.newText({parent=self.sceneGroup, text=val_text, x=lft_mrg, y=y_val, font=native.systemFont, fontSize=font_size, align="center"})
    self.rad_text.anchorX=0
    self.rad_text:setFillColor(0,0,0)

    false_off_asset = asset_loc.."radio_off.png"
    false_on_asset = asset_loc.."radio_on.png"
    true_off_asset = asset_loc.."radio_off.png"
    true_on_asset = asset_loc.."radio_on.png"
    if colored then
        false_on_asset = asset_loc.."radio_red.png"
        true_on_asset = asset_loc.."radio_green.png"
    end

    self.no_lbl = display.newText({parent=self.sceneGroup, text="No",x=0,y=0,font=native.systemFont,fontSize=label_size,align="center"})
    self.no_lbl:setFillColor(0,0,0)
    self.yes_lbl = display.newText({parent=self.sceneGroup, text="Yes",x=0,y=0,font=native.systemFont,fontSize=label_size,align="center"})
    self.yes_lbl:setFillColor(0,0,0)
    self.rad_false_off = display.newImageRect(self.sceneGroup, false_off_asset, radio_size, radio_size)
    self.rad_false_on = display.newImageRect(self.sceneGroup, false_on_asset, radio_size, radio_size)
    self.rad_true_off = display.newImageRect(self.sceneGroup, true_off_asset, radio_size, radio_size)
    self.rad_true_on = display.newImageRect(self.sceneGroup, true_on_asset, radio_size, radio_size)

    self.no_height = self.no_lbl.height + self.rad_false_off.height + spac_lbl
    self.yes_height = self.yes_lbl.height + self.rad_true_off.height + spac_lbl

    self.no_lbl.anchorY=0
    self.yes_lbl.anchorY=0
    self.rad_false_off.anchorY=1
    self.rad_false_on.anchorY=1
    self.rad_true_off.anchorY=1
    self.rad_true_on.anchorY=1

    self.no_lbl.y = y_val - (self.no_height/2)
    self.yes_lbl.y = y_val - (self.yes_height/2)
    self.rad_false_off.y = y_val + (self.no_height/2)
    self.rad_false_on.y = y_val + (self.no_height/2)
    self.rad_true_off.y = y_val + (self.yes_height/2)
    self.rad_true_on.y = y_val + (self.yes_height/2)

    if self.no_lbl.width > self.rad_false_off.width then
        -- base spacing on label
        self.no_lbl.anchorX=0
        self.no_lbl.x = self.rad_text.x + self.rad_text.width + spac1
        self.rad_false_off.anchorX=0.5
        self.rad_false_off.x = self.no_lbl.x + (self.no_lbl.width/2)
        self.no_x = self.no_lbl.x
        self.no_width = self.no_lbl.width
    else
        -- base spacing on radio button
        self.rad_false_off.anchorX=0
        self.rad_false_off.x=self.rad_text.x + self.rad_text.width + spac1
        self.no_lbl.anchorX=0.5
        self.no_lbl.x = self.rad_false_off.x + (self.rad_false_off.width/2)
        self.no_x = self.rad_false_off.x
        self.no_width = self.rad_false_off.width
    end
    self.rad_false_on.anchorX=self.rad_false_off.anchorX
    self.rad_false_on.x=self.rad_false_off.x

    if self.yes_lbl.width > self.rad_true_off.width then
        -- base spacing on label
        self.yes_lbl.anchorX=0
        self.yes_lbl.x = self.no_x + self.no_width + spac1
        self.rad_true_off.anchorX=0.5
        self.rad_true_off.x = self.yes_lbl.x + (self.yes_lbl.width/2)
        self.yes_x = self.yes_lbl.x
        self.yes_width = self.yes_lbl.width
    else
        -- base spacing on radio button
        self.rad_true_off.anchorX=0
        self.rad_true_off.x=self.no_x + self.no_width + spac1
        self.yes_lbl.anchorX=0.5
        self.yes_lbl.x = self.rad_true_off.x + (self.rad_true_off.width/2)
        self.yes_x = self.rad_true_off.x
        self.yes_width = self.rad_true_off.width
    end
    self.rad_true_on.anchorX=self.rad_true_off.anchorX
    self.rad_true_on.x=self.rad_true_off.x

    self.debug_text = display.newText({parent=self.sceneGroup, text=tostring(self.rad_val), x=lft_mrg, y=y_val, font=native.systemFont, fontSize=15, align="center"})
    self.debug_text.anchorX=0
    self.debug_text.x=self.yes_x + self.yes_width + 15
    self.debug_text:setFillColor(0,0,0)
    self.debug_text.isVisible = show_debug_text

    if default_val == true then
        self.rad_false_off.isVisible = true
        self.rad_false_on.isVisible = false
        self.rad_true_off.isVisible = false
        self.rad_true_on.isVisible = true
    else
        self.rad_false_off.isVisible = false
        self.rad_false_on.isVisible = true
        self.rad_true_off.isVisible = true
        self.rad_true_on.isVisible = false
    end

    self.tap_false = function ()
        --self.rad_val = false
        local data = {}
        data[0] = 0
        setData(data, id, 1)
        --Data.recorded_data[id] = 0
        self.rad_false_off.isVisible = false
        self.rad_false_on.isVisible = true
        self.rad_true_off.isVisible = true
        self.rad_true_on.isVisible = false
        self.debug_text.text = tostring(false)
    end

    self.tap_true = function ()
        --self.rad_val = true
        local data = {}
        data[0] = 1
        setData(data, id, 1)
        --Data.recorded_data[id] = 1
        self.rad_false_off.isVisible = true
        self.rad_false_on.isVisible = false
        self.rad_true_off.isVisible = false
        self.rad_true_on.isVisible = true
        self.debug_text.text = tostring(true)
    end

    self.rad_false_off:addEventListener("tap", self.tap_false)
    self.rad_true_off:addEventListener("tap", self.tap_true)

    self.top_y = math.min(self.rad_text.y - (self.rad_text.height/2), self.no_lbl.y) - Data.sy
    self.bottom_y = math.max(self.rad_text.y + (self.rad_text.height/2), self.rad_false_off.y) - Data.sy
    self.left_x = self.rad_text.x - Data.sx
    if self.no_lbl.width > self.rad_false_off.width then
        self.right_x = self.no_lbl.x + self.no_lbl.width - Data.sx
    else
        self.right_x = self.rad_true_off.x + self.rad_true_off.width - Data.sx
    end
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x
    
    return self
end

SingleSelect = {}
function SingleSelect.init(id, key, val_text, font_size, y_val, lft_mrg, spac1, spac2, radio_size, options, opt_font_size, num_rows, colors, default_value)
    y_val = y_val + Data.sy
    lft_mrg = lft_mrg + Data.sx
    local self = setmetatable({}, SingleSelect)
    self.sceneGroup = _sceneGroup
    self.id_need = calcIDNeed(table.getn(options))
    for i=0,self.id_need-1 do
        add_id_key(id + i,key)
    end
    self.def_found = false
    for i,v in ipairs(options) do
        if v == default_value then
            split = splitVals(i, self.id_need)
            setData(split, id, self.id_need)
            self.def_found = true
            break
        end
    end
    if not self.def_found then
        split = splitVals(1, self.id_need)
        setData(split, id, self.id_need)
    end

    self.select_text = display.newText({parent=self.sceneGroup, text=val_text, x=display.contentCenterX, y=y_val, font=native.systemFont, fontSize=font_size, align="center"})
    self.select_text.anchorX=0.5
    self.select_text.anchorY=0
    self.select_text:setFillColor(0,0,0)

    self.num_opt = table.getn(options)
    self.num_color = table.getn(colors)
    self.opt_per_row = math.floor(self.num_opt / num_rows)
    self.opt_buttons = {}
    self.button_group = display.newGroup()
    self.button_group.x = self.select_text.x
    self.button_group.y = self.select_text.y + self.select_text.height + spac2
    self.button_group.anchorX=0.5
    self.button_group.anchorY=0
    self.button_group.anchorChildren=true
    self.sceneGroup:insert(self.button_group)

    y_val = 0
    for r=1,num_rows do
        local lft_gap = 0
        for o=1,self.opt_per_row do
            local idx = (r-1)*self.opt_per_row + o
            local name = options[idx]
            local color = ""
            if idx > self.num_color then
                color = "black"
            else
                color = colors[idx]
            end
            local rad_off_asset = asset_loc.."radio_off.png"
            local rad_on_asset = asset_loc.."radio_on.png"
            if color == "blue" then
                rad_on_asset = asset_loc.."radio_blue.png"
            elseif color == "green" then
                rad_on_asset = asset_loc.."radio_green.png"
            elseif color == "red" then
                rad_on_asset = asset_loc.."radio_red.png"
            end
            local temp_rad_lbl = display.newText({parent=self.button_group, text=tostring(name), x=lft_gap, y=y_val, font=native.systemFont, fontSize=opt_font_size, align="center"})
            temp_rad_lbl.anchorX=0
            temp_rad_lbl:setFillColor(0,0,0)
            local temp_rad_off = display.newImageRect(self.button_group, rad_off_asset, radio_size, radio_size)
            temp_rad_off.anchorX=0.5
            temp_rad_off.x=temp_rad_lbl.x + (temp_rad_lbl.width/2)
            temp_rad_off.y=y_val + temp_rad_lbl.height + spac2
            local temp_rad_on = display.newImageRect(self.button_group, rad_on_asset, radio_size, radio_size)
            temp_rad_on.anchorX=0.5
            temp_rad_on.x=temp_rad_lbl.x + (temp_rad_lbl.width/2)
            temp_rad_on.y=y_val + temp_rad_lbl.height + spac2
            if name == default_value then
                temp_rad_off.isVisible=false
                temp_rad_on.isVisible=true
            else
                temp_rad_off.isVisible=true
                temp_rad_on.isVisible=false
            end
            self.opt_buttons[idx] = {temp_rad_lbl, temp_rad_off, temp_rad_on}
            lft_gap = lft_gap + temp_rad_lbl.width + spac1
            if o == self.opt_per_row then
                y_val = y_val + temp_rad_lbl.height + temp_rad_on.height + (2*spac2)
            end
        end
    end

    self.select = function(idx)
        local data = 0
        for i,v in ipairs(self.opt_buttons) do
            if i == idx then
                data = i
                v[2].isVisible=false
                v[3].isVisible=true
            else
                v[2].isVisible=true
                v[3].isVisible=false
            end
        end
        split = splitVals(data, self.id_need)
        setData(split, id, self.id_need)
    end

    for i,v in ipairs(self.opt_buttons) do
        v[2]:addEventListener("tap", function() self.select(i) end)
        v[3]:addEventListener("tap", function() self.select(i) end)
    end

    self.top_y = self.select_text.y - Data.sy
    self.bottom_y = self.button_group.y + self.button_group.height - Data.sy
    self.left_x = math.min(self.select_text.x - (self.select_text.width/2), self.button_group.x - (self.button_group.width/2)) - Data.sx
    self.right_x = math.max(self.select_text.x + (self.select_text.width/2), self.button_group.x + (self.button_group.width/2)) - Data.sx
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x

    self.remove = function()
        display.remove(self.select_text)
        display.remove(self.button_group)
    end

    return self
end

TextInput = {}
function TextInput.init(id, key, val_text, font_size, y_val, lft_mrg, spac1, textbox_height, text_hint, input_size)
    y_val = y_val + Data.sy
    lft_mrg = lft_mrg + Data.sx
    local self = setmetatable({}, TextInput)
    self.sceneGroup = _sceneGroup
    add_id_key(id,key)
    Data.recorded_data[id] = ""

    self.intext_text = display.newText({parent=self.sceneGroup, text=val_text, x=display.contentCenterX, y=y_val, font=native.systemFont, fontSize=font_size, align="center"})
    self.intext_text.anchorX=0.5
    self.intext_text:setFillColor(0,0,0)

    self.click_away_box = display.newRect(self.sceneGroup,display.contentCenterX,display.contentCenterX,display.actualContentWidth,display.actualContentHeight)
    self.click_away_box.alpha=0
    self.click_away_box.isHitTestable = true
    self.click_away_box:addEventListener("tap", function() native.setKeyboardFocus(nil) end)

    self.text_input = native.newTextBox(lft_mrg, 0, 1, textbox_height)
    self.text_input.placeholder=text_hint
    self.text_input.anchorX=0
    self.text_input.anchorY=0
    self.text_input.y = y_val + (self.intext_text.height/2) + spac1
    self.text_input.width = display.contentWidth - (2*lft_mrg)
    self.text_input.isEditable=true
    self.text_input.size=input_size

    self.sceneGroup:insert(self.text_input)

    self.debug_text = display.newText({parent=self.sceneGroup, text="", x=lft_mrg, y=0, font=native.systemFont, fontSize=12, align="left"})
    self.debug_text.anchorX=0
    self.debug_text.anchorY=0
    self.debug_text.y = self.text_input.y + self.text_input.height + 15
    self.debug_text:setFillColor(0,0,0)
    self.debug_text.isVisible = show_debug_text

    self.text_enter = function(event)
        --if event.phase == "ended" or event.phase == "submitted" then
        if event.phase == "editing" then
            local data = event.text
            if id ~= 99 then
                data = string.gsub(data, "9", "")
            end
            data = string.gsub(data, "\n", " ")
            Data.recorded_data[id] = data
            self.debug_text.text=tostring(tostring(data))
        elseif event.pahse == "submitted" then
            native.setKeyboardFocus(nil)
        end
    end

    self.text_input:addEventListener("userInput", self.text_enter)

    self.top_y = self.intext_text.y - (self.intext_text.height/2) - Data.sy
    self.bottom_y = self.text_input.y + self.text_input.height - Data.sy
    self.left_x = math.min(self.text_input.x, self.intext_text.x - (self.intext_text.width/2)) - Data.sx
    self.right_x = math.max(self.text_input.x + self.text_input.width, self.intext_text.x + (self.intext_text.width/2)) - Data.sx
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x

    return self
end

FreeNumInput = {}
function FreeNumInput.init(id, key, val_text, font_size, y_val, lft_mrg, spac1, input_width, text_hint, input_size, min_num, max_num, def_val)
    local self = setmetatable({}, FreeNumInput)
    self.sceneGroup = _sceneGroup
    local function setInput(input_text)
        local data = input_text
        local data_num = tonumber(data, 10)
        if data_num == nil then
            data_num = -1
        end
        local id_idx = table.indexOf(Data.errors, id)
        if data_num < min_num or data_num > max_num then
            if id_idx == nil then
                self.prompt_text:setFillColor(1,0,0)
                table.insert(Data.errors, (id))
                table.insert(Data.error_circle, {self.prompt_text.x + (self.prompt_text.width / 2), y_val, self.prompt_text.width, self.prompt_text.height})
            end
        else
            if id_idx ~= Nil then
                self.prompt_text:setFillColor(0,0,0)
                table.remove(Data.errors, id_idx)
                table.remove(Data.error_circle, id_idx)
            end
            local split = splitVals(data, self.id_need)
            setData(split, id, self.id_need)
            self.debug_text.text=tostring(data)
        end
    end

    y_val = y_val + Data.sy
    lft_mrg = lft_mrg + Data.sx
    self.id_need = calcIDNeed(max_num)
    for i=0,self.id_need-1 do
        add_id_key(id + i,key)
    end

    self.prompt_text = display.newText({parent=self.sceneGroup, text=val_text, x=lft_mrg, y=y_val, font=native.systemFont, fontSize=font_size, align="center"})
    self.prompt_text.anchorX=0
    self.prompt_text:setFillColor(0,0,0)

    self.click_away_box = display.newRect(self.sceneGroup,display.contentCenterX,display.contentCenterX,display.actualContentWidth,display.actualContentHeight)
    self.click_away_box.alpha=0
    self.click_away_box.isHitTestable = true
    self.click_away_box:addEventListener("tap", function() native.setKeyboardFocus(nil) end)

    self.line_input = native.newTextField(0, y_val, input_width, 1)
    self.line_input.anchorX=0
    self.line_input.x = self.prompt_text.x + self.prompt_text.width + spac1
    self.line_input.height = self.prompt_text.height
    self.line_input.size = input_size
    self.line_input.placeholder=text_hint
    self.line_input.inputType = "number"
    if def_val ~= nil then
        self.line_input.text = tostring(def_val)
    end

    self.sceneGroup:insert(self.line_input)

    self.debug_text = display.newText({parent=self.sceneGroup, text=tostring(def_val), x=0, y=y_val, font=native.systemFont, fontSize=12, align="left"})
    self.debug_text.anchorX = 0
    self.debug_text.x = self.line_input.x + self.line_input.width + spac1
    self.debug_text:setFillColor(0,0,0)
    self.debug_text.isVisible = show_debug_text

    setInput(tostring(def_val))

    self.text_enter = function(event)
        local data = ""
        if event.phase == "editing" then
            setInput(event.text)
        elseif event.phase == "submitted" then
            native.setKeyboardFocus(nil)          
        end
    end

    self.line_input:addEventListener("userInput", self.text_enter)

    self.top_y = self.prompt_text.y - (self.prompt_text.height/2) - Data.sy
    self.bottom_y = self.prompt_text.y + (self.prompt_text.height/2) - Data.sy
    self.left_x = self.prompt_text.x - Data.sx
    self.right_x = self.line_input.x + self.line_input.width - Data.sx
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x

    return self
end

SingleLineInput = {}
function SingleLineInput.init(id, key, val_text, font_size, y_val, lft_mrg, spac1, textbox_width, text_hint, input_size, def_val)
    local self = setmetatable({}, SingleLineInput)
    self.sceneGroup = _sceneGroup
    local function setInput(input_text)
        local data = input_text
        local id_idx = table.indexOf(Data.errors, id)
        if data == nil or data == "" then
            if id_idx == nil then
                self.prompt_text:setFillColor(1,0,0)
                table.insert(Data.errors, (id))
                table.insert(Data.error_circle, {self.prompt_text.x + (self.prompt_text.width / 2), y_val, self.prompt_text.width, self.prompt_text.height})
            end
        else
            if id_idx ~= Nil then
                self.prompt_text:setFillColor(0,0,0)
                table.remove(Data.errors, id_idx)
                table.remove(Data.error_circle, id_idx)
            end
            if id ~= 99 then
                data = string.gsub(data, "9", "")
            end
            Data.recorded_data[id] = data
            self.debug_text.text=tostring(data)
        end
    end

    y_val = y_val + Data.sy
    lft_mrg = lft_mrg + Data.sx
    self.id_need = 1
    add_id_key(id, key)

    self.prompt_text = display.newText({parent=self.sceneGroup, text=val_text, x=lft_mrg, y=y_val, font=native.systemFont, fontSize=font_size, align="center"})
    self.prompt_text.anchorX=0
    self.prompt_text:setFillColor(0,0,0)

    self.click_away_box = display.newRect(self.sceneGroup,display.contentCenterX,display.contentCenterX,display.actualContentWidth,display.actualContentHeight)
    self.click_away_box.alpha=0
    self.click_away_box.isHitTestable = true
    self.click_away_box:addEventListener("tap", function() native.setKeyboardFocus(nil) end)

    self.line_input = native.newTextField(0, y_val, textbox_width, 1)
    self.line_input.anchorX=0
    self.line_input.x = self.prompt_text.x + self.prompt_text.width + spac1
    self.line_input.height = self.prompt_text.height
    self.line_input.size = input_size
    self.line_input.placeholder=text_hint
    if def_val ~= nil then
        self.line_input.text = tostring(def_val)
    end

    self.sceneGroup:insert(self.line_input)

    self.debug_text = display.newText({parent=self.sceneGroup, text=tostring(def_val), x=0, y=y_val, font=native.systemFont, fontSize=12, align="left"})
    self.debug_text.anchorX = 0
    self.debug_text.x = self.line_input.x + self.line_input.width + spac1
    self.debug_text:setFillColor(0,0,0)
    self.debug_text.isVisible = show_debug_text

    setInput(def_val)

    self.text_enter = function(event)
        local data = ""
        if event.phase == "editing" then
            local data = event.text
            setInput(data)
        elseif event.phase == "submitted" then
            native.setKeyboardFocus(nil)          
        end
    end

    self.line_input:addEventListener("userInput", self.text_enter)

    self.top_y = self.prompt_text.y - (self.prompt_text.height/2) - Data.sy
    self.bottom_y = self.prompt_text.y + (self.prompt_text.height/2) - Data.sy
    self.left_x = self.prompt_text.x - Data.sx
    self.right_x = self.line_input.x + self.line_input.width - Data.sx
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x

    return self
end

QRCode = {}
function QRCode.init(data, dim, x_val, y_val)
    y_val = y_val + Data.sy
    x_val = x_val + Data.sx
    local self = setmetatable({}, QRCode)
    self.sceneGroup = _sceneGroup
    local ok, tab_or_msg = QREncode.qrcode(data)
    self.pixels = {}
    if not ok then
        self.err_txt = display.newText({parent=self.sceneGroup, text="QR Code Failed to Generate.", x=lft_mrg, y=y_val, font=native.systemFont, fontSize=40, align="center"})
        self.err_txt:setFillColor(0,0,0)
        print(tab_or_msg)
    else
        local col = table.getn(tab_or_msg)
        local row = table.getn(tab_or_msg[1])
        local pw = math.floor(dim/col + 0.5)
        local ph = math.floor(dim/row + 0.5)
        local new_width = col * pw
        local width_diff = new_width - dim
        x_val = x_val - (width_diff/2)
        for i,r in ipairs(tab_or_msg) do
            y = y_val + (ph*(i-1))
            for j,p in ipairs(r) do
                x = x_val + (pw*(j-1))
                --print("Printing pixel ("..tostring(i)..","..tostring(j)..") with color "..tostring(p).." at ("..tostring(x)..","..tostring(y)..")")
                pixel = display.newRect(self.sceneGroup, x, y, pw, ph)
                pixel.anchorX=0
                pixel.anchorY=0
                if p > 0 then
                    pixel:setFillColor(0,0,0)
                else
                    pixel:setFillColor(1,1,1)
                end
                table.insert(self.pixels,pixel)
            end
        end
    end

    self.top_y = y_val - Data.sy
    self.bottom_y = y_val + dim - Data.sy
    self.left_x = x_val - Data.sx
    self.right_x = x_val + dim - Data.sx
    self.height = self.bottom_y - self.top_y
    self.width = self.right_x - self.left_x

    return self
end

PopUp = {}
function PopUp.init(msg, msg_size, no_text, yes_text, button_size, handle_method)
    local self = setmetatable({}, PopUp)
    self.sceneGroup = _sceneGroup
    self.popup_group = display.newGroup()
    self.sceneGroup:insert(self.popup_group)

    self.tap_catcher = display.newRect(self.popup_group, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    self.tap_catcher:setFillColor(0,0,0)
    self.tap_catcher.alpha = 0.4
    --self.tap_catcher.isHitTestable = true
    self.tap_catcher:addEventListener("tap", function() return true end)

    self.popup = display.newRoundedRect(self.popup_group, display.contentCenterX, display.contentCenterY, 1, 1, 1)
    self.popup:setFillColor(1,1,1)
    self.popup:setStrokeColor(0,0,0)
    self.popup.strokeWidth = 4

    self.message = display.newText({parent=self.popup_group, text=msg, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=msg_size, align="center"})
    self.message:setFillColor(0,0,0)

    self.no_button = display.newRect(self.popup_group, display.contentCenterX, display.contentCenterY, 1, 1)
    self.no_button:setFillColor(0,0.2,1)
    self.no_button.alpha = 0
    self.no_button.isHitTestable = true
    self.no_button:addEventListener("tap", function() handle_method(false) end)

    self.no_text = display.newText({parent=self.popup_group, text=no_text, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=button_size, align="center"})
    self.no_text:setFillColor(0,0,0)

    self.yes_button = display.newRect(self.popup_group, display.contentCenterX, display.contentCenterY, 1, 1)
    self.yes_button:setFillColor(0,0.2,1)
    self.yes_button.alpha = 0
    self.yes_button.isHitTestable = true
    self.yes_button:addEventListener("tap", function() handle_method(true) end)

    self.yes_text = display.newText({parent=self.popup_group, text=yes_text, x=display.contentCenterX, y=display.contentCenterY, font=native.systemFont, fontSize=button_size, align="center"})
    self.yes_text:setFillColor(0,0,0)

    -- Popup dimensions
    local horz_spac = 10
    local vert_spac = 20
    self.width = math.max(self.message.width + (2*horz_spac), self.no_text.width + self.yes_text.width + (4*horz_spac))
    self.popup.width = self.width
    self.height = self.message.height + math.max(self.no_text.height, self.yes_text.height) + (4*vert_spac)
    self.popup.height = self.height
    self.popup.path.radius = math.floor(0.1*math.min(self.popup.width, self.popup.height))

    -- Message placement
    self.y_top = self.popup.y - (self.popup.height / 2)
    self.x_left = self.popup.x - (self.popup.width / 2)
    self.message.y = self.y_top + vert_spac
    self.message.anchorY=0

    -- Button placement
    self.button_height = math.max(self.no_text.height, self.yes_text.height)
    self.no_text.y = self.y_top + self.message.height + (3*vert_spac)
    self.no_text.anchorY=0
    self.no_text.x = self.x_left + (self.width/2) - (self.width/4)
    self.no_button.height = self.button_height + (2*vert_spac)
    self.no_button.width = (self.width/2) - 5
    self.no_button.y = self.y_top + self.message.height + (2*vert_spac)
    self.no_button.anchorY=0
    self.no_button.x = display.contentCenterX - 5
    self.no_button.anchorX=1
    self.yes_text.y = self.y_top + self.message.height + (3*vert_spac)
    self.yes_text.anchorY=0
    self.yes_text.x = self.x_left + (self.width/2) + (self.width/4)
    self.yes_button.height = self.button_height + (2*vert_spac)
    self.yes_button.width = (self.width/2) - 5
    self.yes_button.y = self.y_top + self.message.height + (2*vert_spac)
    self.yes_button.anchorY=0
    self.yes_button.x = display.contentCenterX + 5
    self.yes_button.anchorX=0
    self.option_line = display.newLine(self.popup_group, display.contentCenterX, self.yes_button.y, display.contentCenterX, self.yes_button.y + self.yes_button.height)
    self.option_line:setStrokeColor(0,0,0)
    self.option_line.strokeWidth = 2
    return self
end