{ ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "JetBrainsMono Nerd Font 11";
        foreground = "#d0cfcd";
        background = "#1b1c1d";
        frame_color = "#3d3f40";
        highlight = "#89b4fa";

        width = 340;
        height = 200;
        offset = "12x48";
        origin = "top-right";
        notification_limit = 5;

        padding = 12;
        horizontal_padding = 14;
        frame_width = 1;
        gap_size = 6;
        corner_radius = 8;

        separator_color = "frame";
        separator_height = 1;

        sort = true;
        idle_threshold = 120;

        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        word_wrap = true;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 48;

        sticky_history = true;
        history_length = 20;

        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        background = "#1b1c1d";
        foreground = "#d0cfcd";
        frame_color = "#3d3f40";
        timeout = 4;
      };

      urgency_normal = {
        background = "#1b1c1d";
        foreground = "#d0cfcd";
        frame_color = "#3d3f40";
        timeout = 6;
      };

      urgency_critical = {
        background = "#1b1c1d";
        foreground = "#f38ba8";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };
}
