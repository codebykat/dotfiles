function fish_right_prompt
    not set -q is_repainting && __right_prompt
    set -e is_repainting
end

function __right_prompt
    # first things first: we only do git repos here
    if not _is_git_repo
        return
    end

    # colors
    function _use_colors -a fg -a bg
        set -l colors (set_color normal) "\033[48;5;256m"
        if test -n "$fg[1]"
            set colors (set_color $fg)
        end

        if test -n "$bg[1]"
            set colors $colors (set_color -b $bg)
        end
        echo -n -s $colors
    end

    set -l porcelain $(git status --porcelain=v2 --branch --show-stash)

    string match -rgq '^# branch.head (?<branch>.*?)$' $porcelain
    string match -rgq '^# branch.upstream (?<remote>.*?)$' $porcelain
    string match -rgq '^# branch.ab \+(?<ahead>.*?) -(?<behind>.*?)$' $porcelain
    string match -rgq '^# stash (?<stashed>.*?)$' $porcelain

    set -l local_status

    # added files
    set -l added (string match -r '^. (?:\.A|A\.)' $porcelain)
    if test (count $added) -gt 0
        set local_status $local_status $icon_added (count $added)
    end

    # deleted
    set -l deleted (string match -r '^. (?:\.D|D\.)' $porcelain)
    if test (count $deleted) -gt 0
        set local_status $local_status $spacer $icon_deleted (count $deleted)
    end

    # modified
    set -l modified (string match -r '^. (?:\.[MRC]|[MRC]\.)' $porcelain)
    # set -l modified $(git status -s | grep -c -E "^.[MRC]")
    if test (count $modified) -gt 0
        set local_status $local_status $spacer $icon_modified (count $modified)
    end

    # untracked files
    set -l untracked $(git status -s | grep -c -E "^\?\?")
    if test $untracked -gt 0
        set local_status $local_status $spacer $icon_untracked $untracked
    end

    # stashed files
    if test -n "$stashed[1]"
        set local_status $local_status $spacer $icon_stashed $stashed
    end

    set -l status_color $color_normal
    if _is_git_dirty
        # set -l dirty "$yellow ✗"
        set status_color $color_changes
    end

    set -l upstream_status
    set -l upstream_status_color $color_normal

    # end arrow should be colored the same as the final segment
    set -l right_arrow_color $status_color

    if test -n "$ahead"
        if test $ahead -gt 0 -o $behind -gt 0
            set upstream_status_color $color_changes
            if test $ahead -gt 0
                set upstream_status $upstream_status $commits_ahead $ahead
            end
            if test $behind -gt 0
                set upstream_status $upstream_status $commits_behind $behind
            end
        else
            set upstream_status_color $color_clean
            set upstream_status (_use_colors black $color_clean) $spacer $clean_status $normal
        end
        set local_status $local_status $spacer
        set right_arrow_color $upstream_status_color
        set -l use_upstream_status_colors (_use_colors black $upstream_status_color)
        set upstream_status $use_upstream_status_colors $upstream_status $normal
    end

    set -l use_colors (_use_colors $color_normal)
    set -l use_inverted_colors (_use_colors black $color_normal)

    set -l use_status_colors (_use_colors $status_color $color_background)
    set -l use_inverted_status_colors (_use_colors black $status_color)

    set -l use_clean_status_colors (_use_colors $color_clean)
    set -l use_inverted_clean_status_colors (_use_colors black $color_clean)


    set -l icon $use_status_colors $giticon $normal
    set -l start_arrow $use_status_colors $left_divider $normal

    set -l divider
    if test -n "$upstream_status"
        if test $status_color = $upstream_status_color
            set divider (_use_colors black $status_color) $inner_divider $normal
        else
            set divider (_use_colors $upstream_status_color $status_color) $left_divider $normal
        end
    end
    set -l local_changes $use_inverted_status_colors $local_status $normal
    set -l end_arrow $normal (_use_colors $right_arrow_color black) $right_divider

    echo -n -s $icon $start_arrow $local_changes $divider $upstream_status $end_arrow $normal
    return
end
