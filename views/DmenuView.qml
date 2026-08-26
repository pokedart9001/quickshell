import QtQuick

import "../widgets"

Picker {
    required property list<string> options
    entries: options.map(option => ({
                name: option,
                icon: ""
            }))

    placeholderText: "Choose..."

    signal emit(option: string)
    signal exit

    onAccept: entry => {
        emit(entry.name);
        exit();
    }

    onCancel: {
        emit("");
        exit();
    }
}
