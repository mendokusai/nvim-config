return {
  "preservim/nerdcommenter",
  init = function()
    vim.g.NERDSpaceDelims = 1 -- Add a space after comment delimiters
    vim.g.NERDDefaultAlign = "left"
    vim.g.NERDCommentEmptyLines = 1
    vim.g.NERDTrimTrailingWhitespace = 1
  end,
}
