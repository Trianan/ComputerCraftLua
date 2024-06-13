
--Load communication protocols:
os.loadAPI("disk/nodeTools/nodeProtocol.lua")

--Handshake protocol:
hpName = "NCHP"
hp = nodeProtocol.protocols.NCHP

--Command protocol:
cpName = "NCCP"
cp = nodeProtocol.protocols.NCCP

--
local node = {
    ID    = os.getComputerID(),
    label = os.getComputerLabel(),
    commander   = nil,
    commanderID = nil,
    RS_ACTIVE   = false
}

local nodeControls = {
    RS_ON  = activateRS,
    RS_OFF = deactivateRS
}

local function syncCommander()
    print("Searching for commanders...")
    id, invite, protocol = rednet.receive(5)
    --Listen for handshakes:
    if id and invite and protocol == hpName then
        invite = textutils.unserialise(invite)
        --If handshake invitation found:
        if invite.content == hp.sync then
            print("Sync invitation received.")
            cmdrID = id
            --Send acknowledgment:
            ack = {
                sender  = nodeLabel,
                content = hp.ack
            }
            rednet.send(
                cmdrID,
                textutils.serialise(ack),
                hpName
            )
            --Listen for confirmation from same ID:
            id, reply, protocol = rednet.receive(5)
            if id == cmdrID and reply then
                if protocol == hpName then
                    textutils.unserialize(reply)
                    if reply.content == hp.ack then
                        node.commander = reply.sender
                        node.commanderID = cmdrID
                        print(
                            "Sync with "..
                            node.commander..
                            "was successful!"
                        )
                        return true
                    end
                end
            end

        end
    end
    print("Sync failed.")
    return false
end

local function leaveCommander()
    rednet.send(
        node.commanderID,
        cp.leave,
        cpName
    )
    node.commanderID    = nil
    node.commanderLabel = nil
end

local function activateRS()
    return true
end

local function deactivateRS()
    return true
end

local function startKernel()
    local run = true
    print("Starting NodeCommander node kernel...")

    if syncCommander() then
        while run do
            cmd = io.read()
            if cmd == "quit" then
                deactivateRS()
                leaveCommander()
                run = false
            end
        end
    else
        print("Cannot start node kernel.")
    end

end

startKernel()
print("Quitting node kernel")
