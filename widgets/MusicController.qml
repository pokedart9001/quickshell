import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../globals"
import "../theme"

WrapperItem {
    id: musicController

    ColumnLayout {
        spacing: 0

        RowLayout {
            spacing: 10

            IconImage {
                implicitSize: 70
                source: {
                    const trackArtUrl = Music.player?.trackArtUrl;
                    return trackArtUrl || Quickshell.iconPath(trackArtUrl, "applications-multimedia");
                }
            }

            ColumnLayout {
                spacing: 0

                Text {
                    Layout.bottomMargin: 5
                    Layout.fillWidth: true
                    Layout.maximumWidth: 180

                    color: Colors.text
                    font {
                        pointSize: 11
                        weight: 600
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    elide: Text.ElideRight
                    text: Music.player?.trackTitle || "Unknown Title"
                }
                Text {
                    visible: Music.player?.trackAlbum ?? false

                    Layout.bottomMargin: -1
                    Layout.fillWidth: true
                    Layout.maximumWidth: 180

                    color: Colors.subtext0
                    font {
                        pointSize: 9
                        weight: 400
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    elide: Text.ElideRight
                    text: Music.player?.trackAlbum || ""
                }
                Text {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 180

                    color: Colors.surface2
                    font {
                        pointSize: 9
                        weight: 400
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    elide: Text.ElideRight
                    text: Music.player?.trackAlbumArtist || Music.player?.trackArtist || "Unknown Artist"
                }
            }
        }

        RowLayout {
            Layout.topMargin: 5
            Layout.alignment: Qt.AlignHCenter

            spacing: 30

            MenuButton {
                content: "󰒮"
                contentColor: Colors.text

                fontSize: 17
                implicitWidth: 25
                implicitHeight: 25

                onClicked: if (Music.player?.canGoPrevious)
                    Music.player.previous()
            }
            MenuButton {
                content: Music.player?.isPlaying ? "󰏤" : "󰐊"
                contentColor: Colors.text

                fontSize: 17
                implicitWidth: 25
                implicitHeight: 25

                onClicked: if (Music.player?.canTogglePlaying)
                    Music.player.isPlaying = !Music.player.isPlaying
            }
            MenuButton {
                content: "󰒭"
                contentColor: Colors.text

                fontSize: 17
                implicitWidth: 25
                implicitHeight: 25

                onClicked: if (Music.player?.canGoNext)
                    Music.player.next()
            }
        }
    }
}
