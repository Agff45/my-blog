@echo off
:: 设置字符集为 UTF-8，防止终端中文乱码
chcp 65001 >nul

echo ========================================
echo       🚀 开始自动打包并推送博客代码
echo ========================================
echo.

:: 显示有哪些文件被修改了
git status -s
echo.

:: 提示输入提交信息，如果直接按回车，则使用当前时间作为备注
set /p msg="请输入本次更新的备注 (直接按回车默认使用当前时间): "
if "%msg%"=="" (
    set msg=Auto update %date:~0,10% %time:~0,8%
)

echo.
echo [1/3] 正在添加文件到暂存区 (git add) ...
git add .

echo.
echo [2/3] 正在生成提交记录 (git commit) ...
git commit -m "%msg%"

echo.
echo [3/3] 正在推送到 GitHub (git push) ...
git push

echo.
echo ========================================
echo       ✅ 推送成功！Cloudflare 正在构建
echo ========================================
echo.
pause