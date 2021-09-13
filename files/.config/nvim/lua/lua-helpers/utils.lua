local cmd = vim.cmd
local lspServers = {
  "bash", "css", "dockerfile", "efm", "ember", "html", "json", "lua", "tailwindcss", "typescript", "vim", "yaml"
}

UpdateLspServers = function()
  for _, server in pairs(lspServers) do
    require'lspinstall'.install_server(server)
  end
end

return {
  UpdateLspServers = UpdateLspServers,
  lspServers = lspServers
}
