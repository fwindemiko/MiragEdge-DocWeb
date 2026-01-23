@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ==============================================
echo 开始构建项目...
echo ==============================================

:: 第一步：构建主项目并复制到指定目录
echo [1/4] 正在构建锐界幻境文档站项目...
call npm run build
if !errorlevel! neq 0 (
    echo 锐界幻境文档站项目构建失败！
    pause
    exit /b 1
)

echo [2/4] 正在复制锐界幻境文档站项目构建文件...
:: 如果目标目录不存在，先创建
if not exist ".\build\miragedge.top\" mkdir ".\build\miragedge.top\"
xcopy /E /Y /I ".\.vitepress\dist\*" ".\build\miragedge.top\"
if !errorlevel! gtr 1 (
    echo 锐界幻境文档站文件复制失败！
    pause
    exit /b 1
)

:: 第二步：进入子目录构建并复制文件
echo [3/4] 进入fwindemiko目录并构建子项目...
cd /d "fwindemiko"
if !errorlevel! neq 0 (
    echo 无法进入fwindemiko目录！
    pause
    exit /b 1
)

call npm run build
if !errorlevel! neq 0 (
    echo 狐风轩汐个人文档项目构建失败！
    pause
    exit /b 1
)

echo [4/4] 正在复制狐风轩汐个人文档项目构建文件...
:: 如果目标目录不存在，先创建
if not exist "..\build\f.windemiko.top\" mkdir "..\build\f.windemiko.top\"
xcopy /E /Y /I ".\.vitepress\dist\*" "..\build\f.windemiko.top\"
if !errorlevel! gtr 1 (
    echo 狐风轩汐个人文档文件复制失败！
    pause
    exit /b 1
)

echo ==============================================
echo 所有项目构建并复制完成！
echo ==============================================

:: 返回到原始目录
cd /d ".."

echo 构建文件位置：
echo - 锐界幻境文档站：.\build\miragedge.top\
echo - 狐风轩汐个人文档：.\build\f.windemiko.top\

pause
endlocal