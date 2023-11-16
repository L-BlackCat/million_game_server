local skynet = require "skynet"
local socket = require "skynet.socket"
local mysql = require "skynet.db.mysql"

local db= nil


function connect(fd, addr)
    --????????
    print(fd.." connected addr:"..addr)
    socket.start(fd)
    --???????
    while true do
        local readdata = socket.read(fd)
		--????????
		if readdata ~= nil then
			--?????????????
			if readdata == "get\r\n" then
				local res = db:query("select * from msgs")
				for i,v in pairs(res) do
					socket.write (fd, v.id.." "..v.text.."\r\n")
				end
			--????
			else
				local data = string.match( readdata, "set (.-)\r\n")
				db:query("insert into msgs (text) values (\'"..data.."\')")
			end
        --???????
        else
            print(fd.." close ")
            socket.close(fd)
        end
	end
end

skynet.start(function()
    --???????
    local listenfd = socket.listen("0.0.0.0", 8888)
    socket.start(listenfd ,connect)
    --?????????
    db=mysql.connect({
            host="127.0.0.1",
            port=3306,
            database="message_board",
            user="root",
            password="12345678aB+",
            max_packet_size = 1024 * 1024,
            on_connect = nil
        })
end)