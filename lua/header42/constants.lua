local values

values.ascii_art = {
			":::      ::::::::",
		  ":+:      :+:    :+:",
		"+:+ +:+         +:+  ",
	  "+#+  +:+       +#+     ",
	"+#+#+#+#+#+   +#+        ",
		 "#+#    #+#          ",
		 "###   ########.fr   ",
}

--- Makes constants read-only by using lua `setmetatable`
-- @param tbl Table with all contants values
local set_constants = function(tbl)
	return setmetatable({}, {
		_index = tbl,
		_newindex = function(_, _, _)
			error("[header42] Attempting to change constant value.")
		end,
	})
end

local constants = set_constants(values)

return constants
