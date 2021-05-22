
'该脚本作为演示功能使用，可以执行，但是代码不全。

Set oReg = GetObject("winmgmts:\\.\root\default:StdRegProv")
Const HKEY_LOCAL_MACHINE              = &H80000002
hDefKey = HKEY_LOCAL_MACHINE 

sSubKeyName="SOFTWARE\Microsoft" 
Const KEY_QUERY_VALUE                 = &H0001 
Const KEY_SET_VALUE                   = &H0002 
Const KEY_CREATE_SUB_KEY              = &H0004 
Const DELETE                          = &H00010000 

RegCheckAccess hDefKey, sSubKeyName, KEY_QUERY_VALUE


Function RegCheckAccess(hDefKey, sSubKeyName, lAccPermLevel) 
    Dim RetVal   
    RetVal = RegKeyExists(hDefKey, sSubKeyName) 
    
    RetVal = oReg.CheckAccess(hDefKey, sSubKeyName, lAccPermLevel) 
    
    If Not RetVal = 0 AND f64 Then RetVal = oReg.CheckAccess(hDefKey, Wow64Key(hDefKey, sSubKeyName), lAccPermLevel) 
    RegCheckAccess = (RetVal = 0) '先运行括号内的布尔运算，再赋值给RegCheckAccess
End Function 'RegReadValue 


Function RegKeyExists(hDefKey, sSubKeyName) 
    Dim arrKeys 
    'Enumkey:获取subkeys里面所有的key然后将结果生成一个数组arrkeys.
    'Enumkey 返回0，说明存在该subkey。返回其他数字，则不存在
    '下面这种写法，执行布尔判断。（有点反直觉）
    RegKeyExists = (oReg.EnumKey(hDefKey, sSubKeyName, arrKeys) = 0)  
End Function 