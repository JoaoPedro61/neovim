--- Checks whether a path is inside a Git repository.
---
--- @param path? string Directory to inspect. Defaults to the current working directory.
--- @return boolean is_repository `true` when a `.git` directory is found upwards.
local function in_repository(path)
  local current_dir = path or vim.fn.getcwd()
  local git_root = vim.fn.finddir(".git", current_dir .. ";")
  return git_root ~= ""
end

return in_repository
