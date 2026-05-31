{pkgs, ...}: {
  home.packages = [pkgs.wofi];

  xdg.configFile."wofi/config".text = ''
    show=drun
    prompt=Search...
    normal_window=false
    layer=top
    location=center
    width=600
    height=400
    columns=1
    no_actions=true
    insensitive=true
    allow_images=true
    image_size=24
  '';

  xdg.configFile."wofi/style.css".text = ''
    * {
        font-family: "JetBrainsMonoNL Nerd Font", sans-serif;
        font-size: 14px;
    }

    window {
        background-color: rgba(30, 30, 30, 0.95);
        color: #ffffff;
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 8px;
    }

    #input {
        background-color: rgba(50, 50, 50, 0.6);
        color: #ffffff;
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 4px;
        padding: 10px 14px;
        margin: 12px;
    }

    #input:focus {
        border-color: rgba(255, 255, 255, 0.3);
    }

    #inner-box {
        margin: 0 12px 12px 12px;
    }

    #entry {
        padding: 8px 12px;
        border-radius: 4px;
    }

    #entry:selected {
        background-color: rgba(255, 255, 255, 0.1);
    }

    #img {
        margin-right: 10px;
    }

    #text {
        color: #ffffff;
    }

    #entry:selected #text {
        color: #ffffff;
    }
  '';
}
