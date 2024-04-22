vim.fs.joinpath = function(base_path, added_path)
    -- Check if the base path ends with a separator
    if string.sub(base_path, -1) ~= "/" then
        base_path = base_path .. "/"
    end

    -- Check if the added path starts with a separator and remove it
    if string.sub(added_path, 1, 1) == "/" then
        added_path = string.sub(added_path, 2)
    end

    -- Return the concatenated path
    return base_path .. added_path
end
