pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string result
    property string rawResult
    property string pending

    function evalAsync(expr: string): void {
        pending = expr;
        if (!proc.running)
            run();
    }

    function run(): void {
        const expr = pending;
        pending = "";
        proc.expr = expr;
        proc.command = ["qalc", "-t", expr];
        proc.running = true;
    }

    Process {
        id: proc

        property string expr

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n").filter(l => l.length > 0);
                const value = lines.length > 0 ? lines[lines.length - 1] : "";
                root.rawResult = value;
                root.result = value.startsWith("error: ") || value.startsWith("warning: ") ? value : `${proc.expr} = ${value}`;
            }
        }

        onRunningChanged: {
            if (!running && root.pending)
                root.run();
        }
    }
}
