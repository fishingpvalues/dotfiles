#!/usr/bin/env python3
import os
import subprocess

# SOTA tools to check
SOTA_TOOLS = [
    ("ghostty", ["--version"]),
    ("mise", ["--version"]),
    ("jj", ["--version"]),
    ("code2", ["--version"]),
    ("bashbuddy", ["--version"]),
    ("lsd", ["--version"]),
    ("trash", ["--version"]),
]

CONFIGS = [
    "config/ghostty/config",
    "config/mise/config.toml",
    "config/jj/config.toml",
    "config/code2/config.toml",
    "config/bashbuddy/config.toml",
    "config/lsd/config.yaml",
]


def check_tool(tool, args):
    try:
        result = subprocess.run(
            [tool] + args, capture_output=True, text=True, timeout=5
        )
        if result.returncode == 0:
            return {
                "tool": tool,
                "status": "ok",
                "version": result.stdout.strip().splitlines()[0],
            }
        else:
            return {"tool": tool, "status": "fail", "error": result.stderr.strip()}
    except FileNotFoundError:
        return {"tool": tool, "status": "missing"}
    except Exception as e:
        return {"tool": tool, "status": "error", "error": str(e)}


def check_config(path):
    if not os.path.exists(path):
        return {"config": path, "status": "missing"}
    # Optionally, add format validation here
    return {"config": path, "status": "ok"}


def main():
    print("[MCP/AI] SOTA Dotfiles Health Check\n")
    tool_results = [check_tool(tool, args) for tool, args in SOTA_TOOLS]
    config_results = [check_config(cfg) for cfg in CONFIGS]

    print("Tool Status:")
    for res in tool_results:
        print(
            f"- {res['tool']}: {res['status']}"
            + (
                f" ({res.get('version', res.get('error', ''))})"
                if res["status"] != "ok"
                else f" ({res['version']})"
            )
        )
    print("\nConfig Status:")
    for res in config_results:
        print(f"- {res['config']}: {res['status']}")

    # Optionally: Add AI/MCP drift detection, auto-remediation, or suggestions here
    # For now, just print summary
    print("\nSummary:")
    if all(r["status"] == "ok" for r in tool_results + config_results):
        print("All SOTA tools and configs are present and healthy.")
    else:
        print("Some tools or configs are missing or unhealthy. See above.")


if __name__ == "__main__":
    main()
