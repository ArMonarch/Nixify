return {
	"folke/which-key.nvim",
	name = "which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec" },
	opts = {
		preset = "helix",
		default = {},
		spec = {
			{
				mode = { "n", "v" },
				{ "<leader><tab>", group = "tabs" },
				{ "<leader><leader>", icon = { icon = " " } },
				{ "<leader>:", icon = { icon = " " } },
				{ "<leader>/", icon = { icon = " " } },
				{ "<leader>e", icon = { icon = " " } },
				{ "<leader>E", icon = { icon = " " } },
				{ "<leader>c", group = "code" },
				{ "<leader>d", group = "debug" },
				{ "<leader>dp", group = "profiler" },
				{ "<leader>f", group = "file/find/fold" },
				{ "<leader>g", group = "git" },
				{ "<leader>gh", group = "hunks" },
				{ "<leader>n", group = "notification" },
				{ "<leader>s", group = "search" },
				{ "<leader>q", group = "quit/session" },
				{ "<leader>t", group = "terminal" },
				{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
				{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
				{ "gs", group = "surround" },
				{
					"<leader>b",
					group = "buffer",
					icon = { icon = " " },
					expand = function()
						return require("which-key.extras").expand.buf()
					end,
				},
				{
					"<leader>w",
					group = "windows",
					proxy = "<c-w>",
					expand = function()
						return require("which-key.extras").expand.win()
					end,
				},
				-- better descriptions
				{ "gx", desc = "Open with system app" },
			},
		},
	},
}
