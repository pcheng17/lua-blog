local utils = require("utils")

local M = {}

local function parse_front_matter(front_matter)
  local metadata = {}
  for key, value in front_matter:gmatch("([%w_]+):%s*([^\n]+)") do
    -- Trim potential trailing spaces in value
    value = value:match("^%s*(.-)%s*$")
    metadata[key] = value
  end
  return metadata
end

local function split_front_matter(content)
  -- Pattern to match the front matter. It captures everything between the first set of triple dashes.
  local pattern = "^---[ \t]*\n(.-)\n[ \t]*---[ \t]*\n?"

  -- Extract front matter and the start & end positions of the match
  local front_matter, endPos = content:match(pattern .. "()")

  -- If front matter is found, extract the body starting from the end position of the front matter
  local body = ""
  if front_matter then
    front_matter = parse_front_matter(front_matter)
    body = content:sub(endPos + 4)
  else
    body = content
  end

  return front_matter, body
end

M.render = function(data)
  if not data.markdown_file then
    print("Error: No markdown file specified")
    return nil
  end
  local content = utils.read_file(data.markdown_file)
  local front_matter, body = split_front_matter(content)
  return string.format(
    [[<article>
        <h1>%s</h1>
        <p>%s</p>
      </article>
    ]], front_matter.title, body
  )
end

return M
