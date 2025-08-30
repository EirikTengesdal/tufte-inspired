-- see https://github.com/quarto-dev/quarto-cli/discussions/10440
function Cite(cite)
  local citation = cite.citations[1]
  
  -- Deconstruct the citation object
  local key = citation.id
  local mode = citation.mode or "NormalCitation"
  local prefix = citation.prefix and pandoc.utils.stringify(citation.prefix) or "none"
  local suffix = citation.suffix and pandoc.utils.stringify(citation.suffix) or "none"
  local locator = citation.locator or "none"
  local label = citation.label or "none"
  
  
  -- Check whether the label contains the prefix `fig-`
  if string.sub(key, 1, 4) == "fig-" then
    print(cite)
    return cite
  end
  
  -- Create a Typst function call with deconstructed parts
  local typst_call = string.format(
    '#sidecite(<%s>, "%s", "%s", "%s", %s, %s)',
    key, mode, prefix, suffix, locator, label
  )

  return pandoc.Inlines({
    pandoc.RawInline('typst', typst_call)
  })
end

-- -- inspired by: https://github.com/quarto-ext/typst-templates  ams/_extensions/ams/ams.lua
local function endTypstBlock(blocks)
    local lastBlock = blocks[#blocks]
    if lastBlock.t == "Para" or lastBlock.t == "Plain" then
      lastBlock.content:insert(pandoc.RawInline('typst', ' #set text(font: serif-fonts, size: 12pt); ]'))
      return blocks
    else
      blocks:insert(pandoc.RawBlock('typst', ']; #set text(font: serif-fonts, size: 12pt); '))
      return blocks
    end
  end
  
  
  function Div(el)
-- -- Debug: Print the attributes of the element
--   --print(el)
--   --print(pandoc.write(pandoc.Pandoc({el}), 'json'))
--     -- ::{.column-margin}
--     if el.classes:includes('column-margin') then
--       local dy = el.attributes.dy or "2cm"
      
--       -- Function to extract caption text from the element
--       local function extractCaption(blocks)
--         for _, block in ipairs(blocks) do
--           if block.t == "Div" then
--             return pandoc.utils.stringify(block)
--           end
--         end
--       end

--       local caption = extractCaption(el.content)
--       -- print("Final caption: " .. caption)  -- Debugging line to verify if caption is correctly extracted
      
--       local figpath = "Images/et_midjourney_transparent.png"
      
--       -- Create the Typst function call with the new mechanism
--       local typst_call = string.format(
--         '#sidenote(dy: %s, padding: (left: 1.5em, right: 4.5em), box[#figure(image("%s"), caption: ["%s"])])',
--         dy, figpath, caption
--       )
      
--       local blocks = pandoc.List({
--         pandoc.RawBlock('typst', typst_call)
--       })
--       blocks:extend(el.content)
--       return blocks
--     end
  
    -- ::{.fullwidth}
    if el.classes:includes('fullwidth') then
      local dx = el.attributes.dx or "0pt"
      local dy = el.attributes.dy or "0pt"
      local width = "100%+75.2mm"
      --local width = "100%+3.5in-0.75in"
      local blocks = pandoc.List({
        pandoc.RawBlock('typst', string.format('#set text(font: serif-fonts, size: marginfontsize); #block(width: %s)[', width))
      })
      blocks:extend(el.content)
      return endTypstBlock(blocks)
    end
    
    -- ::{.column-page-right}
    if el.classes:includes('column-page-right') then
      local dx = el.attributes.dx or "0pt"
      local dy = el.attributes.dy or "2em"
      local width = "100%+75.2mm"
      -- width is adapted for A4 format
      local blocks = pandoc.List({
        pandoc.RawBlock('typst', string.format('#block(width: %s)[', width))
      })
      blocks:extend(el.content)
      return endTypstBlock(blocks)
    end
  end

function Image(el)
  -- Custom handling for images
  local dy = el.attributes.dy or "0pt"
  local caption = pandoc.utils.stringify(el.caption)
  local src = el.src
  local typst_call = string.format('#sidenote(dy: %s, padding: (left: 1.5em, right: 4.5em))[#figure(image("%s"), caption: ["%s"])]', dy, src, caption)
  return pandoc.RawInline('typst', typst_call)
end
