###################################################
# Zed Editor configuration for NixOs
###################################################
{
  lib,
  pkgs,
  config,
  username,
  ...
}: let
  cfg = config.nixify.aspect.programs.zed;

  json = pkgs.formats.json {};

  # Spawned from keymap.json, which passes `reveal_target = "center"` so the
  # task takes over the editor pane instead of the terminal dock. Finding and
  # grepping are zed's own pickers, so lazygit is the only thing left that
  # actually wants a terminal. It comes from the host package set.
  tasks = [
    {
      label = "lazygit";
      command = "lazygit";
      hide = "always";
      allow_concurrent_runs = false;
      use_new_terminal = true;
    }
  ];
in {
  options.nixify.aspect.programs.zed = {
    systemWide = lib.options.mkOption {
      type = lib.types.bool;
      default = false;
      description = "install the zed editor system wide instead as user package";
    };

    package = lib.options.mkPackageOption pkgs "zed-editor" {};

    settings = lib.options.mkOption {
      inherit (json) type;
      default = {};
      description = "configuration for zed that will be written to {file} `$XDG_CONFIG_HOME/zed/settings.json`";
    };

    keymap = lib.options.mkOption {
      inherit (json) type;
      default = [];
      description = "key bindings for zed that will be written to {file} `$XDG_CONFIG_HOME/zed/keymap.json`";
    };
  };

  config = lib.mkMerge [
    (
      lib.modules.mkIf (cfg.systemWide) {
        environment.systemPackages = [cfg.package];
      }
    )

    (
      lib.modules.mkIf (!cfg.systemWide) {
        users.users.${username}.packages = [cfg.package];
      }
    )

    {
      fonts.packages = [pkgs.nerd-fonts.iosevka];
    }

    # defines the default configuration for the zed editor
    {
      nixify.aspect.programs.zed.settings = {
        ###############################################################
        # Appearance
        ###############################################################
        theme = "Maple Dark";
        icon_theme = "Zed (Default)";

        buffer_font_family = "Iosevka Nerd Font Mono";
        buffer_font_size = 16.0;
        buffer_line_height = "comfortable";
        ui_font_size = 16.0;

        ###############################################################
        # Editing
        ###############################################################
        autosave = "off";
        hard_tabs = false;
        tab_size = 2;
        relative_line_numbers = "enabled";
        show_whitespaces = "none";
        cli_default_open_behavior = "new_window";

        vim_mode = true;
        base_keymap = "Atom";

        # which-key, the leader groups above are useless without the hint
        # popup. 1000ms is the upstream default, which is a long wait when
        # you already know the chord
        which_key = {
          enabled = true;
          delay_ms = 300;
        };

        # no model ever gets to see this editor
        disable_ai = true;
        show_edit_predictions = false;

        ###############################################################
        # Language servers
        ###############################################################
        enable_language_server = true;
        inlay_hints.enabled = true;

        # Formatting. zed already formats on save by default, but under the
        # default `formatter = "auto"` it reaches for prettier whenever a
        # project carries one and only falls back to the server. Every
        # language below is served by an lsp, so the server is the formatter,
        # and anything that needs something else says so in `languages`.
        format_on_save = "on";
        formatter = "language_server";
        remove_trailing_whitespace_on_save = true;
        ensure_final_newline_on_save = false;

        # Pin every server to the system binary. Zed already prefers one found
        # on $PATH, but a server it downloaded itself would not run on nixos,
        # so this states the contract: servers come from the flake, never from
        # a runtime fetch.
        lsp = {
          # shipped with zed
          rust-analyzer.binary.ignore_system_version = false;
          clangd.binary.ignore_system_version = false;
          gopls.binary.ignore_system_version = false;
          json-language-server.binary.ignore_system_version = false;
          package-version-server.binary.ignore_system_version = false;
          yaml-language-server.binary.ignore_system_version = false;
          vscode-css-language-server.binary.ignore_system_version = false;
          tailwindcss-language-server.binary.ignore_system_version = false;
          vtsls.binary.ignore_system_version = false;
          typescript-language-server.binary.ignore_system_version = false;
          eslint.binary.ignore_system_version = false;
          basedpyright.binary.ignore_system_version = false;
          pyright.binary.ignore_system_version = false;
          pylsp.binary.ignore_system_version = false;
          ruff.binary.ignore_system_version = false;
          ty.binary.ignore_system_version = false;

          # contributed by the extensions below
          vscode-html-language-server.binary.ignore_system_version = false;
          ols.binary.ignore_system_version = false;
          slangd.binary.ignore_system_version = false;
        };

        languages = {
          # clangd is intentionally disabled, the projects here use their own
          # tooling and the bundled server fights with it. No server means no
          # formatter either, so save has to leave these buffers alone rather
          # than complain on every write.
          "C++" = {
            enable_language_server = false;
            completions.lsp = false;
            format_on_save = "off";
          };
          "C" = {
            enable_language_server = false;
            completions.lsp = false;
            format_on_save = "off";
          };
        };

        # Grammars for the languages zed does not bundle. Rust, C, C++, JSON,
        # JS/TS and YAML are built in and need no entry here, and TOML is a
        # grammar only extension, it carries no language server.
        auto_install_extensions = {
          html = true;
          odin = true;
          slang = true;
          toml = true;
        };

        ###############################################################
        # Panels, every dock lives on the right hand side
        ###############################################################
        agent.dock = "right";
        collaboration_panel.dock = "right";
        git_panel.dock = "right";
        outline_panel.dock = "right";

        project_panel = {
          dock = "right";
          git_status = true;
          file_icons = true;
          hide_gitignore = false;
        };

        ###############################################################
        # Window chrome
        ###############################################################
        tab_bar.show = true;
        tabs = {
          file_icons = false;
          git_status = true;
        };

        title_bar = {
          show_menus = false;
          show_user_picture = true;
          show_user_menu = true;
          show_sign_in = false;
          show_onboarding_banner = true;
          show_project_items = true;
          show_branch_name = true;
        };

        ###############################################################
        # Tooling
        ###############################################################
        git = {
          branch_picker.show_author_name = true;
          inline_blame.padding = 8;
        };

        terminal.shell.program = "fish";

        debugger.save_breakpoints = false;
        session.trust_all_worktrees = false;
      };
    }

    # defines the default key bindings for the zed editor
    {
      nixify.aspect.programs.zed.keymap = [
        # Leader groups follow the nvim config in ../NixVim so the muscle
        # memory carries over. Anything vim.json already binds the same way,
        # `gd` `gr` `K` `]d` `[d` `shift-h` `shift-l` and friends, is left to
        # the base keymap rather than repeated here.
        {
          context = "vim_mode == normal";
          bindings = {
            # zed's own pickers throughout. the file finder is already fuzzy
            # and opens without a terminal in the way, and `DeploySearch` is
            # the project wide grep, it lands its hits in a multibuffer
            "space space" = "file_finder::Toggle";
            "space f f" = "file_finder::Toggle";

            # grep, on both the nvim spellings
            "space /" = "pane::DeploySearch";
            "space f g" = "pane::DeploySearch";

            "space f b" = "tab_switcher::Toggle";
            "space f r" = "projects::OpenRecent";
            "space f s" = "outline::Toggle";
            "space f w" = "project_symbols::Toggle";
            "space f d" = "diagnostics::Deploy";
            "space f c" = "command_palette::Toggle";

            # code. rename and code actions also live on `g r n` and `g r a`
            # in the vim layer, these are the leader spellings
            "space c r" = "editor::Rename";
            "space c a" = "editor::ToggleCodeActions";
            "space c d" = "editor::Hover";

            # git
            "space g g" = [
              "task::Spawn"
              {
                task_name = "lazygit";
                reveal_target = "center";
              }
            ];
            "space g b" = "branches::OpenRecent";
            "space g s" = "git_panel::ToggleFocus";

            # panels and buffers
            "space e" = "project_panel::ToggleFocus";
            "space t t" = "terminal_panel::Toggle";
            "space b d" = "pane::CloseActiveItem";
            "space q q" = "zed::Quit";

            # toggles
            "space u h" = "editor::ToggleInlayHints";
            "space u w" = "editor::ToggleSoftWrap";
          };
        }

        # line moving. zed already has this on alt-up and alt-down, these are
        # the nvim spellings, in insert mode too
        {
          context = "Editor";
          bindings = {
            "alt-j" = "editor::MoveLineDown";
            "alt-k" = "editor::MoveLineUp";
          };
        }
      ];
    }

    {
      hjem.users.${username}.xdg.config.files = {
        "zed/settings.json" = {
          type = "copy";
          value = cfg.settings;
          generator = json.generate "settings.json";
        };

        # hjem only accepts attribute sets for `value`, and a zed keymap is a
        # top level list, so the file is generated up front instead
        "zed/keymap.json" = {
          type = "copy";
          source = json.generate "keymap.json" cfg.keymap;
        };

        "zed/tasks.json" = {
          type = "copy";
          source = json.generate "tasks.json" tasks;
        };
      };
    }
  ];
}
