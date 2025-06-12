# aigit Homebrew Tap

现有的 aigit 仓库已经集成了 Homebrew tap 功能，用户可以直接使用本仓库作为 tap 安装 aigit。

## 用户安装方式

### 方法 1：通过 Tap 安装（推荐）

```bash
# 添加仓库为 tap（使用完整URL）
brew tap bolechen/aigit https://github.com/bolechen/aigit.git

# 安装 aigit
brew install aigit
```

### 方法 2：本地 Formula 文件安装

```bash
# 下载 formula 文件
curl -O https://raw.githubusercontent.com/bolechen/aigit/master/Formula/aigit.rb

# 安装
brew install --formula aigit.rb
```

## 维护说明

- Formula 文件位于 `Formula/aigit.rb`
- GitHub Actions 自动更新 formula（发布新版本时）
- 手动更新：运行 `./scripts/update-homebrew.sh`

## 卸载

```bash
# 卸载 aigit
brew uninstall aigit

# 移除 tap（可选）
brew untap zzxwill/aigit
```

## 故障排除

### 如果 tap 添加失败

1. 确保仓库是公开的
2. 确保 Formula/aigit.rb 文件存在
3. 尝试更新 Homebrew：`brew update`

### 如果安装失败

1. 检查依赖：确保安装了 Go
2. 查看详细错误：`brew install aigit --verbose`
3. 使用备选安装方法

更多帮助请访问：https://github.com/zzxwill/aigit/issues