-- snip_env = {
-- 	s = require("luasnip.nodes.snippet").S,
-- 	sn = require("luasnip.nodes.snippet").SN,
-- 	t = require("luasnip.nodes.textNode").T,
-- 	f = require("luasnip.nodes.functionNode").F,
-- 	i = require("luasnip.nodes.insertNode").I,
-- 	c = require("luasnip.nodes.choiceNode").C,
-- 	d = require("luasnip.nodes.dynamicNode").D,
-- 	r = require("luasnip.nodes.restoreNode").R,
-- 	l = require("luasnip.extras").lambda,
-- 	rep = require("luasnip.extras").rep,
-- 	p = require("luasnip.extras").partial,
-- 	m = require("luasnip.extras").match,
-- 	n = require("luasnip.extras").nonempty,
-- 	dl = require("luasnip.extras").dynamic_lambda,
-- 	fmt = require("luasnip.extras.fmt").fmt,
-- 	fmta = require("luasnip.extras.fmt").fmta,
-- 	conds = require("luasnip.extras.expand_conditions"),
-- 	types = require("luasnip.util.types"),
-- 	events = require("luasnip.util.events"),
-- 	parse = require("luasnip.util.parser").parse_snippet,
-- 	ai = require("luasnip.nodes.absolute_indexer"),
-- },

return {
  parse(
    'expcsv',
    [[
BOM_UTF8 = "\xEF\xBB\xBF".freeze
file = "#{Rails.root}/tmp/$1.csv"
headers = %w($2)
CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
  $3.find_each do |obj|
    writer << headers.map { |h| obj.send(h) }
  end
end
    ]]
  ),
}
