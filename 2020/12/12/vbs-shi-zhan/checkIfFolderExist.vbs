On Error resume next 
Set oShell = CreateObject("WScript.Shell") 
Set oFso = CreateObject("Scripting.FileSystemObject")

If Not oFso.FolderExists(sPathOutputFolder) Then  
    oFso.CreateFolder sPathOutputFolder 
    If NOT Err = 0 Then '无法创建则存放在Temp目录下
        sPathOutputFolder = oShell.ExpandEnvironmentStrings("%TEMP%") & "\"  
        Err.Clear 
    End If 
End If 