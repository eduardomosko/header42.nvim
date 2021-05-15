# header42.nvim
42's stdheader plugin written in Lua

Same as [stdheader](https://github.com/42og/stdheader.vim), but in lua.

Also fixes an annoying but clipped your email.

Just install using your package manager of choice:

```lua
use 'eduardomosko/header42.nvim'
```

You may configure your username and email as such:

```lua
local header = require 'header42'

header.user = 'emendes-'
header.email = '@students.42sp.org.br'

-- Add support to other languages:
-- header.types['/regex/'] = {'begin-comment', 'filler', 'end-comment'}

header.types['\\.sh$\\|\\.py$'] = {'#', '*', '#'}
```

And map as wanted:

```lua
vim.cmd 'nnoremap <F1> :Stdheader'
vim.cmd 'autocmd BufNewFile *.c,*.h :Stdheader'
```
