module("Data", package.seeall)

local topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()
sx = display.screenOriginX + leftInset
sy = display.screenOriginY + topInset
sw = display.actualContentWidth - (leftInset + rightInset)
sh = display.actualContentHeight - (topInset + bottomInset)

local match_queue = {}
local match_num = 0

local ip = "temportal.us"--"localhost"--"128.61.104.120"
local port = 7103
local client
local socket = require("socket")

function add_match_to_queue(match_data)
    table.insert(match_queue, match_data)
    match_num = match_num + 1
end

function send_match_to_server()
    m = 1
    while m <= match_num do
        client = assert(socket.connect(ip, port), "Connection failed.")
        client:settimeout(20000)
        print("Sending index "..tostring(m).." : "..tostring(match_queue[m]))
        assert(client:send(match_queue[m]), "Send failed.")
        ack, err = client:receive('*a')
        if ack == match_queue[m] then
            match = table.remove(match_queue,m)
            match_num = match_num - 1
            print("Success. Removed: "..match)
        else
            m = m + 1
            if ack == nil then
                print("Failure: "..err)
            else
                print("Failure got: "..ack..".")
            end
        end
        client:shutdown()
        client:close()
    end
    return match_num == 0
end