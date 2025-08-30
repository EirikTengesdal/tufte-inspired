-- wrap-wideblock.lua
function Div(el)
  if el.classes:includes('wideblock') then
    -- Wrap the content in #wideblock
    local wideblock_start = pandoc.RawBlock('typst', '#wideblock[')
    local wideblock_end = pandoc.RawBlock('typst', ']')
    table.insert(el.content, 1, wideblock_start)
    table.insert(el.content, wideblock_end)
    return el
  end
end