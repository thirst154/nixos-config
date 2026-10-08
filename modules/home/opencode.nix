{...}: {
  # USGC-RETICLE theme for the opencode TUI, ported from the kitty theme
  # (modules/home/themes/usgc-reticle/kitty.conf). See README "Visual Design".
  xdg.configFile = {
    "opencode/themes/usgc-reticle.json".source =
      ./themes/usgc-reticle/opencode.json;

    # Select the theme. Declarative: /theme changes won't persist.
    "opencode/tui.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/tui.json";
      theme = "usgc-reticle";
    };
  };
}
