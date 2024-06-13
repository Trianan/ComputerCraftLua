local cmdrID = os.getComputerID()
local cmdrLabel = os.getComputerLabel()
local connectedNodes = {}

function connectNodes()
    --Sends label and invitation to 
    --connect over network
    --and connects replying nodes.
    --Returns a boolean based on successful
    --connection to nodes.
    invitation = label.."|SYN"
    rednet.broadcast(invitation)
    id, reply = rednet.receive(10)
    if id and reply then
        print("ID-"..id.." replied:")
        reply = split(reply, "|")
        for field in reply do
            print(field)
        end
    else
        return false
    end
return true 
        
        

    
