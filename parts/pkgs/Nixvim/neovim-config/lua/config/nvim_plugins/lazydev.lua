return {
	"folke/lazydev.nvim",
	name = "lazydev.nvim",
	cmd = "LazyDev",
	ft = "lua",
	opts = {
		library = {
			{ path = "snacks.nvim", word = { "Snacks" } },
			{ path = "noice.nvim", word = { "noice" } },
		},
	},
}
