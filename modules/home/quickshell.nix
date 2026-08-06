{pkgs, ...}: {
  home.packages = [pkgs.quickshell];

  xdg.configFile = {
    "quickshell/shell.qml".text = ''
      import QtQuick
      import Quickshell
      import Quickshell.Hyprland
      import Quickshell.Services.UPower
      import Quickshell.Services.Pipewire

      PanelWindow {
        anchors {
          top: true
          left: true
          right: true
        }
        height: 32
        color: Qt.rgba(30/255, 30/255, 30/255, 0.95)

        property string fontName: "JetBrainsMonoNL Nerd Font"
        property int fontSize: 13

        property real brightnessValue: 0
        property real brightnessMax: 19393

        function refreshBrightness() {
          var xhr = new XMLHttpRequest()
          xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
              if (xhr.status === 200) {
                brightnessValue = (parseInt(xhr.responseText.trim()) / brightnessMax) * 100
              }
            }
          }
          xhr.open("GET", "file:///sys/class/backlight/intel_backlight/brightness")
          xhr.send()
        }

        Timer {
          interval: 5000
          repeat: true
          running: true
          triggeredOnStart: true
          onTriggered: refreshBrightness()
        }

        Row {
          anchors.fill: parent
          anchors.margins: 0
          spacing: 0

          Rectangle {
            width: parent.width
            height: parent.height
            color: "transparent"

            Row {
              anchors.fill: parent
              anchors.verticalCenter: parent.verticalCenter
              spacing: 0

              Repeater {
                model: Hyprland.workspaces
                delegate: Rectangle {
                  width: 28
                  height: 32
                  color: "transparent"

                  Text {
                    anchors.centerIn: parent
                    font.family: fontName
                    font.pixelSize: 10
                    color: modelData.active ? "#ffffff" : "#5a5a5a"
                    text: modelData.active ? "\u25CF" : "\u25CB"
                  }

                  MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + modelData.id)
                  }
                }
              }
            }
          }
        }

        Text {
          anchors.centerIn: parent
          font.family: fontName
          font.pixelSize: fontSize
          font.weight: Font.Bold
          color: "#ffffff"

          property var now: new Date()
          Timer {
            interval: 60000
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: parent.now = new Date()
          }

          text: Qt.formatTime(now, "HH:mm")
        }

        Row {
          anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 10
          }
          spacing: 10

          Text {
            font.family: fontName
            font.pixelSize: fontSize
            color: "#ffffff"
            text: Math.round(Pipewire.defaultAudioSink.volume * 100) + "%"
          }

          Text {
            font.family: fontName
            font.pixelSize: fontSize
            color: "#ffffff"
            text: Math.round(brightnessValue) + "%"
          }

          Text {
            font.family: fontName
            font.pixelSize: fontSize
            color: "#ffffff"
            text: Math.round(UPower.displayDevice.percentage * 100) + "%"
          }
        }
      }
    '';
  };
}
