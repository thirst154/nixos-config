{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "brightness-up" ''
      MAX=$(cat /sys/class/backlight/intel_backlight/max_brightness)
      CUR=$(cat /sys/class/backlight/intel_backlight/brightness)
      STEP=$((MAX / 20))
      NEW=$((CUR + STEP))
      [ "$NEW" -gt "$MAX" ] && NEW=$MAX
      busctl call org.freedesktop.login1 /org/freedesktop/login1/session/auto org.freedesktop.login1.Session SetBrightness ssu "backlight" "intel_backlight" "$NEW"
    '')
    (pkgs.writeShellScriptBin "brightness-down" ''
      MAX=$(cat /sys/class/backlight/intel_backlight/max_brightness)
      CUR=$(cat /sys/class/backlight/intel_backlight/brightness)
      STEP=$((MAX / 20))
      NEW=$((CUR - STEP))
      [ "$NEW" -lt 1 ] && NEW=1
      busctl call org.freedesktop.login1 /org/freedesktop/login1/session/auto org.freedesktop.login1.Session SetBrightness ssu "backlight" "intel_backlight" "$NEW"
    '')
    (pkgs.writeShellScriptBin "toggle-waybar" ''
      if pgrep -x waybar > /dev/null; then
        killall waybar
      else
        waybar &
      fi
    '')
  ];
}
