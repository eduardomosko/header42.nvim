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

local M = {}

local config = require("header42.config")
local utils = require("header42.utils")
local bo = vim.bo

M.setup = function(opts)
	config.set(opts)
end

--- Global function for command!
_G.Stdheader = function()
	local filetype = bo.filetype

	-- Error handling
	if config.values.ft[filetype] == nil then
		utils.error(string.format("Filetype '%s' is not registered", filetype))
		return
	else
		local fields = { "start_comment", "end_comment", "fill_comment" }
		for _, field in ipairs(fields) do
			if config.values.ft[filetype][field] == nil then
				utils.error(string.format("Missing required field for filetype '%s': %s", filetype, field))
				return
			end
		end
	end

	local header = require("header42.header")
	local start_comment = config.values.ft[filetype].start_comment
	local end_comment = config.values.ft[filetype].end_comment
	local fill_comment = config.values.ft[filetype].fill_comment

	-- If header was not updated, insert it
	if not header.update(start_comment, end_comment) then
		error("entrei por algum motivo")
		header.insert(start_comment, end_comment, fill_comment)
	end
end

_G.Stdheader_update = function()
	local filetype = bo.filetype

	local start_comment = config.values.ft[filetype].start_comment
	local end_comment = config.values.ft[filetype].end_comment

	require("header42.header").update(start_comment, end_comment)
end

vim.api.nvim_command([[command! Stdheader lua Stdheader()]])
vim.api.nvim_command([[autocmd BufWritePre * lua Stdheader_update()]])

return M
