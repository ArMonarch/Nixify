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
      fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];
    }

    # defines the default configuration for the zed editor
    {
      nixify.aspect.programs.zed.settings = {
        ###############################################################
        # Appearance
        ###############################################################
        theme = "Maple Dark";
        icon_theme = "Zed (Default)";

        buffer_font_family = "JetBrainsMono Nerd Font Propo";
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

        # every binding is ours, `None` drops zed's own base layer entirely
        # and leaves only vim mode plus what keymap.json declares
        vim_mode = true;
        base_keymap = "None";

        # no model ever gets to see this editor
        disable_ai = true;
        show_edit_predictions = false;

        ###############################################################
        # Language servers
        ###############################################################
        enable_language_server = true;
        inlay_hints.enabled = true;

        # Pin every server to the system binary. Zed already prefers one found
        # on $PATH, but a server it downloaded itself would not run on nixos,
        # so this states the contract: servers come from the flake, never from
        # a runtime fetch.
        lsp =
          lib.attrsets.genAttrs [
            # shipped with zed
            "rust-analyzer"
            "clangd"
            "gopls"
            "json-language-server"
            "package-version-server"
            "yaml-language-server"
            "vscode-css-language-server"
            "tailwindcss-language-server"
            "vtsls"
            "typescript-language-server"
            "eslint"
            "basedpyright"
            "pyright"
            "pylsp"
            "ruff"
            "ty"

            # contributed by the extensions below
            "vscode-html-language-server"
            "ols"
            "slangd"
            "zls"
          ]
          (_: {binary.ignore_system_version = false;});

        languages = {
          "Rust".format_on_save = "on";

          # clangd is intentionally disabled, the projects here use their own
          # tooling and the bundled server fights with it
          "C++" = {
            enable_language_server = false;
            completions.lsp = false;
          };
          "C" = {
            enable_language_server = false;
            completions.lsp = false;
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
          zig = true;
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
          folder_icons = false;
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
        # `VimControl` is zed's own predicate for "vim bindings apply here",
        # it covers normal, visual and operator pending mode in one context
        {
          context = "VimControl && !menu";
          bindings = {
            h = "vim::Left";
            j = "vim::Down";
            k = "vim::Up";
            l = "vim::Right";

            left = "vim::Left";
            down = "vim::Down";
            up = "vim::Up";
            right = "vim::Right";

            # buffer search, `n` and `shift-n` walk the matches it leaves behind
            "/" = "vim::Search";
            "?" = ["vim::Search" {backwards = true;}];
            n = "vim::MoveToNextMatch";
            "shift-n" = "vim::MoveToPreviousMatch";

            # visual selection, charwise, linewise and blockwise
            v = "vim::ToggleVisual";
            "shift-v" = "vim::ToggleVisualLine";
            "ctrl-v" = "vim::ToggleVisualBlock";
          };
        }

        # window movement. `ctrl-w` on its own is cleared so it can open a
        # chord instead of deleting the previous word, which is what zed's own
        # vim keymap does here. the wider context reaches panes that are not an
        # editor, the project panel and terminal among them
        {
          context = "VimControl && !menu || !Editor && !Terminal";
          bindings = {
            "ctrl-w" = null;
            "ctrl-w h" = "workspace::ActivatePaneLeft";
            "ctrl-w j" = "workspace::ActivatePaneDown";
            "ctrl-w k" = "workspace::ActivatePaneUp";
            "ctrl-w l" = "workspace::ActivatePaneRight";
          };
        }

        # Telescope style pickers. Zed has no telescope extension, but it ships
        # the same set of fuzzy pickers natively, so these are only leader keys
        # onto actions that already exist. `f g` is the live grep equivalent,
        # it opens the project wide search in a multibuffer.
        {
          context = "vim_mode == normal";
          bindings = {
            "space space" = "file_finder::Toggle";
            ":" = "command_palette::Toggle";

            "space f f" = "file_finder::Toggle";
            "space f g" = "pane::DeploySearch";
            "space f b" = "tab_switcher::Toggle";
            "space f r" = "projects::OpenRecent";
            "space f s" = "outline::Toggle";
            "space f w" = "project_symbols::Toggle";
            "space f d" = "diagnostics::Deploy";
            "space f c" = "command_palette::Toggle";
          };
        }

        # the search bar is a pane of its own, enter accepts the query and
        # escape hands the buffer back
        {
          context = "BufferSearchBar && !in_replace";
          bindings = {
            enter = "vim::SearchSubmit";
            escape = "buffer_search::Dismiss";
          };
        }

        # saving is a workspace level action, it has to sit outside the vim
        # contexts to also catch panes that are not an editor
        {
          context = "Workspace";
          bindings = {
            "ctrl-s" = "workspace::Save";
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
      };
    }
  ];
}
