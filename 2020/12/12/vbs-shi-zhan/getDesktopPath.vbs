Set oApp = CreateObject ("Shell.Application") 
Const DESKTOP = &H10& 
sPathOutputFolder = oApp.Namespace(DESKTOP).Self.Path 
msgbox sPathOutputFolder