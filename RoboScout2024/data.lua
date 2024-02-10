module("Data", package.seeall)

ids = {}

recorded_data = {}

errors = {}
error_circle = {0,0,0,0}

function print_recorded_data()
    print("[")
    for i=0,table.getn(Data.recorded_data) do
        print(tostring(i)..":"..tostring(Data.recorded_data[i])..",")
    end
    print("]")
end

function get_recorded_data()
    local str = ""
    for i=0,table.getn(Data.recorded_data) do
        str = str..(tostring(i)..":"..tostring(Data.recorded_data[i]).."\n")
    end
    return str
end