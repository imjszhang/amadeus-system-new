# Amadeus System 本地部署指南

本文档将指导你在本地环境中部署和运行 Amadeus System 项目。

## 📋 前置要求

在开始部署之前，请确保你的系统已安装以下软件：

- **Node.js**: ≥ 18.0.0
- **Python**: ≥ 3.8
- **pnpm**: 推荐使用 pnpm 作为包管理器（可通过 `npm install -g pnpm` 安装）
- **Git**: 用于克隆代码仓库

## 🚀 快速开始

### 方法一：使用自动化脚本（推荐）

1. **克隆项目**
   ```bash
   git clone https://github.com/ai-poet/amadeus-system-new.git
   cd amadeus-system-new
   ```

2. **运行启动脚本**
   ```bash
   ./start-local.sh
   ```

   脚本会自动：
   - 检查并创建必要的环境变量文件
   - 安装所有依赖（如果尚未安装）
   - 启动所有服务

3. **访问应用**
   - 前端界面: http://localhost:1002
   - 后端API: http://localhost:3002
   - WebRTC服务: http://localhost:8001

4. **停止服务**
   ```bash
   ./stop-local.sh
   ```

### 方法二：手动启动

#### 步骤 1: 安装依赖

**前端依赖**
```bash
npm install --registry=https://registry.npmmirror.com
```

**后端服务依赖**
```bash
cd service
pnpm install --registry=https://registry.npmmirror.com
cd ..
```

**WebRTC服务Python依赖**
```bash
cd service/webrtc
python3 -m venv venv
source venv/bin/activate  # macOS/Linux
# 或 venv\Scripts\activate  # Windows
pip install -r requirements.txt
cd ../..
```

#### 步骤 2: 配置环境变量

**前端环境变量** (`.env.development`)
```env
VITE_APP_API_BASE_URL=http://localhost:3002
VITE_APP_DEFAULT_USERNAME=user
```

**后端服务环境变量** (`service/.env`)
```env
PORT=3002
WEBRTC_API_URL=http://localhost:8001
```

**WebRTC服务环境变量** (`service/webrtc/.env`)
```env
# 必需配置
LLM_API_KEY=your_openai_api_key_here
WHISPER_API_KEY=your_whisper_api_key_here
SILICONFLOW_API_KEY=your_siliconflow_api_key_here
SILICONFLOW_VOICE=your_voice_id_here

# 可选配置（有默认值）
LLM_BASE_URL=https://api.ephone.ai/v1
WHISPER_BASE_URL=https://amadeus-ai-api-2.zeabur.app/v1
WHISPER_MODEL=whisper-large-v3
AI_MODEL=gpt-4
MEM0_API_KEY=
TIME_LIMIT=600
CONCURRENCY_LIMIT=10
```

#### 步骤 3: 启动服务

打开三个终端窗口，分别运行：

**终端 1: 启动WebRTC服务**
```bash
cd service/webrtc
source venv/bin/activate
python server.py
```

**终端 2: 启动后端服务**
```bash
cd service
pnpm dev
```

**终端 3: 启动前端服务**
```bash
npm run dev
```

## 📝 环境变量说明

### 前端环境变量

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `VITE_APP_API_BASE_URL` | 后端API服务地址 | `http://localhost:3002` |
| `VITE_APP_DEFAULT_USERNAME` | 默认用户名 | `user` |

### 后端服务环境变量

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `PORT` | 后端服务端口 | `3002` |
| `WEBRTC_API_URL` | WebRTC服务API地址 | `http://localhost:8001` |

### WebRTC服务环境变量

| 变量名 | 说明 | 是否必需 |
|--------|------|----------|
| `LLM_API_KEY` | OpenAI或兼容API的密钥 | ✅ 必需 |
| `WHISPER_API_KEY` | Whisper API密钥 | ✅ 必需 |
| `SILICONFLOW_API_KEY` | 硅基流动API密钥 | ✅ 必需 |
| `SILICONFLOW_VOICE` | 硅基流动语音ID | ✅ 必需 |
| `LLM_BASE_URL` | 大语言模型API基础URL | 可选 |
| `WHISPER_BASE_URL` | Whisper API基础URL | 可选 |
| `WHISPER_MODEL` | Whisper模型版本 | 可选 |
| `AI_MODEL` | 大语言模型型号 | 可选 |
| `MEM0_API_KEY` | MEM0记忆服务API密钥 | 可选 |
| `TIME_LIMIT` | WebRTC流最大时间限制(秒) | 可选 |
| `CONCURRENCY_LIMIT` | 最大并发连接数 | 可选 |

## 🔧 常见问题

### 1. 端口被占用

如果遇到端口被占用的问题，可以：

- 修改 `.env.development` 中的前端端口（需要修改 `vite.config.ts`）
- 修改 `service/.env` 中的后端端口
- 修改 `service/webrtc/server.py` 中的WebRTC端口

### 2. Python依赖安装失败

如果Python依赖安装失败，可以尝试：

```bash
# 使用国内镜像源
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 或升级pip
pip install --upgrade pip setuptools wheel
```

### 3. Node.js版本不兼容

如果遇到Node.js版本问题：

- 使用 nvm 管理Node.js版本
- 确保Node.js版本 ≥ 18.0.0

### 4. pnpm未安装

```bash
npm install -g pnpm
```

## 📊 服务端口说明

| 服务 | 端口 | 说明 |
|------|------|------|
| 前端开发服务器 | 1002 | Vite开发服务器 |
| 后端API服务 | 3002 | Node.js后端服务 |
| WebRTC服务 | 8001 | Python WebRTC服务 |

## 🐛 调试

### 查看日志

如果使用启动脚本，日志文件位于 `logs/` 目录：

- `logs/frontend.log` - 前端服务日志
- `logs/backend.log` - 后端服务日志
- `logs/webrtc.log` - WebRTC服务日志

### 手动查看进程

```bash
# 查看端口占用
lsof -i :1002
lsof -i :3002
lsof -i :8001

# 查看进程
ps aux | grep node
ps aux | grep python
```

## 📚 更多信息

- 项目文档: [Amadeus System 文档中心](https://docs.amadeus-web.top)
- GitHub仓库: https://github.com/ai-poet/amadeus-system-new

## 🙏 获取帮助

如果遇到问题，可以：

1. 查看项目的 [Issues](https://github.com/ai-poet/amadeus-system-new/issues)
2. 提交新的 Issue 描述问题
3. 查看项目文档获取更多信息

---

**祝部署顺利！EL PSY CONGROO~**

