# disable virtualenv in prompt
set -g VIRTUAL_ENV_DISABLE_PROMPT 'disable'

set -g normal (set_color normal)
set -g pale_gold "dad085"

# colors
set -g normal (set_color normal)

set -g color_venv $pale_gold

set -g color_normal brmagenta
set -g color_clean brgreen
set -g color_changes $pale_gold
set -g color_conflict brred


#### prompt characters
set -g prompt_char '➜'
set -g spacer ' ' # unicode thin space

# both left and right edges of left prompt
set -g divider ''

# left and right edges of right prompt
set -g left_divider ''
# set -g left_divider ''
# set -g left_divider ''
set -g right_divider ''
# set -g right_divider ''

# to split two segments with the same color
set -g inner_divider ''

# git status
set -g giticon ''
set -g clean_status " "
# set -g commits_ahead '󰁞'
set -g commits_ahead '󰁝'
# set -g commits_ahead ''
set -g commits_behind '󰁅'
# set -g commits_behind ''
set -g icon_stashed 'ƨ'
# suitcase = 󱖌
# text = 󰦪
# pencil = 󰲶
# menu = 󰍜
# inbox = 󱉳
# layers = 󰽙
# archive box = 󱉚
# other layers = 
# file cabinet = 󰪶

set -g icon_added '+'
set -g icon_deleted '-'
set -g icon_modified '~'
set -g icon_untracked '?'


# fallbacks
# if test "$TERM_PROGRAM" != 'iTerm.app'
	# set spacer ' '
	# set giticon ''
	# set clean_status "✔ "
	# set left_divider ' '
	# set right_divider ' '
	# set inner_divider '/'
	# set commits_ahead '«'
	# set commits_behind '»'
# end
