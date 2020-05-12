#!/usr/bin/env lua
local ss = require("signalslots")

local B = {}
function B:proc()
    print("signal b: member function")
end
ss.Object:Declare(B)

local C = {}
function C:proc()
    print("signal c: member function")
end
ss.Object:Declare(C)

local a = ss.Object:new()
a:signals():register("a")

-- 从C++的测试用例抄来
local cb = function()
    print("signal a: lambda")
end
a:signals():connect("a", cb)

local b = B:new()
b:signals():register("b")

cb = function()
    print("signal b: lambda")
end
b:signals():connect("b", cb)
a:signals():connect("a", b.proc, b)

local c = C:new()
c:signals():register("c")
a:signals():connect("a", c.proc, c)
c:drop()

a:signals():emit("a")
b:signals():emit("b")
