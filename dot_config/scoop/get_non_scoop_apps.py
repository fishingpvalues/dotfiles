import subprocess
import winreg
from typing import Set


def get_installed_apps() -> Set[str]:
    """Retrieve a set of installed application names from Windows registry."""
    uninstall_keys = [
        r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        r"SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
    ]
    hives = [winreg.HKEY_LOCAL_MACHINE, winreg.HKEY_CURRENT_USER]
    apps = set()

    for hive in hives:
        for key_path in uninstall_keys:
            try:
                with winreg.OpenKey(hive, key_path) as key:
                    for i in range(0, winreg.QueryInfoKey(key)[0]):
                        try:
                            subkey_name = winreg.EnumKey(key, i)
                            with winreg.OpenKey(key, subkey_name) as subkey:
                                name, _ = winreg.QueryValueEx(subkey, "DisplayName")
                                if name:
                                    apps.add(name)
                        except FileNotFoundError:
                            continue
                        except OSError:
                            continue
            except FileNotFoundError:
                continue
    return apps


def scoop_search(app_name: str) -> bool:
    """Check if an app is available in Scoop."""
    try:
        result = subprocess.run(
            ["scoop", "search", app_name],
            capture_output=True,
            text=True,
            timeout=10,
        )
        # If the app name appears in the output, it's available
        return app_name.lower() in result.stdout.lower()
    except Exception:
        return False


def main():
    installed_apps = get_installed_apps()
    checklist = []

    print("# Scoop Installability Checklist\n")
    for app in sorted(installed_apps):
        available = scoop_search(app)
        mark = "[x]" if available else "[ ]"
        print(f"{mark} {app}")


if __name__ == "__main__":
    main()
