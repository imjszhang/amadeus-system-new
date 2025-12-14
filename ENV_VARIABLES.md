# 环境变量配置分析文档

本文档详细分析了 Amadeus System 项目中所有环境变量的必填项和可选配置。

## 📋 目录

- [前端环境变量 (.env.development)](#前端环境变量-envdevelopment)
- [后端服务环境变量 (service/.env)](#后端服务环境变量-serviceenv)
- [WebRTC服务环境变量 (service/webrtc/.env)](#webrtc服务环境变量-servicewebrtcenv)
- [必填项清单](#必填项清单)
- [推荐配置](#推荐配置)
- [注意事项](#注意事项)

---

## 前端环境变量 (.env.development)

| 变量名 | 是否必需 | 说明 | 默认值/影响 |
|--------|---------|------|------------|
| `VITE_APP_API_BASE_URL` | ✅ **必需** | 后端API服务地址，用于Vite代理配置 | 无默认值，缺失会导致API请求失败 |
| `VITE_APP_DEFAULT_USERNAME` | ⚠️ **可选** | 默认用户名，用于登录界面预填充 | 默认值为空字符串 `''` |

### 代码依据

- `vite.config.ts:19` - 用于配置代理目标
- `src/components/LoginOverlay/index.tsx:12` - 有默认值处理

### 配置示例

```env
VITE_APP_API_BASE_URL=http://localhost:3002
VITE_APP_DEFAULT_USERNAME=user
```

---

## 后端服务环境变量 (service/.env)

| 变量名 | 是否必需 | 说明 | 默认值/影响 |
|--------|---------|------|------------|
| `WEBRTC_API_URL` | ✅ **必需** | WebRTC服务API地址，用于代理转发 | 无默认值，缺失会导致代理失败 |
| `PORT` | ⚠️ **可选** | 后端服务端口 | 默认值 `3002` |

### 代码依据

- `service/src/index.ts:14` - 直接使用，无默认值检查
- `service/src/index.ts:94` - PORT有默认值 `3002`

### 配置示例

```env
PORT=3002
WEBRTC_API_URL=http://localhost:8001
```

---

## WebRTC服务环境变量 (service/webrtc/.env)

| 变量名 | 是否必需 | 说明 | 默认值/影响 |
|--------|---------|------|------------|
| `LLM_API_KEY` | ✅ **必需** | OpenAI或兼容API密钥，用于LLM和翻译 | 无默认值，缺失会导致LLM和翻译功能失败 |
| `WHISPER_API_KEY` | ✅ **必需** | Whisper API密钥，用于语音识别 | 无默认值，缺失会导致语音识别失败 |
| `WHISPER_BASE_URL` | ✅ **必需** | Whisper API基础URL | 有默认值但代码中会检查，如果为空会失败 |
| `SILICONFLOW_API_KEY` | ✅ **必需** | 硅基流动API密钥，用于语音合成 | 无默认值，缺失会导致语音合成失败 |
| `SILICONFLOW_VOICE` | ⚠️ **可选** | 硅基流动语音ID | 有默认值 `"speech:siliconflow-kurisu:clzv7bjkm041fufyct2z0setm:mphrsbbmvrjfophbsted"` |
| `LLM_BASE_URL` | ⚠️ **可选** | 大语言模型API基础URL | 默认值 `"https://api.ephone.ai/v1"` |
| `WHISPER_MODEL` | ⚠️ **可选** | Whisper模型版本 | 默认值 `"whisper-large-v3"` |
| `AI_MODEL` | ⚠️ **可选** | 大语言模型型号 | 默认值 `"claude-3-5-sonnet-20241022"` 或 `"gpt-4o-mini"` |
| `MEM0_API_KEY` | ⚠️ **可选** | MEM0记忆服务API密钥 | 默认值为空字符串，仅在使用记忆功能时需要 |
| `TIME_LIMIT` | ⚠️ **可选** | WebRTC流最大时间限制(秒) | 默认值 `600` |
| `CONCURRENCY_LIMIT` | ⚠️ **可选** | 最大并发连接数 | 默认值 `10` |

### 代码依据

- `service/webrtc/stt/transcribe.py:41-42` - 检查 `whisper_api_key` 和 `whisper_base_url`，如果为空会返回空字符串
- `service/webrtc/tts/speech.py:48-49` - 检查 `LLM_API_KEY`，如果为空会记录错误
- `service/webrtc/tts/speech.py:111-112` - 检查 `api_key` (SILICONFLOW_API_KEY)，如果为空会记录错误并返回

### 配置示例

```env
# 必需项
LLM_API_KEY=your_openai_api_key_here
WHISPER_API_KEY=your_whisper_api_key_here
WHISPER_BASE_URL=https://amadeus-ai-api-2.zeabur.app/v1
SILICONFLOW_API_KEY=your_siliconflow_api_key_here

# 推荐配置（有默认值但建议明确设置）
SILICONFLOW_VOICE=speech:siliconflow-kurisu:clzv7bjkm041fufyct2z0setm:mphrsbbmvrjfophbsted
LLM_BASE_URL=https://api.ephone.ai/v1
WHISPER_MODEL=whisper-large-v3
AI_MODEL=gpt-4o-mini

# 可选配置
MEM0_API_KEY=
TIME_LIMIT=600
CONCURRENCY_LIMIT=10
```

---

## 必填项清单

### 最小配置（必需项）

#### `.env.development`
```env
VITE_APP_API_BASE_URL=http://localhost:3002
```

#### `service/.env`
```env
WEBRTC_API_URL=http://localhost:8001
```

#### `service/webrtc/.env`
```env
LLM_API_KEY=your_openai_api_key_here
WHISPER_API_KEY=your_whisper_api_key_here
WHISPER_BASE_URL=https://amadeus-ai-api-2.zeabur.app/v1
SILICONFLOW_API_KEY=your_siliconflow_api_key_here
```

---

## 推荐配置

### 完整配置示例

#### `.env.development`
```env
# 后端API服务地址
VITE_APP_API_BASE_URL=http://localhost:3002

# 默认用户名（可选）
VITE_APP_DEFAULT_USERNAME=user
```

#### `service/.env`
```env
# 后端服务端口（可选，默认3002）
PORT=3002

# WebRTC服务API地址（必需）
WEBRTC_API_URL=http://localhost:8001
```

#### `service/webrtc/.env`
```env
# ========== 必需配置 ==========
# OpenAI或兼容API的密钥，用于大语言模型服务
LLM_API_KEY=your_openai_api_key_here

# Whisper API密钥，用于语音识别服务
WHISPER_API_KEY=your_whisper_api_key_here

# Whisper API的基础URL
WHISPER_BASE_URL=https://amadeus-ai-api-2.zeabur.app/v1

# 硅基流动API密钥，用于语音合成服务
SILICONFLOW_API_KEY=your_siliconflow_api_key_here

# ========== 推荐配置（有默认值但建议明确设置）==========
# 硅基流动自定义的语音ID
SILICONFLOW_VOICE=speech:siliconflow-kurisu:clzv7bjkm041fufyct2z0setm:mphrsbbmvrjfophbsted

# 大语言模型API的基础URL
LLM_BASE_URL=https://api.ephone.ai/v1

# 使用的Whisper模型版本
WHISPER_MODEL=whisper-large-v3

# 使用的大语言模型型号
AI_MODEL=gpt-4o-mini

# ========== 可选配置 ==========
# MEM0记忆服务的API密钥（仅在使用记忆功能时需要）
MEM0_API_KEY=

# WebRTC流的最大时间限制(秒)
TIME_LIMIT=600

# 最大并发连接数
CONCURRENCY_LIMIT=10
```

---

## 注意事项

### ⚠️ 重要提示

1. **`WHISPER_BASE_URL` 必需性说明**
   - 虽然代码中有默认值 `"https://amadeus-ai-api-2.zeabur.app/v1"`，但在 `transcribe.py:41` 中会检查是否为空
   - 如果为空会导致转录失败，因此**强烈建议明确设置**

2. **`SILICONFLOW_VOICE` 配置**
   - 有默认值，但如果使用自定义语音，需要设置
   - 默认值：`"speech:siliconflow-kurisu:clzv7bjkm041fufyct2z0setm:mphrsbbmvrjfophbsted"`

3. **API密钥缺失的影响**
   - 所有 API 密钥如果为空，相关功能会失败并记录错误日志
   - 服务不会崩溃，但功能无法使用
   - 建议在启动前检查所有必需密钥是否已配置

4. **前端代理配置**
   - `VITE_APP_API_BASE_URL` 如果配置错误，会导致所有 API 请求失败
   - 确保该地址指向正确的后端服务地址

5. **后端代理配置**
   - `WEBRTC_API_URL` 如果配置错误，会导致无法连接到 WebRTC 服务
   - 确保该地址指向正确的 WebRTC 服务地址（默认 `http://localhost:8001`）

6. **环境变量加载顺序**
   - 前端：`.env.development` (开发环境) 或 `.env.production` (生产环境)
   - 后端：`service/.env`
   - WebRTC：`service/webrtc/.env`
   - 确保文件路径正确，否则环境变量无法加载

7. **端口冲突**
   - 前端开发服务器：`1002`
   - 后端服务：`3002`
   - WebRTC服务：`8001`
   - 如果端口被占用，需要修改相应配置或释放端口

---

## 快速检查清单

在启动服务前，请确认以下配置：

### ✅ 前端配置检查
- [ ] `.env.development` 文件存在
- [ ] `VITE_APP_API_BASE_URL` 已设置且正确

### ✅ 后端配置检查
- [ ] `service/.env` 文件存在
- [ ] `WEBRTC_API_URL` 已设置且正确

### ✅ WebRTC配置检查
- [ ] `service/webrtc/.env` 文件存在
- [ ] `LLM_API_KEY` 已设置且有效
- [ ] `WHISPER_API_KEY` 已设置且有效
- [ ] `WHISPER_BASE_URL` 已设置且正确
- [ ] `SILICONFLOW_API_KEY` 已设置且有效

---

## 故障排查

### 问题：API请求失败

**可能原因**：
- `VITE_APP_API_BASE_URL` 配置错误
- 后端服务未启动
- 端口被占用

**解决方法**：
1. 检查 `.env.development` 中的 `VITE_APP_API_BASE_URL` 是否正确
2. 确认后端服务已启动（端口3002）
3. 检查浏览器控制台的错误信息

### 问题：语音识别失败

**可能原因**：
- `WHISPER_API_KEY` 未设置或无效
- `WHISPER_BASE_URL` 未设置或错误

**解决方法**：
1. 检查 `service/webrtc/.env` 中的 `WHISPER_API_KEY` 和 `WHISPER_BASE_URL`
2. 确认 API 密钥有效
3. 查看 WebRTC 服务日志

### 问题：语音合成失败

**可能原因**：
- `SILICONFLOW_API_KEY` 未设置或无效
- `SILICONFLOW_VOICE` 配置错误

**解决方法**：
1. 检查 `service/webrtc/.env` 中的 `SILICONFLOW_API_KEY`
2. 确认 API 密钥有效
3. 检查 `SILICONFLOW_VOICE` 是否正确

### 问题：LLM功能无法使用

**可能原因**：
- `LLM_API_KEY` 未设置或无效
- `LLM_BASE_URL` 配置错误

**解决方法**：
1. 检查 `service/webrtc/.env` 中的 `LLM_API_KEY` 和 `LLM_BASE_URL`
2. 确认 API 密钥有效
3. 确认 API 基础URL可访问

---

## 相关文档

- [部署指南](./DEPLOYMENT.md) - 详细的部署步骤说明
- [README](./README.md) - 项目总体介绍

---

**最后更新**: 2025-12-14

**文档版本**: 1.0

