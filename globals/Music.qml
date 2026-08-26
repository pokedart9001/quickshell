pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: music
    readonly property MprisPlayer currentlyPlayingPlayer: Mpris.players.values.find(player => player.isPlaying) ?? null

    property MprisPlayer player
    onCurrentlyPlayingPlayerChanged: {
        if (currentlyPlayingPlayer != null)
            player = currentlyPlayingPlayer;
        else if (Mpris.players.values.length === 0)
            player = null;
    }

    readonly property real progress: {
        if (player == null) {
            return 0;
        }

        if (!player.lengthSupported || player.length == 0) {
            return 0;
        }

        return player.position / player.length;
    }

    FrameAnimation {
        running: music.player?.playbackState == MprisPlaybackState.Playing
        onTriggered: music.player?.positionChanged()
    }
}
