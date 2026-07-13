{ lib, config, ... }:

let
  makeOpencodeTheme =
    theme:
    let
      c = theme.colors;
    in
    builtins.toJSON {
      "$schema" = "https://opencode.ai/theme.json";
      theme = {
        # ── Core ──────────────────────────────────────────────────────────
        primary = {
          dark = c.accent;
          light = c.color4;
        };
        secondary = {
          dark = c.color6;
          light = c.color5;
        };
        accent = {
          dark = c.accent;
          light = c.color4;
        };
        error = {
          dark = c.color1;
          light = c.color1;
        };
        warning = {
          dark = c.color3;
          light = c.color3;
        };
        success = {
          dark = c.color2;
          light = c.color2;
        };
        info = {
          dark = c.color6;
          light = c.color4;
        };
        text = {
          dark = c.foreground;
          light = c.foreground;
        };
        textMuted = {
          dark = c.color8;
          light = c.color8;
        };
        background = {
          dark = c.background;
          light = c.background;
        };
        backgroundPanel = {
          dark = c.color0;
          light = c.color0;
        };
        backgroundElement = {
          dark = c.color8;
          light = c.color8;
        };

        # ── Borders ───────────────────────────────────────────────────────
        border = {
          dark = c.color8;
          light = c.color8;
        };
        borderActive = {
          dark = c.accent;
          light = c.color4;
        };
        borderSubtle = {
          dark = c.color0;
          light = c.color0;
        };

        # ── Diff ──────────────────────────────────────────────────────────
        diffAdded = {
          dark = c.color2;
          light = c.color2;
        };
        diffRemoved = {
          dark = c.color1;
          light = c.color1;
        };
        diffContext = {
          dark = c.color8;
          light = c.color8;
        };
        diffHunkHeader = {
          dark = c.color4;
          light = c.color4;
        };
        diffHighlightAdded = {
          dark = c.color2;
          light = c.color2;
        };
        diffHighlightRemoved = {
          dark = c.color1;
          light = c.color1;
        };
        diffAddedBg = {
          dark = c.color0;
          light = c.color0;
        };
        diffRemovedBg = {
          dark = c.color0;
          light = c.color0;
        };
        diffContextBg = {
          dark = c.background;
          light = c.background;
        };
        diffLineNumber = {
          dark = c.color8;
          light = c.color8;
        };
        diffAddedLineNumberBg = {
          dark = c.color0;
          light = c.color0;
        };
        diffRemovedLineNumberBg = {
          dark = c.color0;
          light = c.color0;
        };

        # ── Syntax ────────────────────────────────────────────────────────
        syntaxComment = {
          dark = c.color8;
          light = c.color8;
        };
        syntaxKeyword = {
          dark = c.color5;
          light = c.color5;
        };
        syntaxFunction = {
          dark = c.color4;
          light = c.color4;
        };
        syntaxVariable = {
          dark = c.foreground;
          light = c.foreground;
        };
        syntaxString = {
          dark = c.color2;
          light = c.color2;
        };
        syntaxNumber = {
          dark = c.color3;
          light = c.color3;
        };
        syntaxType = {
          dark = c.color6;
          light = c.color6;
        };
        syntaxOperator = {
          dark = c.accent;
          light = c.accent;
        };
        syntaxPunctuation = {
          dark = c.color7;
          light = c.color7;
        };

        # ── Markdown ──────────────────────────────────────────────────────
        markdownText = {
          dark = c.foreground;
          light = c.foreground;
        };
        markdownHeading = {
          dark = c.accent;
          light = c.color4;
        };
        markdownLink = {
          dark = c.color4;
          light = c.color4;
        };
        markdownLinkText = {
          dark = c.color6;
          light = c.color6;
        };
        markdownCode = {
          dark = c.color2;
          light = c.color2;
        };
        markdownBlockQuote = {
          dark = c.color8;
          light = c.color8;
        };
        markdownEmph = {
          dark = c.color3;
          light = c.color3;
        };
        markdownStrong = {
          dark = c.foreground;
          light = c.foreground;
        };
        markdownHorizontalRule = {
          dark = c.color8;
          light = c.color8;
        };
        markdownListItem = {
          dark = c.foreground;
          light = c.foreground;
        };
        markdownListEnumeration = {
          dark = c.accent;
          light = c.color4;
        };
        markdownImage = {
          dark = c.color4;
          light = c.color4;
        };
        markdownImageText = {
          dark = c.color6;
          light = c.color6;
        };
        markdownCodeBlock = {
          dark = c.color2;
          light = c.color2;
        };
      };
    };

  themeFiles = lib.listToAttrs (
    map (theme: {
      name = "opencode/themes/${theme.name}.json";
      value = {
        text = makeOpencodeTheme theme;
      };
    }) config.myModules.themes.definitions
  );
in

{
  config = lib.mkIf config.myModules.opencode.enable {
    xdg.configFile = themeFiles;
  };
}
