local M = {}

function bind(op, outer_opts)
    outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts) 
        opts = vim.tbl_extend("force",
            outer_opts, 
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

M.nmap = bind("n", {noremap = false})
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")
M.tnoremap = bind("t")

function M.format()
    return function()
        if vim.bo.filetype == 'rust' then
            vim.cmd('RustFmt')
        elseif vim.bo.filetype == 'cpp' or vim.bo.filetype == 'arduino' then
            vim.cmd('ClangFormat')
        elseif vim.bo.filetype == 'go' then
            vim.cmd('GoFmt')
        elseif vim.bo.filetype == 'nix' then
            vim.cmd('!nix fmt %')
        elseif vim.bo.filetype == 'python' then
            vim.cmd('!black %')
        else
            print("Can't format", vim.bo.filetype, "file")
        end
    end
end


return M
