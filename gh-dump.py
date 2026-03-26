import sys
import json
import urllib.request
import urllib.error
from urllib.parse import urlparse

def parse_github_url(url):
    url = url.rstrip("/")
    parts = urlparse(url)
    segments = parts.path.lstrip("/").split("/")
    if len(segments) < 4 or segments[2] != "blob":
        print(f"Error: expected format https://github.com/owner/repo/blob/branch/[path]")
        sys.exit(1)
    owner  = segments[0]
    repo   = segments[1]
    branch = segments[3]
    subpath = "/".join(segments[4:]) if len(segments) > 4 else ""
    return owner, repo, branch, subpath

def github_api(url):
    req = urllib.request.Request(url, headers={"Accept": "application/vnd.github+json",
                                                "User-Agent": "gh_dump.py"})
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode())

def walk(owner, repo, branch, path):
    api_url = f"https://api.github.com/repos/{owner}/{repo}/contents/{path}?ref={branch}"
    try:
        entries = github_api(api_url)
    except urllib.error.HTTPError as e:
        print(f"HTTP {e.code} fetching {api_url}")
        return

    if isinstance(entries, dict):
        entries = [entries]

    for entry in entries:
        if entry["type"] == "file":
            print(f"https://raw.githubusercontent.com/{owner}/{repo}/refs/heads/{branch}/{entry['path']}")
        elif entry["type"] == "dir":
            walk(owner, repo, branch, entry["path"])

def main():
    if len(sys.argv) < 2:
        print("Usage: python gh_urls.py <github-blob-url>")
        sys.exit(1)
    url = sys.argv[1]
    owner, repo, branch, subpath = parse_github_url(url)
    walk(owner, repo, branch, subpath)

if __name__ == "__main__":
    main()

