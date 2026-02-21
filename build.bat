@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ==============================================
echo 开始构建项目...
echo ==============================================

echo [1/4] 正在构建锐界幻境文档站项目...
call npm run build
if !errorlevel! neq 0 (
    echo 锐界幻境文档站项目构建失败！
    pause
    exit /b 1
)

echo [2/4] 正在复制锐界幻境文档站项目构建文件...
if not exist ".\build\miragedge.top\" mkdir ".\build\miragedge.top\"
xcopy /E /Y /I ".\.vitepress\dist\*" ".\build\miragedge.top\"
if !errorlevel! gtr 1 (
    echo 锐界幻境文档站文件复制失败！
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