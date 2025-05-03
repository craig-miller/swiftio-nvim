# swiftio-nvim
**swiftio-nvim** is a NeoVim plugin for the MadMachine Embedded Swift Build/Deploy Tools available in the MM-SDK.

**MadMachine Build**
![MadMachine Build](https://github.com/user-attachments/assets/f290a10c-d55f-4012-afc5-063cdbaaec65)

**Serial Monitor**
![Serial Monitor](https://github.com/user-attachments/assets/a15867ed-4129-47af-b1f6-4ae48228364f)


## Features
   * **init**
   * **build**
   * **clean**
   * **download** to your swiftio micro (standalone or playground)

   Extra
   * **monitor** swiftio micro board

## Pre-requisites
   * macOS
   * [mm-sdk](https://docs.madmachine.io/overview/getting-started/software-prerequisite)
      | > [!NOTE] You do not need the VSCode Extension listed on that page
   * [nu shell](https://github.com/nushell/nushell)

## Installation 

### Lazy.nvim

```lua
{
   "craig-miller/swiftio",
   config = function()
      require("swiftio").setup({
	    -- Root of your mm_sdk, no trailing /
	    mm_sdk_path = "~/mm-sdk",
      })
   end,
}
```


## Commands 
| Command | Description|
| --------------- | ---------------------------------------- |
| SwiftIOInit | mm init |
| SwiftIOBuild| mm build |
|SwiftIOClean | mm clean |
| SwiftIODownload | mm download |
| SwiftIOMonitor | Connect to swiftio micro debug console   |

## License MIT
