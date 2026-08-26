pragma Singleton

import Quickshell
import Quickshell.Services.Pam

Singleton {
    id: root

    property bool locked: false
    property bool authFailed: false
    property string pendingPassword: ""

    readonly property bool authenticating: pam.active

    PamContext {
        id: pam

        onCompleted: result => {
            if (result === PamResult.Success) {
                root.authFailed = false;
                root.locked = false;
            } else {
                root.authFailed = true;
            }
        }

        onError: root.authFailed = true

        onPamMessage: {
            if (responseRequired) {
                respond(root.pendingPassword);
                root.pendingPassword = "";
            }
        }
    }

    function authenticate(password: string) {
        if (pam.active)
            return;

        root.authFailed = false;
        root.pendingPassword = password;

        pam.start();
    }
}
