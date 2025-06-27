-- fugitive
return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        -- git checkout by passing the branch name
        vim.keymap.set("n", "<leader>co", function ()
            local branch = vim.fn.input("ExistingBranch> ")
            if branch == nil or branch == "" then
                return
            end
            vim.cmd('Git checkout ' .. branch)
        end, {desc = "Git checkout branch"})
        -- git checkout a new branch
        vim.keymap.set("n", "<leader>cO", function ()
            local branch = vim.fn.input("NewBranch> ")
            if branch == nil or branch == "" then
                return
            end
            vim.cmd('Git checkout -b ' .. branch)
        end, {desc = "Git checkout new branch"})

        local Jamie_Fugitive = vim.api.nvim_create_augroup("Jamie_Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = Jamie_Fugitive,
            pattern = "*",
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()
                local opts = {buffer = bufnr, remap = false}
                vim.keymap.set("n", "<leader>gp", function()
                    vim.cmd.Git('push')
                end, opts)

                -- rebase always
                vim.keymap.set("n", "<leader>gP", function()
                    vim.cmd.Git({'pull',  '--rebase'})
                end, opts)

                -- add current file to git
                vim.keymap.set("n", "<leader>ss", function()
                    vim.cmd('Git add %')
                end, opts)

                -- commit current file
                vim.keymap.set("n", "<leader>cc", function()
                    local commit_msg = vim.fn.input("Commit message: ")
                    if commit_msg == nil or commit_msg == "" then
                        vim.notify("Commit message cannot be empty; exiting", vim.log.levels.WARN)
                        return
                    end
                    vim.cmd('Git commit -m "' .. commit_msg .. '"')
                end, opts)


                -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                -- needed if i did not set the branch up correctly
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
            end,
        })


        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    end
}
