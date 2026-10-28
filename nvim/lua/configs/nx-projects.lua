-- Jump to an nx project in nvim-tree: pick a project, then reveal it with the
-- tree kept at the workspace root and everything else collapsed.

-- Scanned one level deep when the workspace has no project.json files
local FALLBACK_DIRS = { "apps", "libs", "packages", "infra" }

local function workspace_root()
  local cwd = vim.fn.getcwd()
  return vim.fs.root(cwd, { "nx.json", ".git" }) or cwd
end

local function fallback_projects(root)
  local projects = {}
  for _, parent in ipairs(FALLBACK_DIRS) do
    for name, kind in vim.fs.dir(root .. "/" .. parent) do
      if kind == "directory" then
        table.insert(projects, parent .. "/" .. name)
      end
    end
  end
  return projects
end

-- Calls cb with a sorted list of project paths relative to root
local function discover(root, cb)
  vim.system(
    { "git", "ls-files", "--cached", "--others", "--exclude-standard", "--", "*project.json" },
    { text = true, cwd = root },
    function(obj)
      local seen, projects = {}, {}
      if obj.code == 0 then
        for path in obj.stdout:gmatch "[^\n]+" do
          local dir = vim.fs.dirname(path)
          if vim.fs.basename(path) == "project.json" and dir ~= "." and not seen[dir] then
            seen[dir] = true
            table.insert(projects, dir)
          end
        end
      end
      vim.schedule(function()
        if #projects == 0 then
          projects = fallback_projects(root)
        end
        table.sort(projects)
        cb(projects)
      end)
    end
  )
end

local function reveal(root, rel)
  local api = require "nvim-tree.api"
  if not api.tree.is_visible() then
    api.tree.open()
  end
  local tree_root = api.tree.get_nodes().absolute_path
  if vim.uv.fs_realpath(tree_root) ~= vim.uv.fs_realpath(root) then
    api.tree.change_root(root)
    tree_root = api.tree.get_nodes().absolute_path
  end
  api.tree.collapse_all()
  -- Build from the tree's own root so /tmp vs /private/tmp can't cause a mismatch
  api.tree.find_file { buf = tree_root .. "/" .. rel, open = true, focus = true }
  local node = api.tree.get_node_under_cursor()
  if node and node.type == "directory" and not node.open then
    api.node.open.edit(node)
  end
end

local function pick()
  local root = workspace_root()
  discover(root, function(projects)
    if #projects == 0 then
      vim.notify("No nx projects found under " .. root, vim.log.levels.WARN)
      return
    end
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    pickers
      .new({}, {
        prompt_title = "nx Projects",
        finder = finders.new_table { results = projects },
        sorter = conf.generic_sorter {},
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local sel = action_state.get_selected_entry()
            if sel then
              reveal(root, sel[1])
            end
          end)
          return true
        end,
      })
      :find()
  end)
end

return { pick = pick }
