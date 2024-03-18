local M = {}

function M.render(data)
  return string.format("<a href='%s' class='nav-link'>%s</a>", data.url, data.text)
end

return M
