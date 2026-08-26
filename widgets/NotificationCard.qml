import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import "../theme"

WrapperItem {
    id: card

    required property string image
    required property string summary
    required property string body

    property int desiredWidth: 500
    property bool explicitWidth: false

    property int desiredHeight: 160
    property bool explicitHeight: false

    margin: 10

    RowLayout {
        spacing: 10

        IconImage {
            id: icon

            visible: source !== ""
            implicitSize: 55
            source: card.image ?? ""
        }

        ColumnLayout {
            id: content

            spacing: 0

            Item {
                Layout.fillHeight: true
            }

            Text {
                id: summaryText

                Layout.maximumWidth: card.desiredWidth - icon.implicitSize - card.margin * 2
                Layout.minimumWidth: card.explicitWidth ? Layout.maximumWidth : -1
                Layout.bottomMargin: 5

                color: Colors.text
                font {
                    pointSize: 12
                    weight: 700
                }

                text: card.summary ?? ""
                elide: Text.ElideRight
            }

            Text {
                id: bodyText

                Layout.maximumWidth: card.desiredWidth - icon.implicitSize - card.margin * 2
                Layout.minimumWidth: card.explicitWidth ? Layout.maximumWidth : -1
                Layout.maximumHeight: card.desiredHeight - summaryText.implicitHeight - card.margin * 2

                visible: text !== ""

                color: Colors.text
                font {
                    pointSize: 10
                    weight: 400
                }

                text: card.body ?? ""
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
