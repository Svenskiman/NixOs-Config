-- Autostart --

hl.on("hyprland.start", function()
    hl.exec_cmd("eww open bar")
    hl.exec_cmd("nm-applet --indicator")
end)