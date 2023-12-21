vim.cmd([[ let g:neotree_remove_legacy_commands = 1 ]])
vim.keymap.set('n',
    "<leader>bR",
    function()
        require("neo-tree.command").execute({
            toggle = true,
            source = "buffers",
            position = "left",
        })
    end,
    { desc = "Buffers (root dir)" }
)

return {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require('neo-tree').setup(
            {
                filesystem = {
                    filtered_items = {
                        visible = true,
                    },
                    window = {
                        mappings = {
                            ["o"] = "exp_open",
                            ["<C-o>"] = "system_open"
                        },
                    },
                    commands = {
                        exp_open = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            local f = io.open(path)
                            if f:read(0) and f:seed('end') ~= 0 then
                                path = path .. '/..'
                            end
                            vim.fn.jobstart({ "xdg-open", path }, { detach = true })
                        end,
                        system_open = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.fn.jobstart({ "xdg-open", path }, { detach = true })
                        end,
                    },
                },
                event_handlers = {
                    {
                        event = "neo_tree_window_after_open",
                        handler = function(args)
                            if args.position == "left" or args.position == "right" then
                                vim.cmd("wincmd =")
                            end
                        end
                    },
                    {
                        event = "neo_tree_window_after_close",
                        handler = function(args)
                            if args.position == "left" or args.position == "right" then
                                vim.cmd("wincmd =")
                            end
                        end
                    }
                }
            }
        )
    end,
}
