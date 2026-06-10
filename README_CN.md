# aigit

[English Documentation](README.md) | 中文文档

最强大的 Git 提交助手！

## 支持的大模型/AI

| 提供商 | 默认模型 |
|---|---|
| [OpenAI](https://openai.com/) | `gpt-5.4-mini` |
| [DeepSeek](https://deepseek.com/) | `deepseek-v4-flash-260425` |
| [Doubao (豆包)](https://www.volcengine.com/product/doubao) - 内置，您不需要自己携带 API Key | `doubao-seed-2-0-lite-260428` |
| [Gemini](https://gemini.google.com/) | `gemini-3.5-flash` |
| [Qwen (通义千问)](https://www.aliyun.com/product/tongyi) | `qwen-plus` |

## 快速开始

### 安装

#### 选项 1：Homebrew（推荐）

```shell
# 将仓库添加为tap（使用完整URL）
brew tap zzxwill/aigit https://github.com/zzxwill/aigit.git

# 安装稳定版本（从releases）
brew install aigit

# 安装开发版本（从dev分支）
brew install --HEAD aigit

# 备选方案：从本地formula文件安装
# curl -O https://raw.githubusercontent.com/zzxwill/aigit/master/Formula/aigit.rb
# brew install --formula aigit.rb
```

#### 选项 2：下载二进制文件

您可以通过以下方式之一安装 aigit：

1. 使用 `go install` (当前版本：v0.0.8)：

```shell
go install github.com/zzxwill/aigit@latest
```

```shell
$ aigit version
v0.0.8
```

2. 从发布页面下载：

- 前往 [发布页面](https://github.com/zzxwill/aigit/releases) 下载适合您平台的二进制文件。
- 将二进制文件重命名为 `aigit` 并移动到 `/usr/local/bin/aigit`。

```shell
chmod +x aigit && sudo mv aigit /usr/local/bin/aigit
```

#### 选项 3：从源码构建

```shell
git clone https://github.com/zzxwill/aigit.git
cd aigit
go build -o aigit main.go
sudo mv aigit /usr/local/bin/aigit
```

### 生成提交信息

```shell
$ aigit commit

🤖 Generating commit message...

📝 Generated commit message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
feat(llm): add support for volcengine-go-sdk

This commit adds support for the volcengine-go-sdk for integrating with Doubao LLM service.

The following changes were made:

- Provider type and APIKey field were added to the llm.Config struct.
- generateDoubaoCommitMessage function was updated to use the volcengine-go-sdk.
- The client is initialized with the apiKey and endpointId.
- A prompt is constructed and sent to the CreateChatCompletion API.
- The first choice's message is returned as the commit message.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🤔 What would you like to do?
1. Commit this message (default)
2. Regenerate message

Enter your choice (press Enter for default):

✅ Successfully committed changes!
```

### 使用自己的 AI API Key 生成提交信息

```shell
$ aigit auth add gemini AIzaSyCb56bjWn02e2v4s_TxHMDnHbSJQSx_tu8
Successfully added API key for gemini

$ aigit auth add doubao 6e3e438c-a380-4ed5-b597-e01cb82bc4df
Successfully added API key for doubao

$ aigit auth ls
Configured providers:
  gemini(gemini-3.5-flash) *default
  doubao(doubao-seed-2-0-lite-260428)

$ aigit commit

🤖 Generating commit message...

📝 Generated commit message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
feat(llm): add support for volcengine-go-sdk

This commit adds support for the volcengine-go-sdk for integrating with Doubao LLM service.

The following changes were made:

- Provider type and APIKey field were added to the llm.Config struct.
- generateDoubaoCommitMessage function was updated to use the volcengine-go-sdk.
- The client is initialized with the apiKey and endpointId.
- A prompt is constructed and sent to the CreateChatCompletion API.
- The first choice's message is returned as the commit message.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🤔 What would you like to do?
1. Commit this message (default)
2. Regenerate message

Enter your choice (press Enter for default): 2

🤖 Regenerating commit message...

📝 Generated commit message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
feat(llm): add support for volcengine-go-sdk

This commit adds support for the volcengine-go-sdk for integrating with Doubao LLM service.

The following changes were made:

- Provider type and APIKey field were added to the llm.Config struct.
- generateDoubaoCommitMessage function was updated to use the volcengine-go-sdk.
- The client is initialized with the apiKey and endpointId.
- A prompt is constructed and sent to the CreateChatCompletion API.
- The first choice's message is returned as the commit message.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🤔 What would you like to do?
1. Commit this message (default)
2. Regenerate message

Enter your choice (press Enter for default): 1

✅ Successfully committed changes!
```

豆包提供商默认使用内置模型。您也可以选择传入[方舟推理接入点 ID](https://www.volcengine.com/docs/82379/1099522)（`ep-xxx`）或模型 ID 来覆盖默认模型：

```shell
$ aigit auth add doubao <api_key> ep-20250110202503-fdkgq
```

## 版本更新检查

aigit 会在后台检查新版本（每 24 小时最多一次，结果缓存在 `~/.aigit/update-check.json`）。
当有新版本可用时，会在命令执行结束后询问是否升级；如果您同意，aigit 会自动完成升级
（Homebrew 安装的版本通过 brew 升级，其他安装方式则从源码构建新版本并原地替换）。
设置 `AIGIT_NO_UPDATE_CHECK=1` 可以禁用该功能。
