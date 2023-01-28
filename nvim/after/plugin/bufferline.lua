local bufferline_status, bufferline = pcall(require, "bufferline")
if not bufferline_status then
    vim.notify("bufferline not found!")
  return
end

bufferline.setup({
    options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
    },
    highlights = {
      
    }
})