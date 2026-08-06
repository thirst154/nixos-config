{pkgs, ...}: let
  brightnessPath = "/sys/class/backlight/intel_backlight/brightness";
  maxBrightnessPath = "/sys/class/backlight/intel_backlight/max_brightness";
in {
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

        property int brightnessPercent: 0

        function updateBrightness() {
          var brightnessFile = Qt.createQmlObject('import QtQuick 2.0; TextFile {}', this)
          var maxFile = Qt.createQmlObject('import QtQuick 2.0; TextFile {}', this)
          try {
            brightnessFile.source = "file://${brightnessPath}"
            maxFile.source = "file://${maxBrightnessPath}"
            var b = parseInt(brightnessFile.text)
            var m = parseInt(maxFile.text)
            if (!isNaN(b) && !isNaN(m) && m > 0) {
              brightnessPercent = Math.round((b / m) * 100)
            }
          } catch (e) {}
          brightnessFile.destroy()
          maxFile.destroy()
        }

        Timer {
          interval: 5000
          repeat: true
          running: true
          triggeredOnStart: true
          onTriggered: updateBrightness()
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
            text: Pipewire.ready ? Math.round(Pipewire.defaultAudioSink.volume * 100) + "%" : "--"
          }

          Text {
            font.family: fontName
            font.pixelSize: fontSize
            color: "#ffffff"
            text: brightnessPercent + "%"
          }

          Text {
            font.family: fontName
            font.pixelSize: fontSize
            color: "#ffffff"
            text: UPower.displayDevice.percentage + "%"
          }
        }
      }
    '';
  };
}
