# winautohide

让窗口在显示器边缘隐藏

日常中我会在屏幕边上藏几个小工具，只要鼠标划过对应边缘即显示窗口并使用，十分便利。

# 使用说明

#### 声明
- 这是 [AutoHotkey V2](http://www.autohotkey.com/) 脚本，使用其 Ahk2Exe 编译生成的.exe，误报毒什么的就自行裁决。
- 如果已经在用 AutoHotkey V2.0 可下载 WinYinCang.ahk 运行，仅 4KB 左右。
- 如果已在用 AutoHotkey V1.1 请看 [hzhbest@winautohide](https://github.com/hzhbest/winautohide) 的版本。
- 感谢名单：
	- [@scavin](https://github.com/scavin) 青蛙宣传了 @hzhbest 的版本我才知道可以这样玩。
	- [@hzhbest](https://github.com/hzhbest)
	- [@BoD](https://github.com/BoD) 

## 启用：

- 在窗口中按快捷键【Ctrl + Win + 方向键】
	- 方向键的作用，如想隐藏在屏幕上边的边缘，就按：Ctrl + Win + ↑方向键  。
	- 如要修改快捷按键，在 WinYinCang.ahk 第 14 行，自行修改。

## 显示 隐藏窗口 的方式有：

- 当鼠标悬停在屏幕边缘时，隐藏的窗口会显示出来。
- 当通过任务栏点击隐藏的窗口时，窗口会显示出来。
- 当使用 Alt+Tab 切换到隐藏的窗口时，窗口会显示出来。

## 恢复窗口（取消功能 使其不再隐藏）的方式有:

- 显示窗口后，再次按快捷键 Ctrl + Win + 方向键，恢复当前窗口。
- 鼠标右点击任务栏托盘图标，选择 还原所有隐藏窗口，恢复所有隐藏窗口。
- 鼠标右点击任务栏托盘图标，选择 退出，恢复显示所有隐藏窗口。

## 兼容性

- 我仅在 win11 使用，应该也兼容win10，其他的自行测试，能用就行
- 多显示器未测试，自行测试。
