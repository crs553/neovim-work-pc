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
  local cmd = string.format("matlab -nosplash -nodesktop -r '%s'", filename)
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        print(table.concat(data, "\n"))
      end
    end,
    on_stderr = function(_, data)
      if data then
        print(table.concat(data, "\n"))
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
  local cmd = string.format("matlab -nosplash -nodesktop -r runtests('%s')", filename)
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        print(table.concat(data, "\n"))
      end
    end,
    on_stderr = function(_, data)
      if data then
        print(table.concat(data, "\n"))
      end
    end
  })
end, { nargs = "?" })
vim.api.nvim_create_user_command('RunMatlab', function(opts)
  local filename = opts.args
  if filename == "" then
    local current_file = vim.fn.expand('%:t:r')
    if vim.fn.expand('%:e') ~= "m" then
      print("Current file is not a matlab script")
    end
    filename = current_file
  end

  local cmd = string.format("matlab -nosplash -nodesktop -r %s", filename)
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        print(table.concat(data, "\n"))
      end
    end,
    on_stderr = function(_, data)
      if data then
        print(table.concat(data, "\n"))
      end
    end
  })
end, { nargs = "?" })
