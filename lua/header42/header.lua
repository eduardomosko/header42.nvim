-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   header.lua                                         :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/09/12 20:57:30 by vgoncalv          #+#    #+#             --
--   Updated: 2021/12/15 22:38:27 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local header = {}

local config = require("header42.config")
local constants = require("header42.constants")

local fn = vim.fn
local bo = vim.bo

--- Formats the header for insertion
local function format_header(ft_config)
	local filename = fn.expand("%:t")
	local user = ft_config.user or config.user
	local mail = ft_config.mail or config.mail
	-- Calculate spaces to keep the header tidy
	local SPACES_AFTER_FILENAME = constants.length - (2 * constants.margin) - string.len(filename) - 19
	local SPACES_AFTER_EMAIL = constants.length - (2 * constants.margin) - string.len(mail) - string.len(user) - 30
	local SPACES_AFTER_CREATED = constants.length - (2 * constants.margin) - string.len(user) - 52
	local SPACES_AFTER_UPDATED = SPACES_AFTER_CREATED - 1
	-- stylua: ignore
	return string.format(constants.header,
		ft_config.start_comment, string.rep(ft_config.fill_comment, 74), ft_config.end_comment,
		ft_config.start_comment, ft_config.end_comment,
		ft_config.start_comment, ft_config.end_comment,
		ft_config.start_comment, filename, string.rep(' ', SPACES_AFTER_FILENAME), ft_config.end_comment,
		ft_config.start_comment, ft_config.end_comment,
		ft_config.start_comment, user, mail, string.rep(' ', SPACES_AFTER_EMAIL), ft_config.end_comment,
		ft_config.start_comment, ft_config.end_comment,
		ft_config.start_comment, fn.strftime("%Y/%m/%d %H:%M:%S"), user, string.rep(' ', SPACES_AFTER_CREATED), ft_config.end_comment,
		ft_config.start_comment, fn.strftime("%Y/%m/%d %H:%M:%S"), user, string.rep(' ', SPACES_AFTER_UPDATED), ft_config.end_comment,
		ft_config.start_comment, ft_config.end_comment,
		ft_config.start_comment, string.rep(ft_config.fill_comment, 74), ft_config.end_comment
	)
end

--- Adds École 42 header to current buffer
header.insert = function(ft_config)
	-- Adds each line of the header on the current file
	local lineno = 0
	local formated_header = format_header(ft_config)
	for line in formated_header:gmatch("(.-)\n") do
		fn.append(lineno, line)
		lineno = lineno + 1
	end
end

-- Updates if header is already present on the file
header.update = function(ft_config)
	-- Check if filetype is supported
	if config.ft[bo.filetype] == nil then
		return false
	end
	-- Check if file was modified
	if bo.mod then
		return true
	end
	local user = ft_config.user or config.user
	-- Searches for the "Updated by" line of the header
	local found = fn.getline(9):find(
		ft_config.start_comment .. string.rep(" ", constants.margin - #ft_config.start_comment) .. "Updated: "
	)
	if found then
		local filename = fn.expand("%:t")
		local SPACES_AFTER_FILENAME = constants.length - (2 * constants.margin) - string.len(filename) - 19
		local SPACES_AFTER_UPDATED = constants.length - (2 * constants.margin) - string.len(user) - 53
		-- Sets the filename line(useful for when renaming files)
		fn.setline(
			4,
			string.format(
				"%2s   %s%s:+:      :+:    :+:   %2s",
				ft_config.start_comment,
				filename,
				string.rep(" ", SPACES_AFTER_FILENAME),
				ft_config.end_comment
			)
		)
		-- Sets the "Updated by" line of the header
		fn.setline(
			9,
			string.format(
				"%2s   Updated: %19s by %s%s###   ########.fr       %2s",
				ft_config.start_comment,
				fn.strftime("%Y/%m/%d %H:%M:%S"),
				user,
				string.rep(" ", SPACES_AFTER_UPDATED),
				ft_config.end_comment
			)
		)
		return true
	end
	return false
end

return header
