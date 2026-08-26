pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource

    readonly property bool ready: sink && Pipewire.ready
    readonly property bool muted: ready && sink.audio.muted

    readonly property real volume: ready ? sink.audio.volume : 0

    PwObjectTracker {
        objects: [root.sink, root.source]
    }
}
