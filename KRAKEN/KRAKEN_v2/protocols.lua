--KIC Communication Protocol API:
--Lua Interpreter: 5.1.5 & CraftOS Lua
----------------------------------------------------------------------
local protocols = {}

local function serialize(data)
    if textutils then
        return textutils.serialize(data)
    end
    return tostring(data)
end 


----------------------------------------------------------------------
--Vigenere Cipher Encryption (shared-key):
function protocols.encrypt(message, keyword)
    local encrypted = {}
    local keywordIndex = 1
    for i = 1, #message do
        local char = message:sub(i, i)
        local keywordChar = keyword:sub(keywordIndex, keywordIndex)
        local charCode = string.byte(char)
        local keywordCode = string.byte(keywordChar)
        if charCode >= 32 and charCode <= 126 then
            local encryptedCode = (charCode + keywordCode - 64) % 95 + 32
            encrypted[#encrypted + 1] = string.char(encryptedCode)

            keywordIndex = keywordIndex % #keyword + 1
        else
            encrypted[#encrypted + 1] = char
        end
    end
    return table.concat(encrypted)
end

--Vigenere Cipher Decryption (shared-key):
function protocols.decrypt(encrypted, keyword)
    local decrypted = {}
    local keywordIndex = 1
    for i = 1, #encrypted do
        local char = encrypted:sub(i, i)
        local keywordChar = keyword:sub(keywordIndex, keywordIndex)
        local charCode = string.byte(char)
        local keywordCode = string.byte(keywordChar)
        if charCode >= 32 and charCode <= 126 then
            local decryptedCode = (charCode - keywordCode + 95) % 95 + 32
            decrypted[#decrypted + 1] = string.char(decryptedCode)

            keywordIndex = keywordIndex % #keyword + 1
        else
            decrypted[#decrypted + 1] = char
        end
    end
    return table.concat(decrypted)
end


--Tests:
local original = {
    peerID=5,
    content="Howdy there partner!",
    protocol="KICs"
}
print(serialize(original))

local testkey = "19187324897123476187162348761233871623498"
original.content = protocols.encrypt( original.content, testkey )
print(serialize(original))

original.content = protocols.decrypt( original.content, testkey )
print(serialize(original))
----------------------------------------------------------------------


--Diffie-Hellman Key Exchange:
local function getKey(p, q, localPrivKey)
    key = 
    sharedPublicKey.q^localPrivKey % sharedPublicKey.p
    return key
end

function protocols.getSharedPrivKey(peerID, localPrivKey)

    local localFactor = math.random(100, 1000)
    print("Test: sent "..localFactor.." to peer-"..peerID)--replace w. rednet.send()

    local peerFactor = math.random(100,1000)--replace w. rednet.receive()
    print("Test: received "..peerFactor.." from peer-"..peerID)

    local sharedPublicKey=nil
    if peerFactor then
        sharedPublicKey = {
            p=math.min(localFactor, peerFactor),
            q=math.max(localFactor, peerFactor)
        }
    else
        print("Public key generation failed: no factor from peer.")
        return nil
    end

    print("Shared Public Key: ("..sharedPublicKey.p..","..sharedPublicKey.q..")")
    local localTempKey = getKey(
        sharedPublicKey.p,
        sharedPublicKey.q,
        localPrivKey
    )
    print("Test: sent temp key to peer-"..peerID..": "..localTempKey)--replace w. rednet.send()

    --replace w. rednet.receive()
    local peerTempKey = getKey(
        sharedPublicKey.p,
        sharedPublicKey.q,
        746--this would be stored on peer system
    )
    print("Test: received temp key from peer-"..peerID..": "..peerTempKey)
    if peerTempKey
    
    return sharedPrivKey
end








----------------------------------------------------------------------
return protocols