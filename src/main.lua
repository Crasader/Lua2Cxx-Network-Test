require "Cocos2d"
require "Cocos2dConstants"
local tcDataTable = require "luatest"

-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

function printTargetTable( t )
    -- body
    print("========== data to send from client =========")
    print(table.show(t,"data"))
    
end


function luaCallBack( t )
  -- body
  print("========== data received from server =========")
  print(table.show(t,"data"))
end


local function initUi( scene )
    local tcTotal = 12
    local width = 960
    local height = 640
    local colCount = 7

    local tipLabel = cc.LabelTTF:create("","微软雅黑",100)
    tipLabel:setPosition(cc.p(568,200))
    local layer = cc.Layer:create()

    local tipLabel = cc.LabelTTF:create("","微软雅黑",100)
    tipLabel:setPosition(cc.p(568,200))
    for i=1,tcTotal do
        local colNum = (i % colCount == 0) and colCount or (i % colCount)
        local rowNum = math.ceil(i/colCount)
        
        local label = cc.LabelTTF:create("TC"..(i-1),"微软雅黑",50)
        label:setAnchorPoint(0,1)
        label:setPosition(cc.p((colNum - 1)*150,height - ((rowNum - 1)*100)))
        layer:addChild(label)

        local listener = cc.EventListenerTouchOneByOne:create()
        local function onTouchBegan(touch, event)
            local target = event:getCurrentTarget()
            local locationInNode = target:convertToNodeSpace(touch:getLocation())
            local s = target:getContentSize()
            local rect = cc.rect(0, 0, s.width, s.height)

            if cc.rectContainsPoint(rect, locationInNode) then
                local tcData = tcDataTable[target:getString()]
                printTargetTable(tcData)
                sendData(tcData)

                tipLabel:setString(target:getString())
                return true
            end

            return false
        end
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
        local eventDispatcher = scene:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, label)
    end

    scene:addChild(layer)
    layer:setPosition(cc.p(70,0))

    
    scene:addChild(tipLabel)
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
	
    local sceneGame = cc.Scene:create()
    initUi(sceneGame)
    
    require "luatest"
	
	if cc.Director:getInstance():getRunningScene() then
		cc.Director:getInstance():replaceScene(sceneGame)
	else
		cc.Director:getInstance():runWithScene(sceneGame)
	end

end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
