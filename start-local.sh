#!/bin/bash

# Amadeus System 本地部署启动脚本
# 使用方法: ./start-local.sh

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Amadeus System 本地部署启动脚本${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 检查环境变量文件是否存在
if [ ! -f ".env.development" ]; then
    echo -e "${YELLOW}警告: .env.development 文件不存在${NC}"
    echo "正在创建 .env.development 文件..."
    cat > .env.development << EOF
# 前端开发环境变量配置
VITE_APP_API_BASE_URL=http://localhost:3002
VITE_APP_DEFAULT_USERNAME=user
EOF
    echo -e "${GREEN}已创建 .env.development 文件，请根据需要修改配置${NC}"
fi

if [ ! -f "service/.env" ]; then
    echo -e "${YELLOW}警告: service/.env 文件不存在${NC}"
    echo "正在创建 service/.env 文件..."
    cat > service/.env << EOF
# 后端服务环境变量配置
PORT=3002
WEBRTC_API_URL=http://localhost:8001
EOF
    echo -e "${GREEN}已创建 service/.env 文件，请根据需要修改配置${NC}"
fi

if [ ! -f "service/webrtc/.env" ]; then
    echo -e "${YELLOW}警告: service/webrtc/.env 文件不存在${NC}"
    echo "正在创建 service/webrtc/.env 文件..."
    cat > service/webrtc/.env << EOF
# WebRTC服务环境变量配置
# 请填入你的API密钥
LLM_API_KEY=your_openai_api_key_here
WHISPER_API_KEY=your_whisper_api_key_here
SILICONFLOW_API_KEY=your_siliconflow_api_key_here
SILICONFLOW_VOICE=your_voice_id_here
LLM_BASE_URL=https://api.ephone.ai/v1
WHISPER_BASE_URL=https://amadeus-ai-api-2.zeabur.app/v1
WHISPER_MODEL=whisper-large-v3
AI_MODEL=gpt-4
MEM0_API_KEY=
TIME_LIMIT=600
CONCURRENCY_LIMIT=10
EOF
    echo -e "${RED}已创建 service/webrtc/.env 文件，请务必填入你的API密钥！${NC}"
fi

echo ""
echo -e "${GREEN}环境变量文件检查完成${NC}"
echo ""

# 检查依赖是否已安装
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}前端依赖未安装，正在安装...${NC}"
    npm install --registry=https://registry.npmmirror.com
fi

if [ ! -d "service/node_modules" ]; then
    echo -e "${YELLOW}后端服务依赖未安装，正在安装...${NC}"
    cd service && pnpm install --registry=https://registry.npmmirror.com && cd ..
fi

if [ ! -d "service/webrtc/venv" ]; then
    echo -e "${YELLOW}WebRTC服务Python虚拟环境未创建，正在创建...${NC}"
    cd service/webrtc && python3 -m venv venv && cd ../..
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  启动服务${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}提示: 服务将在不同的终端窗口中启动${NC}"
echo -e "${YELLOW}前端服务: http://localhost:1002${NC}"
echo -e "${YELLOW}后端服务: http://localhost:3002${NC}"
echo -e "${YELLOW}WebRTC服务: http://localhost:8001${NC}"
echo ""

# 创建日志目录
mkdir -p logs

# 启动WebRTC服务
echo -e "${GREEN}[1/3] 启动WebRTC服务...${NC}"
cd service/webrtc
source venv/bin/activate
python server.py > ../../logs/webrtc.log 2>&1 &
WEBRTC_PID=$!
cd ../..
echo "WebRTC服务已启动 (PID: $WEBRTC_PID)"

# 等待WebRTC服务启动
sleep 3

# 启动后端服务
echo -e "${GREEN}[2/3] 启动后端服务...${NC}"
cd service
pnpm dev > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
cd ..
echo "后端服务已启动 (PID: $BACKEND_PID)"

# 等待后端服务启动
sleep 3

# 启动前端服务
echo -e "${GREEN}[3/3] 启动前端服务...${NC}"
npm run dev > logs/frontend.log 2>&1 &
FRONTEND_PID=$!
echo "前端服务已启动 (PID: $FRONTEND_PID)"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  所有服务已启动！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "服务进程ID:"
echo "  WebRTC: $WEBRTC_PID"
echo "  后端:   $BACKEND_PID"
echo "  前端:   $FRONTEND_PID"
echo ""
echo "日志文件位置:"
echo "  WebRTC: logs/webrtc.log"
echo "  后端:   logs/backend.log"
echo "  前端:   logs/frontend.log"
echo ""
echo -e "${YELLOW}要停止所有服务，请运行: ./stop-local.sh${NC}"
echo -e "${YELLOW}或手动kill进程: kill $WEBRTC_PID $BACKEND_PID $FRONTEND_PID${NC}"
echo ""

# 保存PID到文件
echo "$WEBRTC_PID" > logs/webrtc.pid
echo "$BACKEND_PID" > logs/backend.pid
echo "$FRONTEND_PID" > logs/frontend.pid

