import QtQuick
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    Controls.TextField {
        id: kcfg_dlls
        Kirigami.FormData.label: "DLLs:"
        placeholderText: '["A", "B", "C"]'
        implicitWidth: 300
    }
}
