import Quickshell
import Quickshell.Services.Pam
import QtQuick

Scope {
    id: root

    property string message: ""
    property string pendingPassword: ""
    property bool isAuthenticating: false

    signal unlocked()
    signal failed(string msg)

    PamContext {
        id: pam
        config: "login"
        user: Quickshell.env("USER") || ""

        onResponseRequiredChanged: {
            if (responseRequired && root.pendingPassword !== "") {
                pam.respond(root.pendingPassword);
                root.pendingPassword = "";
            }
        }

        onCompleted: function(result) {
            root.isAuthenticating = false;
            if (result === PamResult.Success) {
                root.message = "";
                root.unlocked();
            } else {
                root.message = (result === PamResult.MaxTries) ? "Too many attempts" : "Wrong password";
                root.failed(root.message);
            }
        }

        onError: function(err) {
            root.isAuthenticating = false;
            root.message = "Auth error";
            root.failed(root.message);
        }
    }

    function start() {
        message = "";
        pendingPassword = "";
        isAuthenticating = false;
        if (pam.busy) pam.cancel();
        pam.start();
    }

    function tryUnlock(password) {
        if (isAuthenticating) return;
        message = "";
        isAuthenticating = true;
        pendingPassword = password;
        
        if (pam.responseRequired) {
            pam.respond(password);
            pendingPassword = "";
        } else if (!pam.busy) {
            pam.start();
        }
    }

    function reset() {
        pendingPassword = "";
        isAuthenticating = false;
        if (pam.busy) pam.cancel();
    }
}
