local nl = require("components.navigation_link")

local M = {}

function M.render(data)
  local linksHTML = ""
  for _, link in ipairs(data.links) do
    linksHTML = linksHTML .. nl.render(link)
  end
  return string.format(
    [[<nav>
        %s
      </nav>
    ]], linksHTML)
end

return M
