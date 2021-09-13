-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   header.lua                                         :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/09/12 20:57:30 by vgoncalv          #+#    #+#             --
--   Updated: 2021/09/13 12:11:44 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local header = {}

local config = require("header42.config").values
local constants = require("header42.constants")

local fn = vim.fn
local bo = vim.bo

--- Formats the header for insertion
local function format_header(start_comment, end_comment, fill_comment)
	local filename = fn.expand("%:t")

	-- Calculate spaces to keep the header tidy
	local SPACES_AFTER_FILENAME = constants.length - (2 * constants.margin) - string.len(filename) - 19
	local SPACES_AFTER_EMAIL = constants.length - (2 * constants.margin) - string.len(config.mail) - 38

	-- stylua: ignore
	return string.format(constants.header,
		start_comment, string.rep(fill_comment, 74), end_comment,
		start_comment, end_comment,
		start_comment, end_comment,
		start_comment, filename, string.rep(' ', SPACES_AFTER_FILENAME), end_comment,
		start_comment, end_comment,
		start_comment, config.user, config.mail, string.rep(' ', SPACES_AFTER_EMAIL), end_comment,
		start_comment, end_comment,
		start_comment, fn.strftime("%Y/%m/%d %H:%M:%S"), config.user, end_comment,
		start_comment, fn.strftime("%Y/%m/%d %H:%M:%S"), config.user, end_comment,
		start_comment, end_comment,
		start_comment, string.rep(fill_comment, 74), end_comment
	)
end

--- Adds École 42 header to current buffer
header.insert = function(start_comment, end_comment, fill_comment)
	-- Adds each line of the header on the current file
	local lineno = 0
	local formated_header = format_header(start_comment, end_comment, fill_comment)
	for line in formated_header:gmatch("(.-)\n") do
		fn.append(lineno, line)
		lineno = lineno + 1
	end
end

-- Updates if header is already present on the file
header.update = function(start_comment, end_comment)
	-- Check if filetype is supported
	if config.ft[bo.filetype] == nil then
		return false
	end

	-- Check if file was modified
	if bo.mod then
		return true
	end

	-- Searches for the "Updated by" line of the header
	local found = fn.getline(9):find(start_comment .. string.rep(" ", constants.margin - #start_comment) .. "Updated: ")

	if found then
		local filename = fn.expand("%:t")
		local SPACES_AFTER_FILENAME = constants.length - (2 * constants.margin) - string.len(filename) - 19

		-- Sets the filename line(useful for when renaming files)
		fn.setline(
			4,
			string.format(
				"%2s   %s%s:+:      :+:    :+:   %2s",
				start_comment,
				filename,
				string.rep(" ", SPACES_AFTER_FILENAME),
				end_comment
			)
		)

		-- Sets the "Updated by" line of the header
		fn.setline(
			9,
			string.format(
				"%2s   Updated: %19s by %7s         ###   ########.fr       %2s",
				start_comment,
				fn.strftime("%Y/%m/%d %H:%M:%S"),
				config.user,
				end_comment
			)
		)
		return true
	end

	return false
end

return header
