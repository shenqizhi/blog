
Set oReg = GetObject("winmgmts:\\.\root\default:StdRegProv")
Const HKLM                            = &H80000002 
Const REG_ARP                         = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" 
key                                   = "Bandizip"


'test = RegReadValue(HKLM, REG_ARP & Key, "DisplayIcon", sValue, "REG_SZ") 'sValue是抓取到的 Key 的Value，返回的是布尔值

test = oReg.GetStringValue(HKLM, REG_ARP & Key, "DisplayIcon", sValue) 
msgbox test
msgbox sValue



'Read the value of a given registry entry 
Function RegReadValue(hDefKey, sSubKeyName, sName, sValue, sType) 
    Dim RetVal 
    Dim arrValues 
     
    Select Case UCase(sType) 
        Case "1","REG_SZ" 
            RetVal = oReg.GetStringValue(hDefKey, sSubKeyName, sName, sValue) '32位，如果RetVal=0，意味成功找到
            If Not RetVal = 0 AND f64 Then RetVal = oReg.GetStringValue(hDefKey, Wow64Key(hDefKey, sSubKeyName), sName, sValue) 'Retval不等于0，意味上一步找不到出错。并且64位系统
        Case "2","REG_EXPAND_SZ" 
            RetVal = oReg.GetExpandedStringValue(hDefKey, sSubKeyName, sName, sValue) 
            If Not RetVal = 0 AND f64 Then RetVal = oReg.GetExpandedStringValue(hDefKey, Wow64Key(hDefKey, sSubKeyName), sName, sValue) 
        Case "7","REG_MULTI_SZ" 
            RetVal = oReg.GetMultiStringValue(hDefKey, sSubKeyName, sName, arrValues) 
            If Not RetVal = 0 AND f64 Then RetVal = oReg.GetMultiStringValue(hDefKey, Wow64Key(hDefKey, sSubKeyName), sName, arrValues) 
            If RetVal = 0 Then sValue = Join(arrValues, chr(34)) 
        Case "4","REG_DWORD" 
            RetVal = oReg.GetDWORDValue(hDefKey, sSubKeyName, sName, sValue) 
            If Not RetVal = 0 AND f64 Then  
                RetVal = oReg.GetDWORDValue(hDefKey, Wow64Key(hDefKey, sSubKeyName), sName, sValue) 
            End If 
        Case "3","REG_BINARY" 
            RetVal = oReg.GetBinaryValue(hDefKey, sSubKeyName, sName, sValue) 
            If Not RetVal = 0 AND f64 Then RetVal = oReg.GetBinaryValue(hDefKey, Wow64Key(hDefKey, sSubKeyName), sName, sValue) 
        Case "11","REG_QWORD" 
            RetVal = oReg.GetQWORDValue(hDefKey, sSubKeyName, sName, sValue) 
            If Not RetVal = 0 AND f64 Then RetVal = oReg.GetQWORDValue(hDefKey, Wow64Key(hDefKey, sSubKeyName), sName, sValue) 
        Case Else 
            RetVal = -1 
    End Select 'sValue 
    RegReadValue = (RetVal = 0) 
End Function 'RegReadValue 

'Return the alternate regkey location on 64bit environment 
Function Wow64Key(hDefKey, sSubKeyName) 
    Dim iPos 
    Dim sKey, sVer 
    Dim fReplaced 
 
    fReplaced = False 
    For Each sVer in dicActiveC2RVersions.Keys 
        sKey = REG_OFFICE & sVer & REG_C2RVIRT_HKLM 
        If InStr(sSubKeyName, sKey) > 0 Then 
            sSubKeyName = Replace(sSubKeyName, sKey, "") 
            fReplaced = True 
            Exit For 
        End If 
    Next 
    Select Case hDefKey 
        Case HKCU 
            If Left(sSubKeyName, 17) = "Software\Classes\" Then 
                Wow64Key = Left(sSubKeyName, 17) & "Wow6432Node\" & Right(sSubKeyName, Len(sSubKeyName) - 17) 
            Else 
                iPos = InStr(sSubKeyName, "\") 
                Wow64Key = Left(sSubKeyName, iPos) & "Wow6432Node\" & Right(sSubKeyName, Len(sSubKeyName) -iPos) 
            End If 
        Case HKLM 
            If Left(sSubKeyName, 17) = "Software\Classes\" Then 
                Wow64Key = Left(sSubKeyName, 17) & "Wow6432Node\" & Right(sSubKeyName, Len(sSubKeyName) - 17) 
            Else 
                iPos = InStr(sSubKeyName, "\") 
                Wow64Key = Left(sSubKeyName, iPos) & "Wow6432Node\" & Right(sSubKeyName, Len(sSubKeyName) -iPos) 
            End If 
        Case Else 
            Wow64Key = "Wow6432Node\" & sSubKeyName 
    End Select 'hDefKey 
    If fReplaced Then 
        sSubKeyName = sKey & sSubKeyName 
        Wow64Key = sKey & Wow64Key 
    End If 
End Function 'Wow64Key 