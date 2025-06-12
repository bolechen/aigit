#!/bin/bash

# 自动更新Homebrew formula的脚本
set -e

VERSION=${1:-$(git describe --tags --abbrev=0)}
HOMEBREW_REPO="yourusername/homebrew-aigit"  # 替换为您的homebrew仓库

echo "🍺 Updating Homebrew formula for version $VERSION"

# 1. 下载并计算SHA256
echo "📦 Downloading release tarball..."
TARBALL_URL="https://github.com/zzxwill/aigit/archive/refs/tags/$VERSION.tar.gz"
SHA256=$(curl -sL "$TARBALL_URL" | shasum -a 256 | cut -d' ' -f1)

echo "🔍 SHA256: $SHA256"

# 2. 克隆homebrew仓库
echo "📂 Cloning homebrew repository..."
TEMP_DIR=$(mktemp -d)
git clone "https://github.com/$HOMEBREW_REPO.git" "$TEMP_DIR"

# 3. 更新formula
echo "✏️  Updating formula..."
cat > "$TEMP_DIR/Formula/aigit.rb" << EOF
class Aigit < Formula
  desc "AI-powered Git commit message generator using LLM"
  homepage "https://github.com/zzxwill/aigit"
  url "https://github.com/zzxwill/aigit/archive/refs/tags/$VERSION.tar.gz"
  sha256 "$SHA256"
  license "Apache-2.0"
  head "https://github.com/zzxwill/aigit.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aigit version")
    assert_match "Generate git commit message", shell_output("#{bin}/aigit help")
  end

  def caveats
    <<~EOS
      Before using aigit, configure an AI provider:
        aigit auth add openai YOUR_API_KEY
        aigit auth add gemini YOUR_API_KEY
        aigit auth add deepseek YOUR_API_KEY
        aigit auth add doubao YOUR_API_KEY YOUR_ENDPOINT_ID

      Then use: aigit commit
    EOS
  end
end
EOF

# 4. 提交更新
echo "📤 Committing updates..."
cd "$TEMP_DIR"
git add Formula/aigit.rb
git commit -m "feat: update aigit to $VERSION"
git push origin main

# 5. 清理
rm -rf "$TEMP_DIR"

echo "✅ Homebrew formula updated successfully!"
echo "🎉 Users can now install with: brew install $HOMEBREW_REPO/aigit"