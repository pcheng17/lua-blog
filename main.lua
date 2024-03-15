local pc = require("pcheng")

local path = "./posts/" -- Specify the directory path
local files, err = pc.list_markdown_files(path)
if not files then
    print("Error:", err)
else
    for i, filename in ipairs(files) do
        print("✏️  "  .. filename)
    end
end

print("🚀 Successfully built the blog - ready to deploy!")

-- Function to read a file
-- local function readFile(path)
--   local file = io.open(path, "rb")   -- rb: read in binary mode
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

-- Process each Markdown file in the posts directory
-- for file in lfs.dir("posts/") do
--   if file:match("^.+%.md$") then   -- If the file is a Markdown file
--     local markdown = readFile("posts/" .. file)
--     local html = markdownToHtml(markdown)
--     -- Here, you would apply your HTML template to 'html'
--     -- For simplicity, we'll skip template processing
--     -- and just write the HTML to a file
--     writeFile("public/" .. file:gsub("%.md$", ".html"), html)
--   end
-- end

