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

    implicitWidth: 500; implicitHeight: 200


    property var dlls: {
        try {
            return JSON.parse(plasmoid.configuration.dlls)
        } catch(e) {
            return ["Error parsing JSON"]
        }
    }

    property string textToShow: "Loading..."

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
                    root.textToShow = root.dlls[randomNum % root.dlls.length]
                } else {
                    root.textToShow = root.dlls[0] // Standard fallback
                }
                
                // Disconnect immediately after reading so it doesn't loop run
                disconnectSource(sourceName)
            }
        }

        // 2. Trigger a simple cat command to dump the virtual file stream
        Component.onCompleted: {
            executableEngine.connectSource("cat /proc/sys/kernel/random/boot_id")
        }

    // END GET BOOT RANDOM


    Item {
        id: textContainer
        anchors.fill: parent

        PlasmaComponents.Label {
            id: fancyText
            text: root.textToShow
            anchors.centerIn: parent
            
            // Super fancy styling: large, heavy, and semi-translucent
            font.pixelSize: 120
            
            font.weight: Font.Black
            font.styleName: "Condensed"
            
            // 0.4 makes it 40% opaque, letting background colors bleed through
            opacity: 0.4 
            color: "white" 
        }
    }

    // Hardware-accelerated blur effect applied directly over the text layer
    MultiEffect {
        source: textContainer
        anchors.fill: textContainer
        
        // Configures a high-quality soft frosted blur radius around the font
        blurEnabled: true
        blur: 1.0           // Range from 0.0 to 1.0
        blurMax: 64         // Maximum blurring radius in pixels

        // Optional: Adds a stylized subtle tint shadow for extra contrast
        shadowEnabled: true
        shadowColor: "#000000"
        shadowOpacity: 0.3
    }
}