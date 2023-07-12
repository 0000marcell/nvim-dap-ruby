local M = {}

local function load_module(module_name)
  local ok, module = pcall(require, module_name)
  assert(ok, string.format('dap-ruby dependency error: %s not installed', module_name))
  return module
end

local function setup_ruby_adapter(dap)
  dap.adapters.ruby = function(callback, config)
    local script
    if config.current_line then
      script = config.script .. ':' .. vim.fn.line(".")
    else
      script = config.script
    end

    callback {
      type = "server",
      host = "127.0.0.1",
      port = "${port}",
      executable = {
        command = "rdbg",
        args = { "--open", "--port", "${port}", "-n", "-c", "--", config.command , script },
      },
    }
  end
end

local function setup_ruby_configuration(dap)
  dap.configurations.ruby = {
    {
       type = 'ruby',
       name = 'debug current file',
       command = "ruby",
       request = "attach",
       script = "${file}",
       options = {
         source_filetype = 'ruby',
       };
       localfs = true,
    },
    {
       type = 'ruby';
       name = 'run rspec current file';
       request = 'attach';
       command = "bin/rspec";
       script = "${file}";
       options = {
         source_filetype = 'ruby';
       };
       localfs = true;
    },
    {
       type = 'ruby';
       name = 'run rspec current_file:current_line';
       bundle = 'bundle';
       request = 'attach';
       command = "bin/rspec";
       script = "${file}";
       port = 38698;
       server = '127.0.0.1';
       options = {
         source_filetype = 'ruby';
       };
       localfs = true;
       waiting = 1000;
       current_line = true;
    }
  }
end

function M.setup()
  local dap = load_module("dap")
  setup_ruby_adapter(dap)
  setup_ruby_configuration(dap)
end

return M
