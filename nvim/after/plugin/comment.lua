local comment_status, comment = pcall(require, "Comment")
if not comment_status then
    vim.notify("Comment not found!")
    return
end

comment.setup {
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  }