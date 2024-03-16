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
    -- TODO What should I do about uppercase/lowercase?
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


local path = "./content" -- Specify the directory path
local files, err = pc.get_markdown_files(path)

if not files then
    print("Error:", err)
else
  for _, file in ipairs(files) do
    print("Processing " .. file)
    -- Something like the following:
    -- local markdown = utils.read_file("posts/" .. file)
    -- local html = markdown_to_html(markdown)
    -- write_file("public/" .. file:gsub("%.md$", ".html"), html)
  end
end

sw.start()

local data = {
  page_title = "Welcome to my blog!",
  content = "Hello, world!",
}
utils.merge_tables(data, config)

local html_content = render_template("./templates/base.html", data)
utils.write_file("public/index.html", html_content)

local dt = sw.elapsed_milliseconds()
print("🚀 Built the blog in " .. dt .. " ms - ready to deploy!")


