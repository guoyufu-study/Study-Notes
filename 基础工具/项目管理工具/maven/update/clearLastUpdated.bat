@echo off

rem for /r %i in (*.lastUpdated) do del %i 用于清理*.lastUpdated文件

rem 这里写你的仓库路径（此批处理文件与repository文件夹同级）
set REPOSITORY_PATH=%~dp0\repository
echo 正在搜索删除...
for /f "delims=" %%i in ('dir /b /s "%REPOSITORY_PATH%\*.lastUpdated"') do (
	del /s /q %%i
)
echo 删除完毕
pause