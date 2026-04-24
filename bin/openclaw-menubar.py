#!/usr/bin/env python3
import subprocess
import AppKit
import rumps


def tunnel_is_running():
    result = subprocess.run(
        ["lsof", "-nP", "-iTCP:18789", "-sTCP:LISTEN"],
        capture_output=True,
    )
    return b"ssh" in result.stdout


class OpenClawMenuBar(rumps.App):
    def __init__(self):
        super().__init__("🦞", quit_button=None)
        # Hide from Dock and cmd-tab — pure menu bar agent
        AppKit.NSApplication.sharedApplication().setActivationPolicy_(
            AppKit.NSApplicationActivationPolicyAccessory
        )
        self.menu = [
            rumps.MenuItem("Status: checking…"),
            None,  # separator
            rumps.MenuItem("Start Tunnel", callback=self.start_tunnel),
            rumps.MenuItem("Stop Tunnel", callback=self.stop_tunnel),
            None,
            rumps.MenuItem("Quit", callback=self.quit_app),
        ]
        self._timer = rumps.Timer(self._refresh, 5)
        self._timer.start()
        self._refresh(None)

    def _refresh(self, _):
        running = tunnel_is_running()
        self.title = "🦞" if running else "☠️"
        self.menu["Status: checking…"].title = (
            "Status: running ✓" if running else "Status: not running"
        )

    def start_tunnel(self, _):
        subprocess.Popen(
            ["launchctl", "start", "com.user.openclaw-tunnel"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        rumps.notification("OpenClaw", "", "Tunnel starting…")

    def stop_tunnel(self, _):
        subprocess.Popen(
            ["launchctl", "stop", "com.user.openclaw-tunnel"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        rumps.notification("OpenClaw", "", "Tunnel stopped.")

    def quit_app(self, _):
        rumps.quit_application()


if __name__ == "__main__":
    app = OpenClawMenuBar()
    app.run()
