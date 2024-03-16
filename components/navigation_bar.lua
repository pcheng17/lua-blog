local M = {}

function M.render(data)
  local linksHTML = ""
  for _, link in ipairs(data.links) do
    linksHTML = linksHTML .. string.format("<a href='%s'>%s</a>", link.url, link.text)
  end
  return string.format(
    [[<nav>
        %s
      </nav>
    ]], linksHTML)
end

return M
