-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   header42.lua                                       :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: emendes- <emendes-@students.42sp.org.br>   +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/05/15 11:51:46 by emendes-          #+#    #+#             --
--   Updated: 2021/05/15 11:51:46 by emendes-         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local asciiart = {
	         ":::      ::::::::",
	       ":+:      :+:    :+:",
	     "+:+ +:+         +:+  ",
	   "+#+  +:+       +#+     ",
	 "+#+#+#+#+#+   +#+        ",
	      "#+#    #+#          ",
	     "###   ########.fr    "
}

local config = {
	user = "marvin",
	mail = "@42.fr",
	types = {}
}

local _start	= '/*'
local _end		= '*/'
local _fill		= '*'
local _length	= 80
local _margin	= 5

config.types['\\.htm$\\|\\.html$\\|\\.xml$'] = {'<!--', '-->', '*'}
config.types["\\.l$\\|\\.lua$"] = {'--', '--', '-'}
config.types['\\.js$'] = {'//', '//', '*'}
config.types['\\.tex$'] = {'\\', '\\', '*'}
config.types['\\.ml$\\|\\.mli$\\|\\.mll$\\|\\.mly$'] = {'(*', '*)', '*'}
config.types['\\.vim$\\|vimrc$'] = {'"', '"', '*'}
config.types['\\.el$\\|emacs$'] = {';', ';', '*'}
config.types['\\.f90$\\|\\.f95$\\|\\.f03$\\|\\.f$\\|\\.for$'] = {'!', '!', '/'}
config.types['\\.c$\\|\\.h$\\|\\.cc$\\|\\.hh$\\|\\.cpp$\\|\\.hpp$\\|\\.php$'] = {'/*', '*/', '*'}

local function filename()
	return vim.fn.expand("%:t") or "< new >"
end

local function filetype()
	local f = filename()

	for type, chars in pairs(config.types) do
		local re = vim.regex(type)
		if re:match_str(f) then
			_start	= chars[1]
			_end	= chars[2]
			_fill	= chars[3]
			return
		end
	end
end

local function ascii(n)
	return asciiart[n - 2]
end

local function textline(left, right)
	right = right or ""

	local l	= _start .. string.rep(' ', _margin - #_start) .. left
	local r = string.rep(' ', _length - _margin * 2 - #left - #right) .. right .. string.rep(' ', _margin - #_end) .. _end
	return (l .. r):sub(0, _length)
end


local function user()
	return config.user
end


local function mail()
	return config.user .. config.mail
end


local function date()
	return vim.fn.strftime "%Y/%m/%d %H:%M:%S"
end

local function line(n)
	if n == 1 or n == 11 then -- top and bottom line
		return _start .. ' ' .. string.rep(_fill, _length - #_start - #_end - 2) .. ' ' .. _end
	elseif n == 2 or n == 10 then -- blank line
		return textline('', '')
	elseif n == 3 or n == 5 or n == 7 then -- empty with ascii
		return textline('', ascii(n))
	elseif n == 4 then -- filename
		return textline(filename(), ascii(n))
	elseif n == 6 then -- author
		return textline("By: " .. user() .. " <" .. mail() .. ">", ascii(n))
	elseif n == 8 then -- created
		return textline("Created: " .. date() .. " by " .. user(), ascii(n))
	elseif n == 9 then -- updated
		return textline("Updated: " .. date() .. " by " .. user(), ascii(n))
	end
end


local function insert()
	local lineno = 11
	filetype()

	-- empty line after header
	vim.fn.append(0, "")

	-- loop over lines
	while lineno > 0 do
		vim.fn.append(0, line(lineno))
		lineno = lineno - 1
	end
end

local function update()
	filetype()
	local getline = vim.fn.getline

	local found = getline(9):find(_start .. string.rep(' ', _margin - #_start) .. "Updated: ")
	if found then
		vim.fn.setline(9, line(9))
		vim.fn.setline(4, line(4))
		return false
	end
	return true
end

function Stdheader()
	if update() then
		insert()
	end
end

-- Bind command and shortcut
vim.api.nvim_command("command! Stdheader lua Stdheader()")

return config
