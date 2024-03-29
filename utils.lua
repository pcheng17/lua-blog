local M = {}

function M.write_file(path, content)
  -- Extract the directory path from the provided file path
  local dir = path:match("(.+)/")
  if dir then
    local mkdirCommand = string.format("mkdir -p %s", dir)
    os.execute(mkdirCommand)
  end

  local file = io.open(path, "w")
  if not file then
    print("Error: Could not open file " .. path)
    return false
  end
  file:write(content)
  file:close()
  return true
end

function M.read_file(path)
  local file = io.open(path, "r")
  if not file then return nil end
  local content = file:read("*all")
  file:close()
  return content
end

function M.print_content_structure(tbl)
  local function helper(t, indent)
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
      else
        print(indent .. "├─ " .. k)
      end
      if type(v) == "table" then
        local prefix = indent .. (i == #keys and "   " or "│  ")
        helper(v, prefix)
      end
    end
  end

  for k in pairs(tbl) do
    print(k)
    helper(tbl[k])
  end
end

function M.merge_arrays(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

function M.merge_tables(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" and type(t1[k]) == "table" then
      M.deepMerge(t1[k], v)
    else
      t1[k] = v
    end
  end
  return t1
end

return M
