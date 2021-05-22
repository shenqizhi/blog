
' Dim fso,f
' Set fso = CreateObject("Scripting.FileSystemObject")
' f = fso.GetFile(Wscript.scriptfullname).name
' msgbox f '文件名，包括后缀

' Set fso = CreateObject("Scripting.FileSystemObject")
' f = fso.GetFile(Wscript.scriptfullname).path 
' msgbox f '文件路径及文件名，包括后缀


Set objShell = CreateObject("Wscript.Shell")
strPath = Wscript.ScriptFullName '获取脚本文件全路径 
msgbox strPath
Set objShell = Nothing
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.GetFile(strPath) '获取此文件对象用于后续文件操作 
MsgBox objFSO.GetFileName(objFile) '获取不含路径的文件名称,
MsgBox objFSO.GetBaseName(objFile) '获取不含路径的文件名称, 不含后缀
Set objFile = Nothing
Set objFSO = Nothing