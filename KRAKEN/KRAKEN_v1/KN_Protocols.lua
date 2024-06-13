--[[
    KRAKEN Industrial Control - Common Suite
    ----------------------------------------
    File: KN_Protocols.lua
    Author: BlitNaN Corporation
    Version: Beta 1.0
    Description:
        This API specifies various flags that
        must be used when communicating over RedNet
        by the KICx suite of protocols also specified
        here.
]]
----------------------------------------------------------------------

--Specifies KICx message format and its methods:
KICxMsg = {
    sender   = nil,
    senderID = nil,
    recvrID  = nil,
    protocol = nil,
    flag     = nil,
    data     = {}
}
function KICxMsg.__init__(r, p, f, d)
    local self = {
        sender   = os.getComputerLabel(),
        senderID = os.getComputerID(),
        recvrID  = r,
        protocol = p,
        flag     = f,
        data     = d
    }
    setmetatable(self, {__index=KICxMsg})
    return self
end
setmetatable(KICxMsg, {__call=KICxMsg.__init__})

----------------------------------------------------------------------

KICxProtocols = {
    --KIC Handshake Protocol:
    KICH={
        _name="KICH",
        syn="SYN",
        ack="ACK",
    },
    --KIC Commander Protocol:
    KICC={
        _name="KICC",
        activate="ACT",
        deactivate="DACT",
        kick="KICK",
        report="REP",
        update="UPD"
    },
    --KIC Worker Protocol:
    KICW={
        _name = "KICW",
        leave="BYE",
        reportStatus="REP_STAT",
        updateSuccess = "UPD_SUCCESS",
        updateFail    = "UPD_FAILED",
    },
    --KIC Broadcast Protocol:
    KICB={
        _name="KICB",
        advertise="ADV",
        emergency="SOS"
    }
}