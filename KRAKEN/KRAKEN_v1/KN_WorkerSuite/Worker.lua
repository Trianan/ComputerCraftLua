--[[
    KRAKEN Industrial Control - Worker Suite
    ----------------------------------------
    File: Worker.lua
    Author: BlitNaN Corporation
    Version: Beta 1.0
    Description:
        This program starts the KIC Worker service,
        enabling its control by a RedNet-connected
        computer running the KIC Controller service.
]]

----------------------------------------------------------------------

--Load KICx Communication Protocol API and set protocol tables:
os.loadAPI("KN_Protocols.lua")
P = KN_Protocols.KICxProtocols.KICW
HP = KN_Protocols.KICxProtocols.KICH
BP = KN_Protocols.KICxProtocols.KICB

----------------------------------------------------------------------

--Worker Service Class:
Worker = {
    ID=nil,
    label=nil,
    controller={
        ID=nil,
        label=nil
    },
    RS_ACTIVE=false
}
function Worker:__init__()
    self.ID = os.getComputerID()
    self.label = os.getComputerLabel()
    return self
end
setmetatable(Worker, {__call=Worker.__init__})

--Opens communication channel with syncing Controller:
function Worker:syncController()
    while not self.controller.ID do

        --Advertise worker available:
        local msg = KICxMsg(
            self.ID,
            BP._name,
            BP.advertise,
            {"Commander solicitation broadcast"}
        )
        textutils.serialise(msg)
        rednet.broadcast(msg)

        -- Sync flag received:
        local id, reply = rednet.receive(HP._name , 2)
        reply = textutils.deserialize(reply)
        if id and reply.flag == HP.syn then
            print("Sync request received from "..id)

            --Send sync acknowledgement:
            local msg = KICxMsg(
                self.ID,
                HP._name,
                HP.ack,
                {"Commander sync acknowledgement"}
            )
            textutils.serialise(msg)
            rednet.send(id, msg, HP._name)

            --Await final acknowledgement:
            local id2, reply = rednet.receive(HP._name , 2)
            reply = textutils.deserialize(reply)
            if id2 == id and reply.flag == HP.ack then
                print("Commander found: "..id.." - "..reply.sender)
                self.commander.ID = id
                self.commander.label = reply.sender
                return true
            end
        end
    --END 'while not self.controller.ID'
    end
    return false
end

----------------------------------------------------------------------

