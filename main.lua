local pc = require("pcheng")
local sw = require("stopwatch")

sw.start()
local path = "./posts" -- Specify the directory path
local files, err = pc.get_markdown_files(path)

if not files then
    print("Error:", err)
else
  -- Process each Markdown file in the posts directory
  for _, file in ipairs(files) do
    -- local markdown = readFile("posts/" .. file)
    -- local html = markdownToHtml(markdown)
    -- writeFile("public/" .. file:gsub("%.md$", ".html"), html)
    print("Processing " .. file)
  end
end

local dt = sw.elapsed_milliseconds()
print("🚀 Built the blog in " .. dt .. " ms - ready to deploy!")


-- Function to read a file
-- local function readFile(path)
--   local file = io.open(path, "rb")
--   if not file then return nil end
--   local content = file:read("*all")
--   file:close()
--   return content
-- end

-- Function to write a file
-- local function writeFile(path, content)
--   local file = io.open(path, "w")
--   if not file then return false end
--   file:write(content)
--   file:close()
--   return true
-- end

-- Convert Markdown to HTML
-- local function markdownToHtml(content)
--   return content
-- end


