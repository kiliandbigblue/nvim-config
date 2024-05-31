local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

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
			{ i(1, "param"), i(1), i(1) }
		)
	),
})
