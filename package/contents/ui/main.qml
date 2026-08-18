import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import QtQuick.Effects

Item {
    id: root
    implicitWidth: 500; implicitHeight: 200
    property var dlls: {
        try {
            return JSON.parse(plasmoid.configuration.dlls)
        } catch(e) {
            return ["Error parsing JSON"]
        }
    }


    property string TextToShow: "Loading..."

    // Always display the compact view.
    // Never show the full popup view even if there is space for it.
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    function loadBootId() {
        let xhr = new XMLHttpRequest()
        xhr.open("GET", "file:///proc/sys/kernel/random/boot_id")
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                let boot_id = = uuid.replace(/-/g, '').substring(0, 12);
                const randomNum = parseInt(boot_id, 16);

                root.TextToShow = root.dlls[randomNum % root.dlls.length]

            }
        }
        xhr.send()
    }

    Plasmoid.fullRepresentation: Item {
        id: textContainer
        anchors.fill: parent

        PlasmaComponents.Label {
            id: fancyText
            text: root.TextToShow
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
        blur: 0.6            // Adjust blur intensity (0.0 to 1.0)
        blurMaxRadius: 64    // Maximum pixel spread of the glow/blur
        
        // Optional: Adds a stylized subtle tint shadow for extra contrast
        shadowEnabled: true
        shadowColor: "#000000"
        shadowOpacity: 0.3
    }
}