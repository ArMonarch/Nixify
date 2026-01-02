{
  inputs,
  pkgs,
  ...
}: let
  package-name = "neovim";
  # flag to set neovim transparent colorscheme
  neovim-transparent-theme = false;

  neovim-startPlugins = with pkgs.vimPlugins; [
    lazy-nvim
    plenary-nvim
  ];

  neovim-optPlugins = with pkgs.vimPlugins; [
    tokyonight-nvim
    catppuccin-nvim
    rose-pine

    blink-cmp
    conform-nvim
    gitsigns-nvim
    lazydev-nvim
    lualine-nvim
    noice-nvim
    nui-nvim # <- noice-nvim
    mini-icons
    mini-pairs
    nvim-treesitter
    plenary-nvim
    snacks-nvim
    smear-cursor-nvim
    todo-comments-nvim
    trouble-nvim
    which-key-nvim

    (pkgs.stdenvNoCC.mkDerivation {
      name = "lualine-pretty-path";
      src = pkgs.fetchFromGitHub {
        owner = "bwpge";
        repo = "lualine-pretty-path";
        rev = "852cb06f3562bced4776a924e56a9e44d0ce634f";
        hash = "sha256-Ieho+EruCPW4829+qQ3cdfc+wZQ2CFd16YtcTwUAnKg=";
      };
      phases = ["installPhase"];
      installPhase = "cp -r $src $out";
    })
  ];

  foldPlugins = builtins.foldl' (
    acc: next: acc ++ [next] ++ (foldPlugins (next.dependencies or []))
  ) [];

  neovim-treesitter-grammers = with pkgs.vimPlugins; [nvim-treesitter.withAllGrammars];

  neovim-packages = pkgs.runCommandLocal "neovim-packages" {} ''
    mkdir -p $out/pack/${package-name}/{start,opt}
    ln -vsfT ${./neovim-config} $out/pack/${package-name}/start/neovim-config

    # necessary packages should be loaded at start i.e. mainly plugins manager and its helper package
    ${pkgs.lib.concatMapStringsSep "\n" (
        plugin: "ln -vsfT ${plugin} $out/pack/${package-name}/start/${pkgs.lib.getName plugin}"
      )
      neovim-startPlugins}

    # load the treesitter parsers into one folder and append that folder to
    # vim runtimepath in the lua config as lazy.nvim resets runtimepath.
    mkdir -p $out/pack/${package-name}/opt/treesitter/parser
    ${pkgs.lib.concatMapStringsSep "\n" (plugin: ''
      for so in ${plugin}/parser/*.so; do
        ln -vsfT "$so" "$out/pack/${package-name}/opt/treesitter/parser/$(basename "$so")"
      done
    '') (pkgs.lib.unique (foldPlugins neovim-treesitter-grammers))}

    # load optional plugins which lazy.nvim will load automatically
    ${pkgs.lib.concatMapStringsSep "\n" (
        plugin: "ln -vsfT ${plugin} $out/pack/${package-name}/opt/${pkgs.lib.getName plugin}"
      )
      neovim-optPlugins}
  '';
in
  inputs.wrappers.lib.wrapPackage rec {
    inherit pkgs;
    package = pkgs.neovim-unwrapped;
    exePath = pkgs.lib.getExe package;
    binName = builtins.baseNameOf exePath;
    runtimeInputs = with pkgs; [
      # Packages that plugins depends on
      lazygit # <- snacks.nvim
      gh # <- snacks.nvim
      fd # <- snacks.nvim

      # LSP Servers Packages that are provided by default by this package
      basedpyright
      deno
      lua-language-server
      marksman
      nil
      nixd
      rust-analyzer
      texlab
      typescript-language-server
      zls

      # Formatters Packages
      alejandra
      prettierd
      stylua
      shfmt
      ruff
      rustfmt
    ];
    env = {
      "NVIM_APPNAME" = "neovim";
    };
    flags = {
      "-u" = "NORC";
      "--cmd" = ''
        set packpath^=${neovim-packages} |
        set runtimepath^=${neovim-packages} |
        let g:neovim_plugins='${neovim-packages}/pack/neovim/opt' |
        let g:neovim_treesitter_parsers='${neovim-packages}/pack/neovim/opt/treesitter' |
        let g:neovim_transparent_theme='${builtins.toString neovim-transparent-theme}'
      '';
    };
    flagSeparator = " ";
    passthru = {
      inherit neovim-packages;
    };
  }
