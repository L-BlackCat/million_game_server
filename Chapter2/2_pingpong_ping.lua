local skynet = require "skynet"

local CMD = {}

function CMD.start(source, target)
    skynet.send(target, "lua", "ping", 1)
end

function CMD.ping(source, count)
    local id = skynet.self()
    skynet.error("["..id.."] recv ping count="..count)
    skynet.sleep(100)
    skynet.send(source, "lua", "ping", count+1)
end


skynet.start(function()
    --[[
    session：代表消息的唯一id
    source：代表消息的来源，指发送消息的地址
    cmd：代表消息名
    ...:可变参数，内容由skynet.start和skynet.call指定
    --]]
    skynet.dispatch("lua", function(session, source, cmd, ...)
        --  通过消息的名字`cmd`在`CMD`表中查找对应的处理函数，并将其赋值给变量`f`。如果找不到对应的处理函数，`assert`函数会抛出错误。
        local f = assert(CMD[cmd])
        --  调用找到的处理函数，并传递消息的来
        f(source,...)
    end)
end)