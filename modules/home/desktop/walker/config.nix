{
  # Force keyboard focus on launch
  force_keyboard_focus = true;

  # Wrap around at end of list
  selection_wrap = true;

  # Hide F1/F2/F3 quick activate buttons and bottom hint bar
  hide_quick_activation = true;
  hide_action_hints = true;

  placeholders."default" = {
    input = "Search...";
    list = "No Results";
  };

  placeholders."menus:themes" = {
    input = "Search...";
    list = "No Results";
  };

  placeholders."menus:wallpapers" = {
    input = "Search...";
    list = "No Results";
  };

  # Only show desktop applications, limit results
  providers = {
    empty = [ "desktopapplications" ];
    max_results = 256;
  };
}
