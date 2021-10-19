local Job = require('plenary.job')
local notify = require('notify')

Job
  :new({
    command = 'ansiweather',
    args = { '-l Suzhou,CN', '-a false' },
    -- cwd = '~',
    -- env = { ['a'] = 'b' },
    on_exit = function(j, return_val)
      if return_val == 0 then
        notify(j:result(), 'info', {
          title = '今日の天気',
          icon = '摒',
        })
      end
      -- dump(j:result())
    end,
  })
  :sync() -- or start()
