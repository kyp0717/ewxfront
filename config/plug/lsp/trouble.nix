{
  plugins.trouble = {
    enable = true;
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>ct";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options = {
        silent = true;
        desc = "Trouble Toggle";
      };
    }
  ];
}
