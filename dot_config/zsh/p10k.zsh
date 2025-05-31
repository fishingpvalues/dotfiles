# Generated p10k config file with a style similar to Agnoster

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # Prompt colors.
  local grey='242'
  local red='1'
  local yellow='3'
  local blue='4'
  local magenta='5'
  local cyan='6'
  local white='7'

  # Left prompt segments.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    os_icon                 # os identifier
    context                 # user@host
    dir                     # current directory
    vcs                     # git status
    # =========================[ Line #2 ]=========================
    newline                 # \n
    prompt_char             # prompt symbol
  )

  # Right prompt segments.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    direnv                  # direnv status (https://direnv.net/)
    virtualenv              # python virtual environment
    anaconda                # conda environment
    pyenv                   # python environment
    nodenv                  # node.js version from nodenv
    nvm                     # node.js version from nvm
    nodeenv                 # node.js environment
    # go_version             # go version
    # rust_version           # rustc version
    # =========================[ Line #2 ]=========================
    newline
    # battery               # internal battery
    # time                  # current time
  )

  # Basic style options that define the overall prompt look.
  typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=                # prompt symbol background
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=green  # green prompt for normal vi modes
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=red # red prompt for vi modes when error
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'   # prompt character in insert mode
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'   # prompt character in normal mode
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'   # prompt character in visual mode
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'   # prompt character in overwrite mode
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='·'
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=238
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=

  # Icon sets
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_LINUX_ICON='%F{cyan}%f'
  typeset -g POWERLEVEL9K_APPLE_ICON='%F{cyan}%f'
  typeset -g POWERLEVEL9K_WINDOWS_ICON='%F{cyan}%f'

  # Context format: user@host or just user if DEFAULT_USER matches current user
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%F{red}%n%f@%m'
  # Default context color
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=green
  # Root context color
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=red
  # Don't show context unless running with privileges or in SSH.
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION=
  typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=false
  typeset -g POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND=yellow
  typeset -g POWERLEVEL9K_CONTEXT_REMOTE_CONTENT_EXPANSION='%n@%m'
  
  # Directory
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=blue
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=blue
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=blue
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true

  # VCS
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=magenta
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=red
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=grey

  # VCS Git icons
  typeset -g POWERLEVEL9K_VCS_GIT_GITHUB_ICON=''
  typeset -g POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=''
  typeset -g POWERLEVEL9K_VCS_GIT_GITLAB_ICON=''
  typeset -g POWERLEVEL9K_VCS_GIT_ICON=''

  # Status
  typeset -g POWERLEVEL9K_STATUS_OK=true
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=green
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=green
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=red
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=red
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'
  
  # Command Execution Time
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=yellow
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  
  # Background Jobs
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=magenta
  
  # Virtualenv, Pyenv, Nodeenv settings
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_PYENV_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_NODENV_FOREGROUND=green
  typeset -g POWERLEVEL9K_NODEENV_FOREGROUND=green
  typeset -g POWERLEVEL9K_NVM_FOREGROUND=green
  
  # Direnv
  typeset -g POWERLEVEL9K_DIRENV_FOREGROUND=cyan

  # Instant prompt mode: off=don't use, quiet=silently load, verbose=show loading
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

  # Hot reload allows updating config without restarting zsh
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false
  
  # Agnoster-like segment separators for consistent look
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '

  # Don't show a dot when Git directory is dirty
  typeset -g POWERLEVEL9K_VCS_SHOW_SUBMODULE_DIRTY=false

  # Limit the number of Git commits shown in the prompt
  typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0.5
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=5000

  # Transient prompt works similarly to Agnoster's prompt after you press Enter
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  # Instant prompt mode
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # Hot reload allows you to change this file and see changes immediately
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false

  # If p10k is already loaded, reload configuration.
  # This works even with POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
  (( ! $+functions[p10k] )) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'