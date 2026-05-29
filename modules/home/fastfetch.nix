{
  pkgs,
  ...
}: {
  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "logo": {
        "type": "builtin",
        "source": "arch_small",
        "padding": {
          "right": 3
        }
      },
      "display": {
        "separator": "  ",
        "color": {
          "keys": "cyan",
          "title": "bright_white"
        },
        "percent": {
          "type": ["num", "bar"],
          "ndigits": 0,
          "color": {
            "green": "32",
            "yellow": "93",
            "red": "91"
          },
          "bar": {
            "charElapsed": "━",
            "charTotal": "━",
            "borderLeft": "",
            "borderRight": ""
          }
        }
      },
      "modules": [
        {
          "type": "title",
          "key": "   ",
          "color": {
            "user": "cyan",
            "at": "white",
            "host": "cyan"
          }
        },
        "separator",
        {
          "type": "os",
          "key": "  OS"
        },
        {
          "type": "packages",
          "key": "󰏖  Packages",
          "disabled": ["apk", "brew", "cargo", "chocolatey", "conda", "crew", "dpkg", "ebuild", "emerge", "environment", "fink", "freebsd", "gem", "guix", "homebrew", "ipkg", "lport", "macports", "nix", "npm", "opkg", "pacstall", "pip", "pipx", "pkg", "pkgtool", "portage", "rpm", "scoop", "slapt-get", "snap", "suy", "tlmgr", "winget", "xbps", "yum", "zypper"]
        },
        {
          "type": "shell",
          "key": "  Shell"
        },
        {
          "type": "memory",
          "key": "  Memory"
        },
        {
          "type": "swap",
          "key": "󰓡  Swap"
        },
        {
          "type": "disk",
          "key": "  Disk",
          "folders": "/",
          "showLoop": false,
          "showHidden": false,
          "showSubvolumes": false,
          "showRegular": false,
          "showExternal": false,
          "showReadOnly": false,
          "showUnknown": false
        },
        {
          "type": "localip",
          "key": "󰩟  Local IP",
          "showIpv4": true,
          "showIpv6": false,
          "showLoop": false,
          "showMac": false,
          "showPrefixLen": false,
          "defaultRouteOnly": true,
          "showAllIps": false
        },
        {
          "type": "battery",
          "key": "  Battery"
        }
      ]
    }
  '';
}
