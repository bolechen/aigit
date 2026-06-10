package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

const (
	updateCheckInterval = 24 * time.Hour
	latestReleaseURL    = "https://api.github.com/repos/agentsdance/aigit/releases/latest"
)

// updateCheckState is persisted to ~/.aigit/update-check.json so the
// GitHub API is queried at most once per updateCheckInterval.
type updateCheckState struct {
	CheckedAt     time.Time `json:"checked_at"`
	LatestVersion string    `json:"latest_version"`
}

// startUpdateCheck looks for a newer aigit release in the background while
// the main command runs. The returned channel always delivers exactly one
// value: the tag of the newer release, or "" when no upgrade is available.
func startUpdateCheck(current string) <-chan string {
	ch := make(chan string, 1)
	go func() {
		ch <- newerRelease(current)
	}()
	return ch
}

func newerRelease(current string) string {
	// Source builds report "dev" and have no release to compare against.
	if current == "dev" || os.Getenv("AIGIT_NO_UPDATE_CHECK") != "" || os.Getenv("CI") != "" {
		return ""
	}

	latest, err := latestVersion()
	if err != nil || latest == "" {
		return ""
	}
	if !versionLess(current, latest) {
		return ""
	}

	return latest
}

// latestVersion returns the most recent release tag, served from the local
// state file when it is fresh enough, otherwise from the GitHub API.
func latestVersion() (string, error) {
	stateFile := updateStateFile()
	if stateFile != "" {
		if st, err := readUpdateState(stateFile); err == nil && time.Since(st.CheckedAt) < updateCheckInterval {
			return st.LatestVersion, nil
		}
	}

	tag, err := fetchLatestTag()
	if err != nil {
		return "", err
	}
	if stateFile != "" {
		writeUpdateState(stateFile, tag)
	}
	return tag, nil
}

func updateStateFile() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return ""
	}
	dir := filepath.Join(homeDir, ".aigit")
	if err := os.MkdirAll(dir, 0o700); err != nil {
		return ""
	}
	return filepath.Join(dir, "update-check.json")
}

func readUpdateState(path string) (updateCheckState, error) {
	var st updateCheckState
	data, err := os.ReadFile(path)
	if err != nil {
		return st, err
	}
	err = json.Unmarshal(data, &st)
	return st, err
}

func writeUpdateState(path, latest string) {
	data, err := json.Marshal(updateCheckState{CheckedAt: time.Now(), LatestVersion: latest})
	if err != nil {
		return
	}
	_ = os.WriteFile(path, data, 0o600)
}

func fetchLatestTag() (string, error) {
	client := &http.Client{Timeout: 2 * time.Second}
	resp, err := client.Get(latestReleaseURL)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("unexpected status %s", resp.Status)
	}

	var release struct {
		TagName string `json:"tag_name"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&release); err != nil {
		return "", err
	}
	return release.TagName, nil
}

// versionLess reports whether version a is older than version b. Versions
// are compared numerically segment by segment ("v" prefix and pre-release
// suffixes like "-rc1" are ignored), e.g. v0.0.9 < v0.0.10.
func versionLess(a, b string) bool {
	as := versionSegments(a)
	bs := versionSegments(b)
	for i := 0; i < len(as) || i < len(bs); i++ {
		var av, bv int
		if i < len(as) {
			av = as[i]
		}
		if i < len(bs) {
			bv = bs[i]
		}
		if av != bv {
			return av < bv
		}
	}
	return false
}

func versionSegments(v string) []int {
	v = strings.TrimPrefix(strings.TrimSpace(v), "v")
	if i := strings.IndexAny(v, "-+"); i >= 0 {
		v = v[:i]
	}
	parts := strings.Split(v, ".")
	segs := make([]int, 0, len(parts))
	for _, p := range parts {
		n, err := strconv.Atoi(p)
		if err != nil {
			break
		}
		segs = append(segs, n)
	}
	return segs
}
