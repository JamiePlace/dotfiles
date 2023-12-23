function on_mac()
    local val = package.config:sub(1,1)
    if val == "/" then
        return true
    end
    return false
end
