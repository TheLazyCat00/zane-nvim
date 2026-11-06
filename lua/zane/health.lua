-- :checkhealth zane
local M = {}

function M.check()
  local health = vim.health
  health.start("zane")

  if vim.fn.has("nvim-0.11") == 1 then
    health.ok("Neovim 0.11 or newer")
  else
    health.error("Neovim 0.11 or newer is required")
  end

  if pcall(require, "nvim-treesitter.config") then
    health.ok("nvim-treesitter (main branch) installs the parser")
  else
    health.error("nvim-treesitter (main branch) not found", { "It downloads, builds and installs the Zane parser." })
  end

  for _, tool in ipairs({ "tree-sitter", "curl", "tar" }) do
    local path = vim.fn.exepath(tool)
    if path ~= "" then
      health.ok(tool .. ": " .. path)
    else
      health.warn(tool .. " not on PATH", { "nvim-treesitter needs it to install the Zane parser." })
    end
  end

  local ok, loaded = pcall(vim.treesitter.language.add, "zane")
  if not ok or not loaded then
    health.error("no Zane parser installed", { "Open a .zn file, or run :TSInstall zane." })
    return
  end
  health.ok("Zane parser loads")

  local found, query = pcall(vim.treesitter.query.get, "zane", "highlights")
  if found and query then
    health.ok("highlight queries load")
  else
    health.error("highlight queries do not load: " .. tostring(query), {
      "The parser and queries may come from different compiler versions. Run :TSUpdate zane.",
    })
  end
end

return M
