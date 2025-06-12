class Aigit < Formula
  desc "AI-powered Git commit message generator using LLM"
  homepage "https://github.com/zzxwill/aigit"
  url "https://github.com/zzxwill/aigit/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"
  license "Apache-2.0"
  head "https://github.com/zzxwill/aigit.git", branch: "master"

  depends_on "go" => :build

  def install
    # Build with version information
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./main.go"
  end

  test do
    # Test version command
    assert_match version.to_s, shell_output("#{bin}/aigit version")

    # Test help command
    assert_match "Generate git commit message", shell_output("#{bin}/aigit help")

    # Test auth command
    assert_match "Manage LLM providers", shell_output("#{bin}/aigit auth --help")
  end

  def caveats
    <<~EOS
      Before using aigit, you need to configure an AI provider:

        # For OpenAI
        aigit auth add openai YOUR_API_KEY

        # For Gemini
        aigit auth add gemini YOUR_API_KEY

        # For DeepSeek
        aigit auth add deepseek YOUR_API_KEY

        # For Doubao
        aigit auth add doubao YOUR_API_KEY YOUR_ENDPOINT_ID

      Then use:
        aigit commit
    EOS
  end
end