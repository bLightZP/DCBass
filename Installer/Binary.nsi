; NSIS 3 installer for the combined Win32 and Win64 package.

Unicode true
RequestExecutionLevel admin
SetCompressor lzma

!include "MUI.nsh"
!include "LogicLib.nsh"
!include "Sections.nsh"
!include "x64.nsh"

!define VER_FILE "1.5.2.1"
!define VER_PRODUCT "DC-Bass Source Mod"
!define PAYLOAD_DIR "..\Build\Dual"
!define PRODUCT_KEY "Software\DSP-worx\${VER_PRODUCT}"
!define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VER_PRODUCT}"
!define FILTER_CLSID "{ABE7B1D9-4B3E-4ACD-A0D1-92611D3A4492}"
!define SETTINGS_CLSID "{DFD031D4-4780-44E7-A5F5-951D672FC93A}"
!define ABOUT_CLSID "{7E15A6DE-B1F1-4E1F-8448-F5A06E179208}"

Name "${VER_PRODUCT} ${VER_FILE}"
OutFile "DCBassSourceMod_${VER_FILE}.exe"
InstallDir "$PROGRAMFILES\DSP-worx\${VER_PRODUCT}"
InstallDirRegKey HKCU "${PRODUCT_KEY}" ""

!define MUI_ABORTWARNING
!define MUI_UI "${NSISDIR}\Contrib\UIs\modern.exe"
!define MUI_HEADERBITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "License.rtf"
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE ValidateComponents
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Var Regsvr32
Var Regsvr64

!macro FindRegsvr32Tools
  StrCpy $Regsvr32 "$SYSDIR\regsvr32.exe"
  StrCpy $Regsvr64 ""
  ${If} ${RunningX64}
    StrCpy $Regsvr32 "$WINDIR\SysWOW64\regsvr32.exe"
  ${EndIf}
  ${If} ${IsNativeAMD64}
    ; The NSIS installer runs as x86. Sysnative bypasses WOW64 redirection.
    StrCpy $Regsvr64 "$WINDIR\Sysnative\regsvr32.exe"
  ${EndIf}
!macroend

!macro RunRegistration Tool Flag Filter Operation
  DetailPrint "${Operation} $INSTDIR\${Filter}"
  ClearErrors
  ExecWait '"${Tool}" /s ${Flag} "$INSTDIR\${Filter}"' $0
  ${If} ${Errors}
    StrCpy $0 "could not start regsvr32"
  ${EndIf}
  ${If} $0 != "0"
    DetailPrint "${Operation} ${Filter} failed ($0)."
    MessageBox MB_OK|MB_ICONSTOP "${Operation} ${Filter} failed ($0). Close any media players and try again." /SD IDOK
    SetErrorLevel 1
    Abort
  ${EndIf}
!macroend

!macro UnregisterInstalledFilter View Tool Filter
  SetRegView ${View}
  ReadRegStr $1 HKCR "CLSID\${FILTER_CLSID}\InprocServer32" ""
  ReadRegStr $2 HKCR "CLSID\${SETTINGS_CLSID}\InprocServer32" ""
  ReadRegStr $3 HKCR "CLSID\${ABOUT_CLSID}\InprocServer32" ""
  SetRegView 32
  ${If} $1 == "$INSTDIR\${Filter}"
  ${OrIf} $2 == "$INSTDIR\${Filter}"
  ${OrIf} $3 == "$INSTDIR\${Filter}"
    !insertmacro RunRegistration ${Tool} "/u" "${Filter}" "Unregistering"
  ${EndIf}
!macroend

!macro PayloadFile Mode SourceRoot FileName
  !if "${Mode}" == "install"
    File "${SourceRoot}\${FileName}"
  !else
    Delete "$INSTDIR\${FileName}"
  !endif
!macroend

!macro PayloadShared Mode
  !if "${Mode}" == "install"
    SetOverwrite off
  !endif
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "Formats.ini"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "Formats_LAV.ini"
  !if "${Mode}" == "install"
    SetOverwrite on
  !endif
  !insertmacro PayloadFile "${Mode}" ".." "License.txt"
  !insertmacro PayloadFile "${Mode}" ".." "ReadMe.txt"
!macroend

!macro PayloadWin32 Mode
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "bass.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "bass_aac.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "bass_alac.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "bass_ape.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "bass_mpc.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "bass_ofr.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "bass_tak.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "bass_tta.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "basscd.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "bassflac.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "bassopus.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "basswv.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "OptimFROG.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "tak_deco_lib.dll"
  !insertmacro PayloadFile "${Mode}" "..\Binary" "Register.bat"
  !insertmacro PayloadFile "${Mode}" "..\Binary" "Unregister.bat"
!macroend

!macro PayloadBothHelpers Mode
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "Register-Both.cmd"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "Unregister-Both.cmd"
!macroend

!macro PayloadWin64 Mode
  !insertmacro PayloadFile "${Mode}" "." "Register-Win64.cmd"
  !insertmacro PayloadFile "${Mode}" "." "Unregister-Win64.cmd"
  !if "${Mode}" == "install"
    SetOutPath "$INSTDIR\x64"
  !endif
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\bass.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\bass_aac.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\bass_mpc.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\bass_ofr.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\bass_tta.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\bassalac.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\bassape.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\basscd.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\bassflac.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\bassopus.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\basswv.dll"
  !insertmacro PayloadFile "${Mode}" "${PAYLOAD_DIR}" "x64\OptimFROG.dll"
  !if "${Mode}" == "install"
    SetOutPath "$INSTDIR"
  !endif
!macroend

!macro CheckInstallFiles
  ${If} ${Errors}
    MessageBox MB_OK|MB_ICONSTOP "Setup could not write all files. Close any media players and run setup again." /SD IDOK
    SetErrorLevel 1
    Abort
  ${EndIf}
!macroend

!macro CheckRemovalFiles
  ${If} ${Errors}
    MessageBox MB_OK|MB_ICONSTOP "Some installed files could not be removed. Close any media players and try again." /SD IDOK
    SetErrorLevel 1
    Abort
  ${EndIf}
!macroend

!macro RemoveFilterFiles Payload Filter
  ClearErrors
  !insertmacro ${Payload} "uninstall"
  !insertmacro CheckRemovalFiles
  Delete "$INSTDIR\${Filter}"
  !insertmacro CheckRemovalFiles
!macroend

Section "-Shared"
  Call ValidateComponents
  ClearErrors
  SetOutPath "$INSTDIR"
  !insertmacro PayloadShared "install"
  !insertmacro CheckInstallFiles
SectionEnd

Section "32-bit DirectShow filter (x86)" SecWin32
  ClearErrors
  File "${PAYLOAD_DIR}\DCBassSourceMod.ax"
  !insertmacro PayloadWin32 "install"
  !insertmacro CheckInstallFiles
SectionEnd

Section "64-bit DirectShow filter (x64)" SecWin64
  ClearErrors
  File "${PAYLOAD_DIR}\DCBassSourceMod64.ax"
  !insertmacro PayloadWin64 "install"
  !insertmacro CheckInstallFiles
SectionEnd

Section "-Register"
  ; Keep a working uninstaller available if either registration fails.
  ClearErrors
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  !insertmacro CheckInstallFiles

  ; Remove a previously installed build if the user cleared its checkbox.
  ${IfNot} ${SectionIsSelected} ${SecWin32}
  ${AndIf} ${FileExists} "$INSTDIR\DCBassSourceMod.ax"
    !insertmacro UnregisterInstalledFilter 32 $Regsvr32 "DCBassSourceMod.ax"
    !insertmacro RemoveFilterFiles PayloadWin32 "DCBassSourceMod.ax"
  ${EndIf}
  ${IfNot} ${SectionIsSelected} ${SecWin64}
  ${AndIf} ${FileExists} "$INSTDIR\DCBassSourceMod64.ax"
    ${If} $Regsvr64 != ""
      !insertmacro UnregisterInstalledFilter 64 $Regsvr64 "DCBassSourceMod64.ax"
    ${EndIf}
    !insertmacro RemoveFilterFiles PayloadWin64 "DCBassSourceMod64.ax"
    RMDir "$INSTDIR\x64"
  ${EndIf}

  ClearErrors
  ${If} ${SectionIsSelected} ${SecWin32}
  ${AndIf} ${SectionIsSelected} ${SecWin64}
    !insertmacro PayloadBothHelpers "install"
    !insertmacro CheckInstallFiles
  ${Else}
    !insertmacro PayloadBothHelpers "uninstall"
    !insertmacro CheckRemovalFiles
  ${EndIf}

  WriteRegStr HKCU "${PRODUCT_KEY}" "" "$INSTDIR"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "DisplayName" "${VER_PRODUCT} ${VER_FILE}"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "NoModify" 1
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "NoRepair" 1

  ${If} ${SectionIsSelected} ${SecWin32}
    !insertmacro RunRegistration $Regsvr32 "" "DCBassSourceMod.ax" "Registering"
  ${EndIf}
  ${If} ${SectionIsSelected} ${SecWin64}
    !insertmacro RunRegistration $Regsvr64 "" "DCBassSourceMod64.ax" "Registering"
  ${EndIf}
SectionEnd

Function .onInit
  !insertmacro FindRegsvr32Tools
  ${If} $Regsvr64 == ""
    !insertmacro UnselectSection ${SecWin64}
    SectionSetText ${SecWin64} ""
    !insertmacro SetSectionFlag ${SecWin32} ${SF_RO}
  ${EndIf}
FunctionEnd

Function ValidateComponents
  ${IfNot} ${SectionIsSelected} ${SecWin32}
  ${AndIfNot} ${SectionIsSelected} ${SecWin64}
    ${If} ${Silent}
      SetErrorLevel 1
    ${EndIf}
    MessageBox MB_OK|MB_ICONEXCLAMATION "Select at least one DirectShow filter to continue." /SD IDOK
    Abort
  ${EndIf}
FunctionEnd

LangString DESC_SecWin32 ${LANG_ENGLISH} "Installs the filter for 32-bit DirectShow players. Includes TAK support."
LangString DESC_SecWin64 ${LANG_ENGLISH} "Installs the filter for 64-bit DirectShow players. Requires x64 Windows."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecWin32} $(DESC_SecWin32)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecWin64} $(DESC_SecWin64)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section "Uninstall"
  !insertmacro FindRegsvr32Tools
  !insertmacro UnregisterInstalledFilter 32 $Regsvr32 "DCBassSourceMod.ax"
  ${If} $Regsvr64 != ""
    !insertmacro UnregisterInstalledFilter 64 $Regsvr64 "DCBassSourceMod64.ax"
  ${EndIf}

  SetOutPath "$TEMP"
  !insertmacro RemoveFilterFiles PayloadWin64 "DCBassSourceMod64.ax"
  !insertmacro RemoveFilterFiles PayloadWin32 "DCBassSourceMod.ax"
  ClearErrors
  !insertmacro PayloadBothHelpers "uninstall"
  !insertmacro PayloadShared "uninstall"
  !insertmacro CheckRemovalFiles

  ReadRegStr $0 HKLM "${UNINSTALL_KEY}" "UninstallString"
  ${If} $0 == '"$INSTDIR\Uninstall.exe"'
    DeleteRegKey HKLM "${UNINSTALL_KEY}"
  ${EndIf}
  ReadRegStr $0 HKCU "${PRODUCT_KEY}" ""
  ${If} $0 == "$INSTDIR"
    DeleteRegValue HKCU "${PRODUCT_KEY}" ""
  ${EndIf}
  DeleteRegKey /ifempty HKCU "${PRODUCT_KEY}"
  DeleteRegKey /ifempty HKCU "Software\DSP-worx"

  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR\x64"
  RMDir "$INSTDIR"
SectionEnd
