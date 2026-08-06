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
        color: "#1e1e1ef2"

        property string fontName: "JetBrainsMonoNL Nerd Font"
        property int fontSize: 13

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
                model: HyprlandWorkspaceModel {}
                delegate: Rectangle {
                  width: 28
                  height: 32
                  color: "transparent"

                  Text {
                    anchors.centerIn: parent
                    font.family: fontName
                    font.pixelSize: 10
                    color: model.active ? "#ffffff" : "#5a5a5a"
                    text: model.active ? "\u25CF" : "\u25CB"
                  }

                  MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace", model.id)
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
            text: UPower.displayDevice.percentage + "%"
          }

          Text {
            font.family: fontName
            font.pixelSize: fontSize
            color: "#ffffff"
            text: Pipewire.defaultAudioSink.volume + "%"
          }
        }
      }
    '';
  };
}
