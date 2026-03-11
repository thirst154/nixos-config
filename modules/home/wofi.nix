{ ... }: {
  xdg.configFile."wofi/config".text = ''
    width=580
    height=400
    prompt=Search
    filter_rate=100
    allow_markup=false
    no_actions=true
    halign=fill
    orientation=vertical
    content_halign=fill
    insensitive=true
    allow_images=true
    image_size=36
    gtk_dark=true
  '';

  xdg.configFile."wofi/style.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font";
      font-size: 14px;
    }

    window {
      background-color: #1b1c1d;
      border: 1px solid #35363a;
      border-radius: 10px;
    }

    #input {
      background-color: #252628;
      color: #d0cfcd;
      border: 1px solid #35363a;
      border-radius: 6px;
      padding: 8px 12px;
      margin: 10px;
      outline: none;
      caret-color: #d0cfcd;
    }

    #input:focus {
      border-color: #5294e2;
    }

    #inner-box {
      background-color: transparent;
    }

    #outer-box {
      background-color: transparent;
      padding: 0 8px 8px 8px;
    }

    #scroll {
      background-color: transparent;
    }

    #text {
      color: #d0cfcd;
      padding: 2px 0;
    }

    #entry {
      padding: 6px 10px;
      border-radius: 6px;
      margin: 2px 0;
    }

    #entry:selected {
      background-color: #2d2f32;
      border: 1px solid #5294e2;
    }

    #entry:selected #text {
      color: #ffffff;
    }
  '';
}
