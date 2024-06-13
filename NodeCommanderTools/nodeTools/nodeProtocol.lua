
local localID = os.getComputerID()
local localLabel = os.getComputerID()

--At minimum, all messages communicated through
--these protocols must be in the following format:
--    {
--      sender  = <localLabel>,
--      content = <protocol_message>,
--      [optional] = <extra data>
--    }
--When sending messages in this format,
--always specify the protocol, and only use
--the hardcoded messages provided in the following
--protocol message tables:


--NodeCommander RedNet Protocols:
protocols = {
    --NodeCommander Handshake Protocol:
    NCHP = {
        sync   = "SYN",
        ack    = "ACK",
    },
    --NodeCommander Command Protocol:
    NCCP = {
        rs_off = "RS_OFF",
        rs_on  = "RS_ON",
        status = "SEND_STATUS",
        leave  = "BYE"
    },
    --NodeCommander Broadcast Protocol:
    NCBP = {
        advertise = "Advertisement: "..localLabel,
        emergency = "Emergency at: "..localLabel
    }
}
        
    
