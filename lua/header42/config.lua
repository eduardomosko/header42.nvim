-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   config.lua                                         :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/09/12 20:57:40 by vgoncalv          #+#    #+#             --
--   Updated: 2021/12/15 22:16:55 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

---@class Config User config defaults
---@field user string: default user
---@field mail string: default mail
---@field ft table: filetype configuration
local Config = {
	user = "marvin",
	mail = "marvin@42.fr",
	ft = {
		c = {
			start_comment = "/*",
			end_comment = "*/",
			fill_comment = "*",
		},
		cpp = {
			start_comment = "/*",
			end_comment = "*/",
			fill_comment = "*",
		},
		make = {
			start_comment = "##",
			end_comment = "##",
			fill_comment = "#",
		},
		python = {
			start_comment = "##",
			end_comment = "##",
			fill_comment = "#",
		},
		lua = {
			start_comment = "--",
			end_comment = "--",
			fill_comment = "-",
		},
		vim = {
			start_comment = '""',
			end_comment = '""',
			fill_comment = "*",
		},
	},
}

setmetatable(Config, {
	__call = function(cls, ...)
		return cls:new(...)
	end,
})

---@param opts table
function Config:set(opts)
	self.__index = self
	self.user = opts.user or "marvin"
	self.mail = opts.user or "42.fr"
	if opts.ft ~= nil then
		self.ft = vim.tbl_deep_extend("force", self.ft, opts.ft)
	end
	return self
end

return Config
