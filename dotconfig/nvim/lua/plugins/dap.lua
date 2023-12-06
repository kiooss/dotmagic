return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<F9>",
        function()
          require("dap").step_out()
        end,
        desc = "Step Over",
      },
    },
  },
}
