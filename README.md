This repository will no longer be maintained. I recommend moving to https://github.com/vinicius507/header42.nvim.


# header42.nvim

École 42's stdheader plugin written in Lua

## Installation

Just install using your package manager of choice:

```lua
use 'eduardomosko/header42.nvim'
```


## Setup

You may configure your username and email as such:

```lua
local header = require('header42')

header.setup({
	user = 'marvin',
	mail = 'marvin@42.fr',
	-- You can also extend filetypes, e.g:
	ft = {
		lua = {
			start_comment = '--',
			end_comment = '--',
			fill_comment = '-',
		}
	}
})
```

## Supported Filetypes by Default

- `c` for C files
- `cpp` for C++ and header files
- `python` for python files
- `lua` for lua files
- `make` for Makefiles
- `vim` for vimscript files

## Mappings

header42.nvim does not provide default mappings, so you can map a to the command `<cmd>Stdheader`.

Although this plugins does not provide mappings, it sets up `autocmd` to update the header.
