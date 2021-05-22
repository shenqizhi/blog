
On Error Resume Next 
iInstanceCnt = 0 
wscript.sleep 500 

Set oWmiLocal = GetObject("winmgmts:\\.\root\cimv2") 

Set objShell = CreateObject("Wscript.Shell")
strPath = Wscript.ScriptFullName '获取脚本文件全路径 
Set objShell = Nothing

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.GetFile(strPath) '获取此文件对象用于后续文件操作 

fileName = objFSO.GetBaseName(objFile) '获取不含路径的文件名称, 不含后缀
Set objFile = Nothing
Set objFSO = Nothing

msgbox "test"
Set Processes = oWmiLocal.ExecQuery("Select * From Win32_Process") 
For Each Process in Processes 
    If LCase(Mid(Process.Name, 2, 6)) = "script" Then 
        'Process.CommandLine 显示此脚本运行的的完整 cmd 命令
        'CommandLine 不包含UAC字样 
        If InStr(LCase(Process.CommandLine), fileName) > 0 AND NOT InStr(Process.CommandLine, " UAC") > 0 Then iInstanceCnt = iInstanceCnt + 1 
    End If 
Next 'Process
'判断这个脚本是否重复运行
If iInstanceCnt > 1 Then 
    wscript.echo "Another instance of this script is already running." 
    wscript.quit 
End If 