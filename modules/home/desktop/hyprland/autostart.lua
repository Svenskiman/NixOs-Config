-- Autostart --

hl.on("hyprland.start", function()
    hl.exec_cmd("qs -c nixshell -n -d")
    hl.exec_cmd("nm-applet --indicator")
end)
