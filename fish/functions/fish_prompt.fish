# using a nerd font - Meslo LGS Nerd Font proportional

# transient prompt - see https://github.com/fish-shell/fish-shell/pull/6427#issuecomment-565788121
# TODO - might be a better way to do this? https://github.com/zzhaolei/transient.fish/blob/main/conf.d/transient.fish
# --> however this breaks iTerm shell integration markers

# transient prompt helpers
function repaint_and_execute
    set -g is_repainting
    commandline -f repaint execute
end

function fish_user_key_bindings
    bind --preset \n repaint_and_execute
    bind --preset \r repaint_and_execute
end

# Run when the current directory changes.
function _setpwd --on-variable PWD
    # cwd, trimmed to last element (i.e. only the current folder)
    set -g short_pwd (string match -rg '.*\/(.*)' $PWD)
    # set -g short_pwd (pwd | awk -F / '{print $NF}') #slower
    # set -g short_pwd (basename (prompt_pwd)) # slowest
end

# Run when virtualenv is activated or deactivated
function _set_venv --on-variable VIRTUAL_ENV
    set -g venv
    set -g venv_segment

    if test -n "$VIRTUAL_ENV[1]"
        set venv (basename (echo $VIRTUAL_ENV))

        set -l use_inverted_venv_colors (set_color $color_background) (set_color -b $color_venv)
        # todo use inner divider if colors are the same
        set -l cwd_divider (set_color $fish_color_cwd) (set_color -b $color_venv) $left_divider
        set venv_segment $use_inverted_venv_colors $spacer $venv $spacer $cwd_divider $normal
    end
end

# git status helper functions
function _is_git_repo
    type -q git or return 1
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
end

function _is_git_dirty
    not command git diff-index --cached --quiet HEAD -- &>/dev/null
    or not command git diff --no-ext-diff --quiet --exit-code &>/dev/null
end

function fish_prompt
    # Use a simple prompt on dumb terminals.
    if [ "$TERM" = 'dumb' ]
        echo '> '
        return
    end

    if set -q is_repainting
        echo -n '➜ '
    else
        # use time __fancy_prompt to print execution time
        __fancy_prompt
    end
end

function __fancy_prompt
    # set -l __last_command_exit_status $status
    # TODO clear the error status somehow

    # this adds time and i never sudo so... skip it
    # if test (id -u) = 0
    #     if set -q fish_color_cwd_root
    #         set color_cwd $fish_color_cwd_root
    #     else
    #         set color_cwd $fish_color_cwd
    #     end
    #     set prompt_char '#'
    # end

    set -l use_cwd_colors (set_color $fish_color_cwd) (set_color -b $color_background)
    set -l use_inverted_cwd_colors (set_color $color_background) (set_color -b $fish_color_cwd)

    # if test $__last_command_exit_status != 0
    #     set arrow_color (set_color $fish_color_status)
    # end
    # set -l cwd_end_arrow $normal $arrow_color $divider

    set -l cwd_segment $use_inverted_cwd_colors $spacer $short_pwd $spacer $prompt_char $normal

    set -l start_arrow $use_inverted_cwd_colors $divider $normal
    if test -n "$VIRTUAL_ENV[1]"
        set start_arrow (set_color $color_background) (set_color -b $color_venv) $divider $normal
    end

    set -l end_arrow $use_cwd_colors $divider $normal $spacer

    echo -n -s $start_arrow $venv_segment $cwd_segment $end_arrow
end


### old versions
# function fish_prompt
    # Save the last status for later (do this before anything else)
    # set -l last_status $status

    # fishline -s $status PWD ARROW
    # powerline-shell --shell bare $status
    # iterm2_prompt_mark


    # __bobthefish_glyphs
    # __bobthefish_colors $theme_color_scheme

    # type -q bobthefish_colors
    # and bobthefish_colors

    # # Start each line with a blank slate
    # set -l __bobthefish_current_bg

    # # Status flags and input mode
    # __bobthefish_prompt_status $last_status

    # set -l real_pwd (__bobthefish_pwd)
    # set -l git_root_dir (__bobthefish_git_project_dir $real_pwd)

# end
