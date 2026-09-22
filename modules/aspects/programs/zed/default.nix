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

  # Spawned from keymap.json with `reveal_target = "center"` so lazygit takes
  # the editor pane. The binary comes from the host package set.
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

        # The leader groups below need the hint popup; 1000ms upstream default
        # is a long wait once the chords are known.
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

        # Signature help after completions and opening brackets only, the
        # moment arguments get typed. `ctrl-s` in insert mode asks by hand.
        auto_signature_help = false;
        show_signature_help_after_edits = true;

        # The default `formatter = "auto"` prefers prettier when a project
        # carries one; the server is the formatter here, always.
        format_on_save = "on";
        formatter = "language_server";
        remove_trailing_whitespace_on_save = true;
        ensure_final_newline_on_save = false;

        # A server zed downloads itself would not run on nixos: every server
        # comes from the flake, never from a runtime fetch.
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
          # C/C++ projects here run their own tooling; clangd fights it. No
          # server means no formatter, so save must leave the buffer alone.
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

        # Grammars zed does not bundle. TOML is grammar-only, no server.
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
        # Leader groups follow the nvim config in ../NixVim. Anything vim.json
        # already binds the same way is left to the base keymap.
        {
          context = "vim_mode == normal";
          bindings = {
            # tab hopping, pinned so upstream changes cannot move it
            "shift-h" = "pane::ActivatePreviousItem";
            "shift-l" = "pane::ActivateNextItem";

            # zed's own pickers; `DeploySearch` is the project-wide grep
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

            # code, the leader spellings; `g r n`/`g r a` still work
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

        # Incremental selection, nvim's `gnn`. Scoping to normal and visual
        # leaves `ctrl-space` completions in insert mode untouched.
        {
          context = "vim_mode == normal || vim_mode == visual";
          bindings = {
            "ctrl-space" = "vim::SelectLargerSyntaxNode";
          };
        }

        # Scoped to visual so backspace stays `vim::WrappingLeft` in normal.
        {
          context = "vim_mode == visual";
          bindings = {
            backspace = "vim::SelectSmallerSyntaxNode";
          };
        }

        # line moving, the nvim spellings of alt-up/alt-down
        {
          context = "Editor";
          bindings = {
            "alt-j" = "editor::MoveLineDown";
            "alt-k" = "editor::MoveLineUp";
          };
        }

        # Save and tab switching, both platform spellings pinned so one keymap
        # behaves the same everywhere. `9` is the last tab, matching upstream.
        {
          context = "Workspace";
          bindings = {
            "ctrl-s" = "workspace::Save";
            "cmd-s" = "workspace::Save";

            "alt-1" = ["pane::ActivateItem" 0];
            "alt-2" = ["pane::ActivateItem" 1];
            "alt-3" = ["pane::ActivateItem" 2];
            "alt-4" = ["pane::ActivateItem" 3];
            "alt-5" = ["pane::ActivateItem" 4];
            "alt-6" = ["pane::ActivateItem" 5];
            "alt-7" = ["pane::ActivateItem" 6];
            "alt-8" = ["pane::ActivateItem" 7];
            "alt-9" = "pane::ActivateLastItem";

            "cmd-1" = ["pane::ActivateItem" 0];
            "cmd-2" = ["pane::ActivateItem" 1];
            "cmd-3" = ["pane::ActivateItem" 2];
            "cmd-4" = ["pane::ActivateItem" 3];
            "cmd-5" = ["pane::ActivateItem" 4];
            "cmd-6" = ["pane::ActivateItem" 5];
            "cmd-7" = ["pane::ActivateItem" 6];
            "cmd-8" = ["pane::ActivateItem" 7];
            "cmd-9" = "pane::ActivateLastItem";
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

        # hjem's `value` only takes attribute sets; a keymap is a list
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
