local NavigationBar = {}

function NavigationBar.render(data)
  local linksHTML = ""
  for _, link in ipairs(data.links) do
    linksHTML = linksHTML .. string.format("<li><a href='%s'>%s</a></li>", link.url, link.text)
  end
  return string.format(
    [[<nav>
        <ul>
          %s
        </ul>
      </nav>
    ]], linksHTML)
end

return NavigationBar
