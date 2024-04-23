## iterm shell integration ##
source ~/.iterm2_shell_integration.fish

function iterm2_print_user_vars
  # iterm2_set_user_var pomoStatus (pomodoro status -f "🍅 %!r %d%t")
  # iterm2_set_user_var currentPomodoro $currentPomodoro

  # python version and virtualenv
  iterm2_set_user_var pythonVersion (python --version 2>&1)
  set -l venv (basename (echo $VIRTUAL_ENV))
  if test -n "$venv[1]"
    iterm2_set_user_var pyEnv "[$venv]"
  else
    iterm2_set_user_var pyEnv ""
  end
end


## auto-activate nvm ##
function __nvm_auto --on-variable PWD
  nvm use --silent
  # nvm use --silent 2>/dev/null
end
__nvm_auto


## set pwd for prompt on load ##
set -g short_pwd (string match -rg '.*\/(.*)' $PWD)


## color theme ##

# terminal background color to match iTerm2's setting in the profile
set -g color_background '192330'

# OSX Terminal app does not support true color
if test "$TERM_PROGRAM" = "Apple_Terminal"
  set -x LS_COLORS "$(vivid -m 8-bit generate nightfox2)"
else
  set -x LS_COLORS "$(vivid generate nightfox2)"
end

alias ls="lsd"
# alias la="lsd --blocks=permission,git,size,date,name"

# set -x EZA_MIN_LUMINANCE 300
# alias xls="eza --group-directories-first --icons=auto --git --smart-group -m -o --no-permissions --no-quotes --color-scale --color-scale-mode=gradient"

# colored man pages (miyl/fish-colored-man)
set -g man_blink -o red
set -g man_bold -o brblue
set -g man_standout -b black brmagenta
set -g man_underline -u brmagenta


## custom greeting ##
function fish_greeting
    # curl --max-time 3 -s "wttr.in?format=3" # print weather, see https://github.com/chubin/wttr.in
    echo -e "\n$(oblique)\n" # random oblique strategy
end


##  custom title ##
function fish_title
    set -q argv[1]; and echo "$argv[1] - ";
    echo $short_pwd

  # set project ( basename ( git rev-parse --show-toplevel 2>/dev/null ) 2>/dev/null );

  # # don't show current command if it's fish, ls or cd (the latter two avoid distracting flickering on touchbar)
  # if [ $_ = 'fish' ]; or [ $_ = 'ls' ]; or [ $_ = 'cd' ];
  #   # echo (prompt_pwd)
  #     if [ $project ]
  #       echo $project
  #     else
  #       echo (prompt_pwd)
  #     end
  # else
  #     # todo trim this to fewer character length
  #     #echo ( echo $_ | cut -cn 1-30 )
  #     echo ⏳ $_
  # end
end

## directory aliases ##

alias se="cd ~/code/simplenote-electron"
alias gae="cd ~/code/simplenote-gae"


## paths ##

# new (ARM) brew
fish_add_path /opt/homebrew/bin

# old brew / python
fish_add_path /usr/local/bin

# calibredb
fish_add_path /Applications/calibre.app/Contents/console.app/Contents/MacOS

# mysql
fish_add_path /usr/local/mysql/bin

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/kat/code/google-cloud-sdk/path.fish.inc' ]; . '/Users/kat/code/google-cloud-sdk/path.fish.inc'; end
# simplifying this to -->
fish_add_path $HOME/code/google-cloud-sdk/bin

## disabled paths ##

# for python
# set PATH /Users/kat/Library/Python/2.7/bin $PATH

# Setting PATH for Python 3.10
# set -x PATH "/Library/Frameworks/Python.framework/Versions/3.10/bin" "$PATH"


# nvm - now using jorgebucaran/nvm.fish instead
# set -gx NVM_DIR "$HOME/.nvm"
# https://riptutorial.com/node-js/example/17273/installing-with-node-version-manager-under-fish-shell-with-oh-my-fish-

# if status --is-interactive
#  . (rbenv init - | psub)
# end


## other config ##

set -x EDITOR nano
#set -Ux SIMPERIUM_CONFIG_OVERRIDE "$HOME/code/simperium_a8c/simperium.config"

pyenv init - | source

# GPG
set -gx GPG_TTY (tty)


# function update_pom --on-variable currentPomodoro
#   iterm2_set_user_var currentPomodoro $currentPomodoro
# end

# hub completion
# source ~/.config/fish/hub.fish_completion
