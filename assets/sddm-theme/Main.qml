import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 640
    height: 480
    color: "#1E1E1E"

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    TextConstants { id: textConstants }

    property int sessionIndex: sessionSelector.index

    Connections {
        target: sddm
        onLoginSucceeded: {
        }
        onLoginFailed: {
            passwordBox.text = ""
            passwordBox.focus = true
            messageText.text = textConstants.loginFailed
            messageText.visible = true
        }
        onInformationMessage: {
            messageText.text = message
            messageText.visible = true
        }
    }

    Image {
        id: background
        anchors.fill: parent
        source: "background.jpg"
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.3
    }

    Rectangle {
        id: panel
        width: 420
        height: 420
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
                font.pixelSize: 32
                text: Qt.formatDateTime(new Date(), "hh:mm")
            }

            Text {
                id: dateText
                anchors.horizontalCenter: parent.horizontalCenter
                color: Qt.rgba(1, 1, 1, 0.7)
                font.family: "JetBrainsMonoNL Nerd Font"
                font.pixelSize: 11
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
                font.pixelSize: 10
                visible: false
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: promptText
                anchors.horizontalCenter: parent.horizontalCenter
                color: Qt.rgba(1, 1, 1, 0.7)
                font.family: "JetBrainsMonoNL Nerd Font"
                font.pixelSize: 10
                text: sddm.prompt
                visible: sddm.prompt !== ""
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            TextBox {
                id: usernameBox
                width: parent.width
                height: 42
                color: Qt.rgba(50/255, 50/255, 50/255, 0.6)
                textColor: "#ffffff"
                font.family: "JetBrainsMonoNL Nerd Font"
                font.pixelSize: 12
                text: userModel.lastUser
                radius: 4
                borderColor: Qt.rgba(1, 1, 1, 0.1)
                hoverColor: Qt.rgba(1, 1, 1, 0.2)
                focusColor: Qt.rgba(1, 1, 1, 0.3)
                KeyNavigation.backtab: loginButton
                KeyNavigation.tab: passwordBox
            }

            PasswordBox {
                id: passwordBox
                width: parent.width
                height: 42
                color: Qt.rgba(50/255, 50/255, 50/255, 0.6)
                textColor: "#ffffff"
                font.family: "JetBrainsMonoNL Nerd Font"
                font.pixelSize: 12
                radius: 4
                borderColor: Qt.rgba(1, 1, 1, 0.1)
                hoverColor: Qt.rgba(1, 1, 1, 0.2)
                focusColor: Qt.rgba(1, 1, 1, 0.3)
                KeyNavigation.backtab: usernameBox
                KeyNavigation.tab: loginButton
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(usernameBox.text, passwordBox.text, sessionIndex)
                        event.accepted = true
                    }
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
                    text: textConstants.login
                    font.family: "JetBrainsMonoNL Nerd Font"
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: sddm.login(usernameBox.text, passwordBox.text, sessionIndex)
                }

                KeyNavigation.backtab: passwordBox
                KeyNavigation.tab: usernameBox

                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(usernameBox.text, passwordBox.text, sessionIndex)
                        event.accepted = true
                    }
                }
            }

            ComboBox {
                id: sessionSelector
                width: parent.width
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                borderColor: Qt.rgba(1, 1, 1, 0.1)
                textColor: Qt.rgba(1, 1, 1, 0.5)
                font.family: "JetBrainsMonoNL Nerd Font"
                font.pixelSize: 12
                model: sessionModel
                index: sessionModel.lastIndex
            }
        }
    }

    Component.onCompleted: {
        if (usernameBox.text === "")
            usernameBox.focus = true
        else
            passwordBox.focus = true
    }
}
