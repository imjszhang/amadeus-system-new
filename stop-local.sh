#!/bin/bash

# Amadeus System 本地部署停止脚本
# 使用方法: ./stop-local.sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  停止 Amadeus System 服务${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 从PID文件读取进程ID并停止
if [ -f "logs/webrtc.pid" ]; then
    WEBRTC_PID=$(cat logs/webrtc.pid)
    if ps -p $WEBRTC_PID > /dev/null 2>&1; then
        kill $WEBRTC_PID
        echo -e "${GREEN}已停止WebRTC服务 (PID: $WEBRTC_PID)${NC}"
    else
        echo -e "${YELLOW}WebRTC服务进程不存在${NC}"
    fi
    rm -f logs/webrtc.pid
fi

if [ -f "logs/backend.pid" ]; then
    BACKEND_PID=$(cat logs/backend.pid)
    if ps -p $BACKEND_PID > /dev/null 2>&1; then
        kill $BACKEND_PID
        echo -e "${GREEN}已停止后端服务 (PID: $BACKEND_PID)${NC}"
    else
        echo -e "${YELLOW}后端服务进程不存在${NC}"
    fi
    rm -f logs/backend.pid
fi

if [ -f "logs/frontend.pid" ]; then
    FRONTEND_PID=$(cat logs/frontend.pid)
    if ps -p $FRONTEND_PID > /dev/null 2>&1; then
        kill $FRONTEND_PID
        echo -e "${GREEN}已停止前端服务 (PID: $FRONTEND_PID)${NC}"
    else
        echo -e "${YELLOW}前端服务进程不存在${NC}"
    fi
    rm -f logs/frontend.pid
fi

# 尝试通过端口查找并停止进程
echo ""
echo -e "${YELLOW}检查是否有残留进程...${NC}"

# 检查端口8001 (WebRTC)
if lsof -ti:8001 > /dev/null 2>&1; then
    lsof -ti:8001 | xargs kill -9
    echo -e "${GREEN}已清理端口8001的进程${NC}"
fi

# 检查端口3002 (后端)
if lsof -ti:3002 > /dev/null 2>&1; then
    lsof -ti:3002 | xargs kill -9
    echo -e "${GREEN}已清理端口3002的进程${NC}"
fi

# 检查端口1002 (前端)
if lsof -ti:1002 > /dev/null 2>&1; then
    lsof -ti:1002 | xargs kill -9
    echo -e "${GREEN}已清理端口1002的进程${NC}"
fi

echo ""
echo -e "${GREEN}所有服务已停止${NC}"

