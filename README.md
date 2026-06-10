# aigit

[中文文档 (Chinese Documentation)](./README_CN.md) | English Documentation

The most powerful git commit assistant ever!

It's a command-line tool that streamlines the git commit process by automatically generating meaningful and standardized commit messages, including title and body.

`aigit commit` is as simple as `git commit`.

## Supported 🤖 AI Providers

| Provider | Default model |
|---|---|
| [OpenAI](https://openai.com/) | `gpt-5.4-mini` |
| [DeepSeek](https://deepseek.com/) | `deepseek-v4-flash-260425` |
| [Doubao (豆包)](https://www.volcengine.com/product/doubao) - Built-in, you don't need to bring your own key | `doubao-seed-2-0-lite-260428` |
| [Gemini](https://gemini.google.com/) | `gemini-3.5-flash` |
| [Qwen (通义千问)](https://www.aliyun.com/product/tongyi) | `qwen-plus` |

## Getting Started

### Installation

#### Option 1: Homebrew (Recommended)

```shell
# Add the repository as a tap (use full URL)
brew tap zzxwill/aigit https://github.com/zzxwill/aigit.git

# Install stable version (from releases)
brew install aigit

# Install development version (from dev branch)
brew install --HEAD aigit

# Alternative: Install from local formula file
# curl -O https://raw.githubusercontent.com/zzxwill/aigit/master/Formula/aigit.rb
# brew install --formula aigit.rb
```

#### Option 2: Download Binary

You can install aigit in one of the following ways:

1. Using `go install`:

```shell
go install github.com/zzxwill/aigit@latest
```

```shell
$ aigit version
v0.0.8
```

2. Download from releases:

- Go to the [releases page](https://github.com/zzxwill/aigit/releases) and download the binary for your platform.
- Rename the binary to `aigit` and move it to `/usr/local/bin/aigit`.

```shell
chmod +x aigit && sudo mv aigit /usr/local/bin/aigit
```

#### Option 3: Build from Source

```shell
git clone https://github.com/zzxwill/aigit.git
cd aigit
go build -o aigit main.go
sudo mv aigit /usr/local/bin/aigit
```

### Generate commit message

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

### Generate commit message with your own AI API Key

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

For Doubao, the provider uses the built-in default model. You can optionally pass an
[Ark inference endpoint ID](https://www.volcengine.com/docs/82379/1099522) (`ep-xxx`) or a model ID to override it:

```shell
$ aigit auth add doubao <api_key> ep-20250110202503-fdkgq
```

## Update check

aigit checks for new releases in the background (at most once every 24 hours, cached
in `~/.aigit/update-check.json`). When a newer version is available, it asks after the
command finishes whether to upgrade; if you agree, aigit upgrades itself in place
(via Homebrew for brew installs, otherwise by building the release from source).
Set `AIGIT_NO_UPDATE_CHECK=1` to disable the check.
