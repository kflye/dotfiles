P = function(v)
    print(vim.inspect(v))
    return v
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string

get_pkg_path = function(pkg, path)
    pcall(require, 'mason')
    local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
    path = path or ''
    local ret = root .. '/packages/' .. pkg .. '/' .. path
    return ret
end
