@echo off

rem for /r %i in (*.lastUpdated) do del %i ��������*.lastUpdated�ļ�

rem ����д��Ĳֿ�·�������������ļ���repository�ļ���ͬ����
set REPOSITORY_PATH=%~dp0\repository
echo ��������ɾ��...
for /f "delims=" %%i in ('dir /b /s "%REPOSITORY_PATH%\*.lastUpdated"') do (
	del /s /q %%i
)
echo ɾ�����
pause