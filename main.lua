local pc = require("pcheng")
local sw = require("stopwatch")
local utils = require("utils")
local config = require("config")

local function render_component(name, data)
  local component = require("components." .. name)
  return component.render(data)
end

local function render_template(template_path, data)
  local content = utils.read_file(template_path)
  if not content then return nil end

  -- Replace component placeholders with rendered components
  content = content:gsub("{{@([%w_]+)@}}", function(component)
    return render_component(component, data[component] or {})
  end)

  -- Replace data placeholders with values
  for key, value in pairs(data) do
    content = content:gsub("{{" .. key .. "}}", value)
  end

  -- Remove any unreplaced placeholders
  content = content:gsub("{{[%w_]+}}", "")

  return content
end

local function build(tbl)
  local function helper(t, parent, indent)
    indent = indent or ""
    local keys = {}
    for k in pairs(t) do
      keys[#keys + 1] = k
    end
    table.sort(keys) -- Sort keys to maintain order

    for i, k in ipairs(keys) do
      local v = t[k]
      if i == #keys then
        print(indent .. "└─ " .. k)
        -- Build single page for `parent .. k`
      else
        print(indent .. "├─ " .. k)
        -- Build single page for `parent .. k`
      end
      if type(v) == "table" then
        local prefix = indent .. (i == #keys and "   " or "│  ")
        helper(v, parent .. k, prefix)
        -- Build listing page for `parent .. k`
      end
    end
  end

  for k in pairs(tbl) do
    print("/")
    helper(tbl[k], "/", nil)
  end
end





sw.start()

local path = "content/" -- Specify the directory path
local files = pc.get_markdown_files(path)

-- utils.print_content_structure(files)

local data = {
  page_title = "Welcome to my blog!",
  markdown_file = nil,
}
utils.merge_tables(data, config)

build(files)

-- for _, file in ipairs(files) do
--   local full_path = path .. "/" .. file
--   data.post = {}
--   data.post.markdown_file = full_path
--   local html_content = render_template("./templates/post.html", data)
--   local tmp = file:gsub("%.md$", "")
--   local dst = "public/" .. tmp .. ".html"
--   print("Writing " .. dst)
--   utils.write_file(dst, html_content)
-- end

local dt = sw.elapsed_milliseconds()
print("🚀 Built the blog in " .. dt .. " ms - ready to deploy!")


