{ lib, config, ... }:

{
  config = lib.mkIf config.myModules.walker.enable {
    # Generate the wallpaper switcher Lua menu for Elephant.
    # Dynamically scans the active theme's wallpaper directory at runtime.
    xdg.configFile."elephant/menus/wallpapers.lua".text = ''
      Name                 = "wallpapers"
      NamePretty           = "Wallpapers"
      Icon                 = ""
      Cache                = false
      HideFromProviderlist = true

      function GetEntries()
          local entries  = {}
          local theme    = io.open(os.getenv("HOME") .. "/.local/state/theme/active-theme")
          local theme_name = theme:read("*l")
          theme:close()

          local wallpaper_dir = os.getenv("HOME") .. "/.config/nixconf/assets/wallpapers/" .. theme_name
          local handle = io.popen("find '" .. wallpaper_dir .. "' -maxdepth 1 -type f \\( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.gif' \\) | sort")

          if handle then
              for line in handle:lines() do
                  local filename = line:match("([^/]+)$")
                  local name     = filename:match("(.+)%..+$")

                  -- Strip leading number prefix (e.g. "1-", "12-")
                  name = name:match("^%d+%-(.+)$") or name

                  -- Replace dashes with spaces
                  name = name:gsub("-", " ")

                  -- Title case each word
                  name = name:gsub("(%a)([%w_']*)", function(first, rest)
                      return first:upper() .. rest:lower()
                  end)

                  table.insert(entries, {
                      Text        = name,
                      Value       = line,
                      Preview     = line,
                      PreviewType = "file",
                      Actions     = {
                          activate = "awww img '" .. line .. "' --transition-type fade",
                      },
                  })
              end
              handle:close()
          end

          return entries
      end
    '';
  };
}
