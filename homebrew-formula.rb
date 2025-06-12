class Aigit < Formula
  desc "AI-powered Git commit message generator"
  homepage "https://github.com/zzxwill/aigit"
  url "https://github.com/zzxwill/aigit/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"
  license "Apache-2.0"
  head "https://github.com/zzxwill/aigit.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aigit version")
  end
end