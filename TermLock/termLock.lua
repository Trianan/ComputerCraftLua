--FILE    : termLock.lua
--AUTHOR  : TriaNaN Corp.
--VERSION : 1.0
--DESCRIP :
--    This program locks the computer in a loop
--    that can only be exited if the correct
--    password from pswd.txt is given.
--    Meant to be put in /rom/autorun/

--Disables quitting w. CTRL+T:
local pullEvent = os.pullEvent 
os.pullEvent = os.pullEventRaw 

local pswdFile = fs.open("pswd.txt", "r")
local MAX_ATMPT  = 3
local LOCKDOWN_S = 60

local function resetTerm()
    term.clear()
    term.setCursorPos(1,1)
    return nil
end

if pswdFile then
    local username = pswdFile.readLine()
    local password = pswdFile.readLine()
    pswdFile.close()
    
    local guess    = nil
    local attempts = MAX_ATMPT
    
    while guess ~= password do
        
        --Guess made & incorrect:
        if guess and guess ~= password then
            attempts = attempts - 1
            resetTerm()
            print("Incorrect password")
            print(attempts.." attempts left.")
            sleep(3)
        end
        
        --Out of attempts: lock out user:
        if attempts < 1 then
            local s = LOCKDOWN_S
            while s > 0 do
                resetTerm()
                print("System Lockdown")
                print(s.." seconds remaining.")
                s = s - 1
                sleep(1)
            end
            attempts = MAX_ATMPT
        end
        
        resetTerm()
        write("Password: ")
        guess = io.read()
    end
    
    --Correct password given.
    resetTerm()
    print("Access Granted!")
    --Re-enables quitting w. CTRL+T
    os.pullEvent = pullEvent
    sleep(2)
    resetTerm()
    textutils.slowPrint("Hello, "..username)
else
    print("Error: No password file found.")
end
   
