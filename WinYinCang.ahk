#Requires AutoHotkey v2.0
#SingleInstance Ignore

; 全局变量
global autohideWindows := Map()
global previousActiveWindow := 0
global lastInputTime := 0
global currentActiveWindow := 0

; 图标设置（如果有图标文件的话）
if FileExist(A_ScriptDir . "\winautohide.ico")
    TraySetIcon(A_ScriptDir . "\winautohide.ico")

; 热键绑定
Hotkey("^#Right", (*) => ToggleWindow("right"))
Hotkey("^#Left",  (*) => ToggleWindow("left"))
Hotkey("^#Up",    (*) => ToggleWindow("up"))
Hotkey("^#Down",  (*) => ToggleWindow("down"))

; 定时器初始化
SetTimer(CheckWindowState, 100)

; 托盘菜单初始化
A_TrayMenu.Delete()
A_TrayMenu.Add("关于...", MenuAbout)
A_TrayMenu.Add("还原所有隐藏的窗口", MenuUnautohideAll)
A_TrayMenu.Add("退出", MenuExit)
A_TrayMenu.Default := "关于..."

; 菜单函数
MenuAbout(*) {
    MsgBox("Fewk winautohide.`n`nThis program and its source are in the public domain.", "About", 0x40)
}

MenuUnautohideAll(*) {
    for winId in autohideWindows {
        Unautohide(winId)
    }
}

MenuExit(*) {
    MenuUnautohideAll()
    ExitApp()
}

; 主要函数
CheckWindowState() {
    global currentActiveWindow, lastInputTime
    
    ; 获取当前活动窗口和鼠标位置
    activeWinId := WinExist("A")
    MouseGetPos(&mouseX, &mouseY, &mouseWinId)
    
    ; 检查是否切换了窗口
    if (activeWinId != currentActiveWindow) {
        ; 如果新的活动窗口是自动隐藏的，则显示它
        if autohideWindows.Has(activeWinId) {
            ShowWindow(activeWinId)
        } else {
            ; 如果之前的活动窗口是自动隐藏的，则隐藏它
            if autohideWindows.Has(currentActiveWindow) {
                HideWindow(currentActiveWindow)
            }
        }
        currentActiveWindow := activeWinId
        lastInputTime := A_TickCount
    }
    
    ; 检查鼠标是否在自动隐藏的窗口上
    if autohideWindows.Has(mouseWinId) {
        info := autohideWindows[mouseWinId]
        if info.isHidden {
            ShowWindow(mouseWinId)
        }
        lastInputTime := A_TickCount
    } else {
        ; 检查是否需要隐藏窗口
        for winId, info in autohideWindows {
            if !info.isHidden && winId != activeWinId {
                if !IsMouseOverWindow(mouseX, mouseY, info) {
                    if (A_TickCount - lastInputTime > 300) { ; 0.3秒无操作后隐藏
                        HideWindow(winId)
                    }
                }
            }
        }
    }
}

ToggleWindow(mode) {
    winId := WinGetID("A")
    if !winId {
        return
    }
    if autohideWindows.Has(winId)
        Unautohide(winId)
    else
        Autohide(winId, mode)
}

Autohide(winId, mode) {
    if !WinExist("ahk_id " . winId) {
        return
    }
    
    WinGetPos(&x, &y, &width, &height, "ahk_id " . winId)
    info := {orig: {x: x, y: y}, width: width, height: height, mode: mode}

    if (mode == "right") {
        info.showing := {x: A_ScreenWidth - width, y: y}
        info.hidden  := {x: A_ScreenWidth - 1, y: y}
    } else if (mode == "left") {
        info.showing := {x: 0, y: y}
        info.hidden  := {x: -width + 1, y: y}
    } else if (mode == "up") {
        info.showing := {x: x, y: 0}
        info.hidden  := {x: x, y: -height + 1}
    } else { ; down
        info.showing := {x: x, y: A_ScreenHeight - height}
        info.hidden  := {x: x, y: A_ScreenHeight - 1}
    }

    info.isHidden := false
    autohideWindows[winId] := info

    WorkWindow(winId)
    WinMove(info.showing.x, info.showing.y,,, "ahk_id " . winId)
}

Unautohide(winId) {
    if autohideWindows.Has(winId) {
        info := autohideWindows[winId]
        UnworkWindow(winId)
        WinMove(info.orig.x, info.orig.y,,, "ahk_id " . winId)
        autohideWindows.Delete(winId)
    }
}

WorkWindow(winId) {
    WinSetAlwaysOnTop(true, "ahk_id " . winId)
}

UnworkWindow(winId) {
    WinSetAlwaysOnTop(false, "ahk_id " . winId)
}

IsMouseOverWindow(mouseX, mouseY, info) {
    return (mouseX >= info.showing.x && mouseX <= info.showing.x + info.width && mouseY >= info.showing.y && mouseY <= info.showing.y + info.height)
}

ShowWindow(winId) {
    info := autohideWindows[winId]
    WinMove(info.showing.x, info.showing.y,,, "ahk_id " . winId)
    info.isHidden := false
    WinActivate("ahk_id " . winId)
}

HideWindow(winId) {
    info := autohideWindows[winId]
    WinMove(info.hidden.x, info.hidden.y,,, "ahk_id " . winId)
    info.isHidden := true
}