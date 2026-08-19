import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.components as PlasmaComponents

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import QtQuick.Effects

PlasmoidItem {
    id: root

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    implicitWidth: 1000; implicitHeight: 200

    property var dlls: {
        try {
            return JSON.parse(plasmoid.configuration.dlls)
        } catch(e) {
            return ["Error parsing JSON"]
        }
    }
    property string textToShow: {
        if(selectedDll == -2) return "boot RNG failed"
        if(selectedDll == -1) return "loading..."

        return root.plasmoid.configuration.capitalize ? root.dlls[selectedDll].toUpperCase() : root.dlls[selectedDll]
    }
    property var selectedDll: -1

    // GET BOOT RANDOM
        Plasma5Support.DataSource {
            id: executableEngine
            engine: "executable"
            connectedSources: []
            
            onNewData: (sourceName, data) => {
                // "data.stdout" receives the string stream directly from the system pipe
                let rawOutput = data.stdout || ""
                let boot_id = rawOutput.replace(/-/g, '').substring(0, 12).trim()
                
                let randomNum = parseInt(boot_id, 16)
                
                if (!isNaN(randomNum) && root.dlls.length > 0) {
                    root.selectedDll = randomNum % root.dlls.length
                } else {
                    root.selectedDll = -2 // "boot RNG failed"
                }
                
                // Disconnect immediately after reading so it doesn't loop run
                disconnectSource(sourceName)
            }
        }

        Component.onCompleted: {
            executableEngine.connectSource("cat /proc/sys/kernel/random/boot_id")
        }

    // END GET BOOT RANDOM


    Item {
        id: dllText
        anchors.fill: parent

        PlasmaComponents.Label {
            id: fancyText
            text: root.textToShow
            anchors.centerIn: parent
            font.pixelSize: 200
            font.family: "Playfair Display"
            font.variableAxes: { "wght": 900 }
            font.italic: false
            font.letterSpacing: 2
            color: "white"
            opacity: root.plasmoid.configuration.opacity
        }
    }

    MultiEffect {
        id: effect
        source: dllText
        anchors.fill: dllText
        autoPaddingEnabled: true

        blurEnabled: true
        blur: 1
        blurMax: 32
        blurMultiplier: 5.0

        // maskEnabled: true
        // maskInverted: true
        // maskSource: fancyText
        // maskSpreadAtMin: 1.0
        // maskThresholdMin: 0.5

        shadowEnabled: true
        shadowColor: "#000000"
        shadowOpacity: 0.0
        shadowBlur: 0.6
    }
}