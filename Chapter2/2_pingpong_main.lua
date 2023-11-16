--  设置别名为skynet
local skynet = require "skynet"

--  启动服务，用fuc函数初始化服务。
skynet.start(function()
    skynet.error("[Pmain] start")
    --  创建名（类型）为`name`的新服务，并返回新服务的地址
    local ping1 = skynet.newservice("ping")
    local ping2 = skynet.newservice("ping")

    --  ping1地址向ping2地址发送一条lua类型的消息，消息为“start”
    skynet.send(ping1, "lua", "start", ping2)
    skynet.exit()
end)