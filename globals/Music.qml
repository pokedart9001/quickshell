pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

Singleton {
    readonly property MprisPlayer currentlyPlayingPlayer: Mpris.players.values.find(player => player.isPlaying) ?? null

    property MprisPlayer player
    onCurrentlyPlayingPlayerChanged: {
        if (currentlyPlayingPlayer != null)
            player = Mpris.players.values.length === 0 ? null : currentlyPlayingPlayer;
    }
}
