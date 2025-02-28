vim.api.nvim_create_user_command('RunMatlab', function(opts)
  -- get passed in filename
  local filename = opts.args

  -- if no filename assume current buffer
  if filename == "" then
    local current_file = vim.fn.expand('%:t:r')
    if vim.fn.expand('%:e') ~= "m" then
      print("Current file is not a matlab script")
    end
    filename = current_file
  end

  -- run matlab if any output data to the stdout/stderr print it
  local cmd = string.format("matlab -nosplash -nodesktop -batch '%s'", filename)

  -- create buffer
  local buf_name = "MATLAB Output"
  vim.cmd.vnew(buf_name)

  -- get buffer id and set properties
  local buf = vim.fn.bufnr('%')
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf });
  vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf });
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf });

  -- clear buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  vim.fn.jobstart(cmd, {
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data)
      if data and #data > 0 then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end
  })
end, { nargs = "?" })

vim.api.nvim_create_user_command('RunMatlabTest', function(opts)
  -- get passed in filename
  local filename = opts.args

  -- if no filename assume current buffer
  if filename == "" then
    local current_file = vim.fn.expand('%:t:r')
    if vim.fn.expand('%:e') ~= "m" then
      print("Current file is not a matlab script")
    end
    filename = current_file
  end

  -- run matlab if any output data to the stdout/stderr print it
  local cmd = string.format("matlab -nosplash -nodesktop -batch runtests('%s')", filename)

  -- create buffer
  local buf_name = "MATLAB Test Output"
  vim.cmd.vnew(buf_name)

  -- get buffer id and set properties
  local buf = vim.fn.bufnr('%')
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf });
  vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf });
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf });

  -- clear buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  vim.fn.jobstart(cmd, {
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data)
      if data and #data > 0 then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end
  })
end, { nargs = "?" })
