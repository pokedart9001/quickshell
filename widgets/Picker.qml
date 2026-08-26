pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../animations"
import "../theme"

WrapperItem {
    id: picker
    margin: 8
    resizeChild: false

    required property list<var> entries
    property string placeholderText: "Search..."

    signal accept(entry: var)
    signal cancel

    Keys.onEscapePressed: cancel()
    Keys.onUpPressed: cards.decrementCurrentIndex()
    Keys.onDownPressed: cards.incrementCurrentIndex()
    Keys.onReturnPressed: accept(cards.currentItem.modelData)

    ColumnLayout {
        anchors {
            top: parent.top
            topMargin: picker.margin
        }

        RowLayout {
            spacing: 8
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.bottomMargin: 3

            Text {
                color: Colors.text
                font {
                    family: "CommitMono Nerd Font Propo"
                    pointSize: 15
                    weight: 700
                }
                text: ""
            }

            TextField {
                id: search
                Layout.fillWidth: true
                Layout.minimumWidth: 300

                padding: 5
                leftPadding: 8

                color: Colors.text
                font.pointSize: 11

                background: Rectangle {
                    color: Colors.surface0
                    border {
                        color: Colors.lavender
                        width: 1
                    }
                    radius: height / 4
                }

                placeholderText: picker.placeholderText
                placeholderTextColor: Colors.surface2

                Component.onCompleted: forceActiveFocus()
            }
        }

        ListView {
            id: cards

            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 175)
            clip: true

            spacing: 5

            add: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }

            remove: Transition {
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            displaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }

            model: ScriptModel {
                values: search.text === "" ? picker.entries : [...picker.entries].map(entry => ({
                            entry: entry,
                            score: picker.fuzzyScore(entry.name, search.text)
                        })).filter(result => result.score >= 0).sort((a, b) => b.score - a.score).map(result => result.entry)
                onValuesChanged: cards.currentIndex = 0
            }

            delegate: WrapperMouseArea {
                id: card

                required property var modelData
                required property int index

                margin: 5
                width: ListView.view.width

                hoverEnabled: true
                onEntered: ListView.view.currentIndex = index
                onClicked: picker.accept(modelData)

                RowLayout {
                    spacing: 8

                    IconImage {
                        visible: source !== ""
                        implicitSize: 30
                        source: card.modelData.icon
                    }

                    Text {
                        Layout.fillWidth: true

                        color: Colors.text
                        font {
                            pointSize: 11
                            weight: 700
                        }
                        text: card.modelData.name
                    }
                }
            }

            highlight: Rectangle {
                color: Colors.base
                radius: 10
            }
        }

        Text {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.topMargin: -parent.spacing

            visible: cards.model.values.length === 0
            opacity: visible ? 1 : 0

            CubicBehavior on opacity {}

            color: Colors.surface0
            font {
                pointSize: 14
                weight: 600
            }
            text: "No results"
        }
    }

    function fuzzyScore(text, query) {
        text = text.toLowerCase();
        query = query.toLowerCase();

        let qi = 0;
        let score = 0;

        for (let i = 0; i < text.length; ++i) {
            if (text[i] !== query[qi])
                continue;

            score += 10;

            if (i === 0 || " -_./".includes(text[i - 1]))
                score += 20;

            if (++qi === query.length)
                return score - text.length;
        }

        return -1;
    }
}
