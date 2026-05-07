local function nasm_indent(lnum)
  local line = vim.fn.getline(lnum)

  -- blank line
  if line:match("^%s*$") then return 0 end

  -- label (with or without trailing instruction)
  if line:match("^%s*[%w_.?@$][%w_.?@$]*:") then return 0 end

  -- section-level directives
  if line:match("^%s*section%s")
    or line:match("^%s*global%s")
    or line:match("^%s*extern%s")
    or line:match("^%s*bits%s")
    or line:match("^%s*default%s")
    or line:match("^%s*struc%s")
    or line:match("^%s*endstruc%b")
    or line:match("^%s*%%")        -- NASM macros (%define, %macro, etc.)
  then
    return 0
  end

  -- everything else: instructions, operands, inline comments
  return vim.bo.shiftwidth
end

vim.bo.indentexpr = "v:lua.require'indent.asm'.indent(v:lnum)"

return { indent = nasm_indent }
