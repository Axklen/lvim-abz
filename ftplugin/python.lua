local path = require "mason-core.path"

local function get_python_path(workspace)
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end
  if vim.fn.filereadable(path.concat { workspace, "poetry.lock" }) then
    local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
    return path.concat { venv, "bin", "python" }
  end
  return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

local opts = {
  on_init = function(client)
    client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
  end,
  before_init = function(_, config)
    config.settings.python.analysis.stubPath = path.concat {
      vim.fn.stdpath "data",
      "site",
      "pack",
      "packer",
      "opt",
      "python-type-stubs",
    }
  end,
}

require("lvim.lsp.manager").setup("pylance", opts)
