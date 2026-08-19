import QtQuick
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_dlls: dllsField.text
    property string cfg_dllsDefault: ""

    property alias cfg_capitalize: capitalizeCheckBox.checked
    property bool cfg_capitalizeDefault: false
    
    property string title: "General"

    Controls.TextField {
        id: dllsField
        Kirigami.FormData.label: "DLLs:"
        placeholderText: '["ntdll.dll","kernel32.dll","kernelbase.dll","hal.dll","advapi32.dll","wow64.dll","wow64win.dll","wow64cpu.dll","ucrtbase.dll","apphelp.dll","user32.dll","gdi32.dll","gdiplus.dll","shell32.dll","imageres.dll","uxtheme.dll","dwmapi.dll","comctl32.dll","comdlg32.dll","ole32.dll","d3d11.dll","d3d12.dll","dxgi.dll","opengl32.dll","dsound.dll","winmm.dll","mfplat.dll","avrt.dll","glu32.dll","setupapi.dll","ws2_32.dll","winhttp.dll","wininet.dll","iphlpapi.dll","dnsapi.dll","crypt32.dll","lsasrv.dll","mswsock.dll","wlanapi.dll","dhcpcsvc.dll","rpcrt4.dll","clbcatq.dll","faultrep.dll","profapi.dll","shlwapi.dll","version.dll","cfgmgr32.dll","cabinet.dll","bcrypt.dll","samlib.dll"]'
        implicitWidth: 300
    }

    Controls.CheckBox {
        id: capitalizeCheckBox
        Kirigami.FormData.label: "Capitalize DLL Name:"
        implicitWidth: 300
    }
}
