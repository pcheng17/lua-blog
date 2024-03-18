local M = {}

function M.render(link)
  return string.format("<a href='%s' class='nav-link'>%s</a>", link.url, link.text)
end

return M
