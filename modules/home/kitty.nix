{
  pkgs,
  ...
}: {
  xdg.configFile."kitty/kitty.conf".text = ''
    font_family JetBrainsMono Nerd Font
    bold_font auto
    italic_font auto
    bold_italic_font auto
    font_size 15

    confirm_os_window_close -1

    disable_ligatures never

    include current-theme.conf
  '';

  xdg.configFile."kitty/current-theme.conf".text = ''
    foreground               #e0def4
    background               #191724
    selection_foreground     #e0def4
    selection_background     #403d52

    cursor                   #524f67
    cursor_text_color        #e0def4

    url_color                #c4a7e7

    active_tab_foreground    #e0def4
    active_tab_background    #26233a
    inactive_tab_foreground  #6e6a86
    inactive_tab_background  #191724

    color0   #26233a
    color8   #6e6a86

    color1   #eb6f92
    color9   #eb6f92

    color2   #31748f
    color10  #31748f

    color3   #f6c177
    color11  #f6c177

    color4   #9ccfd8
    color12  #9ccfd8

    color5   #c4a7e7
    color13  #c4a7e7

    color6   #ebbcba
    color14  #ebbcba

    color7   #e0def4
    color15  #e0def4
  '';
}
