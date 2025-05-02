# README: Full PowerShell 7.x & Conda (Miniforge3) Reset & Reinstall Guide (Windows)

**Date:** 2025-05-02
**Location Context:** Bielefeld, North Rhine-Westphalia, Germany

> **Goal:**
> Cleanly remove PowerShell 7+ and Miniforge3/Conda, then reinstall both with correct Oh My Posh and Conda integration—**without deleting your user profiles (like `$PROFILE`), Conda configuration (`.condarc`), Conda environments (`~\.conda\envs`), or system environment variables.** Resolve known issues with PowerShell 7.5.x and Conda activation.

---

## 1. Preparation & Backups

_Before starting, ensure you have backups of your critical configurations._

### 1.1. Backup PowerShell Profiles & Scripts

- Find your main profile path:

  ```powershell
  Write-Host "Your primary PowerShell profile location: $PROFILE"
  # Note: Other profiles might exist ($PROFILE.CurrentUserAllHosts, etc.)
  ```

- Manually back up the file(s) indicated by `$PROFILE` and any other custom `.ps1` scripts sourced within them. Common locations include `~\Documents\PowerShell\` or `~\Documents\WindowsPowerShell\`.

### 1.2. Backup Conda Configuration & Environments (Optional but Recommended)

- **Conda Config:** Manually back up `~\.condarc` if it exists and contains custom settings.
- **Conda Environments:** If you have critical environments you want to restore later, export them:

  ```powershell
  conda env list
  # For each important environment:
  conda env export -n <env_name> > ~\<env_name>_backup.yml
  ```

### 1.3. Backup Oh My Posh Configuration

- Locate the path to your Oh My Posh theme file (usually referenced in your PowerShell profile, e.g., `~\mytheme.omp.json`).
- Back up this theme file.

---

## 2. Uninstall PowerShell 7.x

### 2.1. Remove via Windows Settings or Winget

- **Option A (Settings):**
  - Open **Settings > Apps > Installed Apps**.
  - Search for **"PowerShell 7"** (or "PowerShell Preview").
  - Select it and click **Uninstall**. Follow prompts.
- **Option B (Winget):**
  - Open Command Prompt or Windows PowerShell (5.1).
  - Run: `winget uninstall Microsoft.PowerShell` (or `Microsoft.PowerShell.Preview`).

### 2.2. Check for Leftover Files (Manual Cleanup)

- After uninstalling, check if these folders exist and delete them **if they remain**:
  - `C:\Program Files\PowerShell\7`
  - `C:\Program Files\PowerShell\7-preview`
  - Any other custom install locations you might have used.
- **DO NOT** delete `~\Documents\PowerShell` or `~\Documents\WindowsPowerShell`.

### 2.3. Verify PATH Cleanup (Manual Check)

- Open **System Properties > Environment Variables**.
- Check both User and System `Path` variables.
- Manually remove any entries explicitly pointing to the PowerShell 7 directories you just removed/verified are gone (this is usually handled by the uninstaller, but worth checking).

---

## 3. Uninstall Miniforge3 / Conda

### 3.1. Reverse Conda Initialization (Attempt Cleanup)

- Open Command Prompt (`cmd.exe`) or Windows PowerShell (5.1).
- Navigate (`cd`) to where Miniforge3 was installed (e.g., `C:\Users\<YourUser>\miniforge3`).
- Run the following command to try and remove Conda's hooks from your shell profiles:

  ```cmd
  .\Scripts\conda.exe init --reverse --all
  ```

  _(This might fail if Conda is already broken, but it's worth trying)._

### 3.2. Uninstall via Control Panel or Uninstaller Executable

- **Option A (Control Panel):**
  - Open **Control Panel > Programs and Features**.
  - Find **Miniforge3** (or Miniconda3, Anaconda3) in the list.
  - Select it and click **Uninstall**. Follow the prompts.
- **Option B (Uninstaller .exe):**
  - Navigate to the Miniforge3 installation directory.
  - Run `Uninstall-Miniforge3.exe` (or similar) if it exists.
- **IMPORTANT DURING UNINSTALL:** If prompted about removing user settings, configurations, or packages, carefully read the options. **Decline** options that mention removing your user configuration (`.condarc`), environments (`~\.conda\envs`), or packages (`pkgs` cache) unless you explicitly want to start _completely_ fresh (which contradicts the goal here).

### 3.3. Check for Leftover Files (Manual Cleanup)

- After the uninstaller finishes, check if the main installation directory (e.g., `C:\Users\<YourUser>\miniforge3`) still exists. If it does, you can manually delete it.
- **CRITICAL: DO NOT DELETE THESE USER FOLDERS/FILES:**
  - `C:\Users\<YourUser>\.conda` (Contains your environments and potentially package cache)
  - `C:\Users\<YourUser>\.condarc` (Contains your Conda configuration)
- **Optional Deeper Clean (Use with Caution):** If you experience persistent issues, you _could_ consider removing cache folders like `C:\Users\<YourUser>\AppData\Local\conda`, but this is usually unnecessary and won't affect core functionality restoration. Avoid unless specifically needed.

### 3.4. Verify PATH Cleanup (Manual Check)

- Open **System Properties > Environment Variables**.
- Check both User and System `Path` variables.
- Manually remove any remaining entries pointing to the old Miniforge3 installation directories (e.g., `...\miniforge3\Scripts`, `...\miniforge3\condabin`). The uninstaller or `conda init --reverse` should handle this, but verify.

---

## 4. Reboot

- **Restart your computer.** This ensures all uninstallation changes, file deletions, and PATH modifications are fully applied before reinstalling.

---

## 5. Reinstall PowerShell 7.x

### 5.1. Download Latest Stable Version

- Go to the [PowerShell GitHub Releases page](https://github.com/PowerShell/PowerShell/releases).
- Download the latest **stable** `.msi` installer for your system (e.g., `PowerShell-7.x.x-win-x64.msi`). Using stable over preview is recommended for compatibility.

### 5.2. Install PowerShell

- Run the downloaded MSI installer.
- Accept default settings unless you have specific reasons to change them (like install path or adding context menus). Ensure "Add PowerShell to PATH Environment Variable" is checked (usually default).

### 5.3. Verify Installation

- Open a **new** PowerShell 7 window (Search for "PowerShell 7" or "pwsh").
- Run:

  ```powershell
  $PSVersionTable.PSVersion
  ```

- Confirm it shows the version you just installed.

---

## 6. Reinstall Miniforge3 (or Miniconda)

### 6.1. Download Latest Installer

- Go to the [Miniforge GitHub repository](https://github.com/conda-forge/miniforge/releases).
- Download the latest `Miniforge3-Windows-x86_64.exe` installer.

### 6.2. Install Miniforge3

- Run the downloaded installer.
- Choose installation type ("Just Me" recommended).
- Select the installation location (e.g., `C:\Users\<YourUser>\miniforge3`). **Note this path.**
- **Installation Options:**
  - **DO NOT** check "Add Miniforge3 to my PATH environment variable". Rely on `conda init`.
  - You _can_ choose "Register Miniforge3 as my default Python" if desired.
- Complete the installation.

### 6.3. Verify Conda Installation

- Open a **new** PowerShell 7 window.
- Navigate to the installation directory's `Scripts` folder and run `conda --version`:

  ```powershell
  cd $HOME\miniforge3\Scripts  # Adjust path if you installed elsewhere
  .\conda.exe --version
  ```

- It should report the installed Conda version. _(Note: `conda` won't be directly on PATH yet)._

---

## 7. Reinstall Oh My Posh (If Necessary)

### 7.1. Install via Winget (Recommended) or Other Method

- [Oh My Posh Install Guide](https://ohmyposh.dev/docs/installation/windows)
- If not already installed globally or if you want the latest version:

  ```powershell
  winget install JanDeDobbeleer.OhMyPosh -s winget
  ```

### 7.2. Restore Configuration

- Ensure your backed-up Oh My Posh theme file is accessible (e.g., in `~\mytheme.omp.json`).

---

## 8. Configure PowerShell Profile: Correct Integration

### 8.1. Edit Your PowerShell Profile

- Open your profile script for editing (use the path from step 1.1):

  ```powershell
  notepad $PROFILE
  # Or use VS Code: code $PROFILE
  ```

- If the file is empty or missing, you can restore it from your backup or create a new one.

### 8.2. Add Conda Initialization

- Add the following block to your profile. Ensure the path to `conda.exe` is correct based on your installation location (Step 6.2). `$HOME\miniforge3` is common for "Just Me" installs.

  ```powershell
  # --- Conda Initialization (Robust hook handling) ---
  # Ensure this path matches your Miniforge3 installation
  $CondaExePath = "$HOME\miniforge3\Scripts\conda.exe"
  if (Test-Path $CondaExePath) {
      $condaHookOutput = (& $CondaExePath "shell.powershell" "hook")
      if ($null -ne $condaHookOutput -and $condaHookOutput.Length -gt 0) {
          Invoke-Expression ($condaHookOutput -join [Environment]::NewLine)
      } else {
          Write-Warning "Conda hook script produced no output or was null during profile load."
      }
  } else {
      Write-Warning "Conda executable not found at $CondaExePath. Conda initialization skipped."
  }
  # --- End Conda Initialization ---
  ```

### 8.3. Add Workaround for Conda/PowerShell 7.5+ Bug

- **Immediately AFTER** the Conda Initialization block, add the workaround:

  ```powershell
  # --- Workaround for Conda _CE_M/_CE_CONDA bug in PS 7.5+ ---
  # This removes variables potentially set incorrectly by the hook before activation commands.
  Remove-Item Env:_CE_M, Env:_CE_CONDA -ErrorAction SilentlyContinue
  # --- End Workaround ---
  ```

### 8.4. Add Oh My Posh Initialization

- **AFTER** the Conda block and the Workaround block, add the Oh My Posh initialization line. Adjust the `--config` path to your theme file.

  ```powershell
  # --- Oh My Posh Initialization ---
  # Ensure this path points to your Oh My Posh theme config file
  $OmpConfigPath = "$HOME\mytheme.omp.json"
  if (Test-Path $OmpConfigPath) {
      oh-my-posh init pwsh --config $OmpConfigPath | Invoke-Expression
  } else {
      # Fallback or default theme if custom config not found
      oh-my-posh init pwsh | Invoke-Expression
      Write-Warning "Oh My Posh config not found at $OmpConfigPath. Using default theme."
  }
  # --- End Oh My Posh Initialization ---
  ```

### 8.5. Optional: Auto-activate Base Environment

- If you want the `base` environment to activate automatically when PowerShell starts, add this line **AFTER** the Conda hook and the workaround:

  ```powershell
  # --- Auto-activate Conda Base Environment (Optional) ---
  conda activate base
  # --- End Auto-activate ---
  ```

### 8.6. Final Profile Order Review

- The essential order within your `$PROFILE` should be:
  1. Conda Initialization block (`Invoke-Expression` for hook)
  2. Conda Bug Workaround (`Remove-Item Env:...`)
  3. Oh My Posh Initialization (`oh-my-posh init ... | Invoke-Expression`)
  4. (Optional) `conda activate base`

---

## 9. Verification & Final Steps

### 9.1. Open a New PowerShell 7 Window

- Close all PowerShell windows and open a fresh one.
- **Check Prompt:** Your Oh My Posh themed prompt should appear correctly.
- **Check Conda:** If you enabled auto-activation, `(base)` should appear. If not, run `conda activate base`.
- **Test Conda Command:**

  ```powershell
  conda info
  conda list
  ```

- These commands should run without the `invalid choice: ''` error or messages about `_CE_CONDA`/`_CE_M`.

### 9.2. Update Conda & Packages

- It's good practice to ensure Conda and base packages are up-to-date, especially since the fix for the PS 7.5 issue is relatively recent (conda 25.1.1+):

  ```powershell
  conda update -n base conda
  conda update --all -n base
  ```

- Restart PowerShell and verify again after updates.

### 9.3. Restore Conda Environments (If Backed Up)

- If you exported environments in Step 1.2, you can recreate them:

  ```powershell
  conda env create -f ~\<env_name>_backup.yml
  ```

---

## 10. Troubleshooting

- **Profile Errors on Startup:** Carefully check syntax in `$PROFILE`. Ensure paths in the Conda and Oh My Posh blocks are correct. Check for stray characters or incorrect quoting. Run parts of the profile manually to isolate errors.
- **`conda activate` still fails:**
  - Verify Conda version (`conda --version`) is 25.1.1 or newer.
  - Double-check the workaround (`Remove-Item Env:...`) is present and correctly placed _immediately after_ the Conda hook `Invoke-Expression`.
  - Temporarily comment out the Oh My Posh line in `$PROFILE` to see if it interferes.
  - Manually run `Remove-Item Env:_CE_M, Env:_CE_CONDA -ErrorAction SilentlyContinue` in the terminal, then try `conda activate base`.
- **Oh My Posh Fails:** Check `winget list JanDeDobbeleer.OhMyPosh` to confirm installation. Verify the theme path in `$PROFILE`. Try running `oh-my-posh init pwsh --config ...` manually. Check the Oh My Posh documentation.
- **Persistent Issues:** Check the GitHub issue trackers:
  - [Conda Issues](https://github.com/conda/conda/issues)
  - [Oh My Posh Issues](https://github.com/JanDeDobbeleer/oh-my-posh/issues)
- **Use Miniforge Prompt:** As a last resort for Conda functionality, use the dedicated "Miniforge Prompt" which uses `cmd.exe` and typically bypasses PowerShell integration issues.

---

## 11. References

- [Conda PowerShell Issue #14292](https://github.com/conda/conda/issues/14292)
- [Conda PowerShell Fix PR #14517](https://github.com/conda/conda/pull/14517)
- [Conda PowerShell Issue #14787 (Later reports)](https://github.com/conda/conda/issues/14787)
- [Oh My Posh Docs - Windows Install](https://ohmyposh.dev/docs/installation/windows)
- [Miniforge Releases](https://github.com/conda-forge/miniforge/releases)
- [PowerShell Releases](https://github.com/PowerShell/PowerShell/releases)

---

## 12. Future-Proofing

- Keep Conda, PowerShell, and Oh My Posh updated, as newer versions may include better integration or fixes.
- Monitor the Conda release notes for changes related to PowerShell support.
