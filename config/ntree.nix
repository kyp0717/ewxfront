{ pkgs, ... }: {

  plugins.nvim-tree = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>up";
      action = "<cmd>NvimTreeToggle<CR>";
      options.desc = "ntree toggle";
    }
    {
      mode = "n";
      key = "<leader>uf";
      action = "<cmd>NvimTreeFindFile<CR>";
      options.desc = "ntree find file";
    }
  ];

  extraPlugins = with pkgs.vimPlugins; [
    nvim-web-devicons
  ];
}
