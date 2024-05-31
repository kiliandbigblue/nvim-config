local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local f = ls.function_node

local function replicate(args)
	return args[1]
end

-- Define the useEffect snippet
ls.add_snippets("typescriptreact", {
	s(
		"uel",
		fmt(
			[[
useEffect(() => {{
    console.log("{}", {})
}}, [{}])
]],
			{ i(1, "param"), f(replicate, { 1 }), f(replicate, { 1 }) }
		)
	),
})
