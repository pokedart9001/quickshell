pragma Singleton
import Quickshell

Singleton {
    function getDate(): date {
        return clock.date;
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
