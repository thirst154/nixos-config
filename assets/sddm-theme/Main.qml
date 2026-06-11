import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#1E1E1E"

    Image {
        id: background
        anchors.fill: parent
        source: "background.jpg"
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    // Dark overlay for better contrast
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.3
    }

    Rectangle {
        id: panel
        width: 420
        height: 400
        anchors.centerIn: parent
        color: Qt.rgba(30/255, 30/255, 30/255, 0.95)
        radius: 8
        border.color: Qt.rgba(1, 1, 1, 0.1)
        border.width: 1

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                clock.text = Qt.formatDateTime(new Date(), "hh:mm")
                dateText.text = Qt.formatDateTime(new Date(), "dddd, MMMM d")
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 14
            width: 340

            Text {
                id: clock
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#ffffff"
                font.family: "JetBrainsMonoNL Nerd Font"
                font.pointSize: 32
                text: Qt.formatDateTime(new Date(), "hh:mm")
            }

            Text {
                id: dateText
                anchors.horizontalCenter: parent.horizontalCenter
                color: Qt.rgba(1, 1, 1, 0.7)
                font.family: "JetBrainsMonoNL Nerd Font"
                font.pointSize: 11
                text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
            }

            Rectangle {
                height: 20
                width: parent.width
                color: "transparent"
            }

            Text {
                id: messageText
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#f53c3c"
                font.family: "JetBrainsMonoNL Nerd Font"
                font.pointSize: 10
                text: sddm.message
                visible: sddm.message
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: promptText
                anchors.horizontalCenter: parent.horizontalCenter
                color: Qt.rgba(1, 1, 1, 0.7)
                font.family: "JetBrainsMonoNL Nerd Font"
                font.pointSize: 10
                text: sddm.prompt
                visible: sddm.prompt
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                id: usernameBg
                width: parent.width
                height: 42
                color: Qt.rgba(50/255, 50/255, 50/255, 0.6)
                radius: 4
                border.color: Qt.rgba(1, 1, 1, 0.1)
                border.width: 1

                TextInput {
                    id: username
                    anchors.fill: parent
                    anchors.margins: 11
                    color: "#ffffff"
                    font.family: "JetBrainsMonoNL Nerd Font"
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    text: userModel.lastUser || ""
                    selectByMouse: true
                    KeyNavigation.backtab: loginButton
                    KeyNavigation.tab: password
                    Keys.onReturnPressed: password.focus = true
                }

                Text {
                    anchors.fill: parent
                    anchors.margins: 11
                    color: "#808080"
                    font.family: "JetBrainsMonoNL Nerd Font"
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    text: "Username"
                    visible: !username.text && !username.activeFocus
                }
            }

            Rectangle {
                id: passwordBg
                width: parent.width
                height: 42
                color: Qt.rgba(50/255, 50/255, 50/255, 0.6)
                radius: 4
                border.color: Qt.rgba(1, 1, 1, 0.1)
                border.width: 1

                TextInput {
                    id: password
                    anchors.fill: parent
                    anchors.margins: 11
                    color: "#ffffff"
                    font.family: "JetBrainsMonoNL Nerd Font"
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    echoMode: TextInput.Password
                    passwordCharacter: "\u25CF"
                    selectByMouse: true
                    KeyNavigation.backtab: username
                    KeyNavigation.tab: loginButton
                    Keys.onReturnPressed: sddm.login(username.text, password.text, 0)
                }

                Text {
                    anchors.fill: parent
                    anchors.margins: 11
                    color: "#808080"
                    font.family: "JetBrainsMonoNL Nerd Font"
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    text: "Password"
                    visible: !password.text && !password.activeFocus
                }
            }

            Rectangle {
                id: loginButton
                width: parent.width
                height: 42
                color: Qt.rgba(50/255, 50/255, 50/255, 0.6)
                radius: 4
                border.color: Qt.rgba(1, 1, 1, 0.1)
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    color: "#ffffff"
                    text: "Login"
                    font.family: "JetBrainsMonoNL Nerd Font"
                    font.pointSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: sddm.login(username.text, password.text, 0)
                }

                KeyNavigation.backtab: password
                KeyNavigation.tab: username
                Keys.onReturnPressed: sddm.login(username.text, password.text, 0)
            }

            ComboBox {
                id: sessionSelector
                width: parent.width
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                textColor: Qt.rgba(1, 1, 1, 0.5)
                font: "JetBrainsMonoNL Nerd Font"
                model: sessionModel
                index: sessionModel.lastIndex
            }
        }
    }

    Component.onCompleted: {
        if (username.text) {
            password.focus = true
        } else {
            username.focus = true
        }
    }
}
