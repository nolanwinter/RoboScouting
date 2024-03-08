module("Data", package.seeall)

local topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()
sx = display.screenOriginX + leftInset
sy = display.screenOriginY + topInset
sw = display.actualContentWidth - (leftInset + rightInset)
sh = display.actualContentHeight - (topInset + bottomInset)

tele_heading_size = nil

ids = {}
for i=0, 99 do
    ids[i] = false
end
keys = {}
for i=0, 99 do
    keys[i] = ""
end

recorded_data = {}
data_history = {}
for i=1,100 do
    data_history[i] = ""
end

errors = {}
error_circle = {}

scout_name = ""
match_num = ""
match_types = {"Qual", "Test"}
match_type = "Qual"
teams_to_scout = {"Red 1", "Red 2", "Red 3", "Blue 1", "Blue 2", "Blue 3"}
team_to_scout = "Red 1"

function print_recorded_data()
    print("[")
    for i=0,99 do
        if ids[i] == true then
            print("("..tostring(i)..")"..keys[i]..": "..tostring(Data.recorded_data[i])..",")
        end
    end
    print("]")
end

function get_readable_data_vert()
    local str = ""
    for i=0,99 do
        if ids[i] == true then
            data = Data.recorded_data[i]
            str = str..(tostring(keys[i])..":"..tostring(data).."\n")
        end
    end
    return str
end

function get_readable_data_peak_vert()
    local str = ""
    for i=0,2 do
        if ids[i] == true then
            data = Data.recorded_data[i]
            if i == 2 then
                data = Data.teams_to_scout[Data.recorded_data[i]]
            elseif i == 0 then
                if Data.recorded_data[i] == 1 then
                    data = "Qual"
                else
                    data = "Test"
                end
            end
            str = str..(tostring(keys[i])..": "..tostring(data).."\n")
        end
    end
    str = str..tostring(keys[3])..": "..tostring(Data.recorded_data[4]*100 + Data.recorded_data[3])
    return str
end

function get_readable_data()
    local str = ""
    for i=0,99 do
        if ids[i] == true then
            data = Data.recorded_data[i]
            str = str..(tostring(keys[i])..":"..tostring(data).." ")
        end
    end
    return str
end

function get_data_short()
    local str = ""
    for i=0,99 do
        if ids[i] == true then
            data = Data.recorded_data[i]
            if i < 10 then
                str = str.."0"
            end
            str = str..tostring(i)
            if (type(data) == "number") and data < 10 then
                str = str.."0"
            end
            str = str..tostring(data)
        end
    end
    return str
end

function update_qr_history()
	date_time = os.date("%m/%d/%y %H:%M:%S", os.time())
	readable_match_data = get_readable_data()
	short_match_data = get_data_short()
	saved_str = date_time.."\n"..readable_match_data.."\n"..short_match_data.."\n\n"
	table.insert(data_history, 1, saved_str)
	table.remove(data_history)
end

function save_history()
	local path = system.pathForFile("qr_history.txt", system.DocumentsDirectory)
	local file, errorStr = io.open(path, "w")
	if not file then
		error("Could not find qr_history.txt.", 1)
	else
		file_str = ""
		for i,v in ipairs(data_history) do
			if v ~= "" then
				file_str = file_str..v
			end
		end
		file:write(trim(file_str))
		io.close(file)
	end
	file = nil    
end

function read_history()
    local path = system.pathForFile("qr_history.txt", system.DocumentsDirectory)
    local file, errorStr = io.open(path, "r")
	if not file then
		--error("Could not find qr_history.txt.", 1)
	else
        line = ""
        for i=1, table.getn(data_history) do
            match_str = ""
            if line == nil then
                break
            end
            while true do
                line = file:read("*l")
                if line == nil or line == "" then
                    break
                else
                    match_str = match_str..line.."\n"
                end
            end
            data_history[i] = match_str.."\n"
        end
        io.close(file)
    end
end
            
function trim(s)
    return s:match'^%s*(.*%S)' or ''
end