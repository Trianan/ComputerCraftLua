--FILE    : massCopy.lua
--AUTHOR  : TriaNaN Corp.
--VERSION : 1.0
--DESCRIP :
--    Copies all files from drive named "disk"
--    in root directory to all other drives
--    connected to terminal.

local sourceDrive = fs.exists("disk")
if sourceDrive then
  print("Starting mass copy...")
  print("Source drive contents:")
  shell.run("ls disk/")

  local drives = fs.list(".")
  for i, drive in pairs(drives) do
    local copyDrive = string.match(
      drive,
      "^disk%d+$"
    )
    if copyDrive then
      print("Writing to "..copyDrive.."...")
      if fs.list(copyDrive) then
        shell.run("rm "..copyDrive.."/*")
      end
      shell.run("copy disk/* "..copyDrive)
    end
  end
  
  --Set copy labels:
  print("Copying label to disks...")
  local copyLabel = disk.getLabel("bottom")
  local copyDrives = peripheral.getNames()
  for i, drive in pairs(copyDrives) do
    local copyDrive = string.match(
      drive,
      "^drive_%d+$"
    )
    if copyDrive then
      shell.run(
        "label set "..copyDrive.." "..copyLabel
      )
    end
  end
  
else
    print("No source drive detected.")
end
    
