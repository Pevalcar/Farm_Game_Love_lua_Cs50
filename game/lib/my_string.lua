local MyString = {}

function MyString.UpperCaseFirst(str)
    local firt_word = string.upper(string.sub(str, 1, -#str))
    local rest_word = string.sub(str, 2, #str)
    return firt_word .. rest_word

end

return MyString
