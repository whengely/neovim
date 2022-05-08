local M = {}

M.createBranch = function()
    local prompt = "Enter Branch Name: "
    vim.ui.input({prompt = prompt}, function(input)
        if input ~= nil then vim.cmd("!git ticket " .. input) end
    end)
end

return M
