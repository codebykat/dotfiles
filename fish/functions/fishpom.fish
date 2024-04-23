# todo later: https://fishshell.com/docs/current/language.html#variables-argv
# custom duration
# pomo description
# read from / write to .pomodoro file

# TODO
# figure out how to access iTerm variable from shell (tty / signals)

# fishpom add 5
# fishpom pause
# fishpom resume
#  fishpom [reset | restart] -- Cancel the timer and start a new one

# with iterm2 utilities installed, it2getvar user.currentPomodoro will get the current value

function fishpom --description 'fish pomodoro'
	set -l usage_string "Usage:
  fishpom -- Display pomodoro status
  fishpom [-d duration] [-t task] [-u until] -- Start a new pomodoro
  fishpom [start | new] [-d duration] [-t task] [-u until] -- Start a new pomodoro
  fishpom status -- Display pomodoro status
  fishpom cancel -- Cancel the timer
  fishpom [done | end | finish | stop] -- Complete a pomodoro
  fishpom [-h | --help] -- Display this message"

    argparse -x d,u h/help 'd/duration=!_validate_int --min 0' t/task= u/until= -- $argv
	or echo -n $usage_string && return

	set -q _flag_help && echo -n $usage_string && return 0

	set -l currentPomodoro (it2getvar user.currentPomodoro)
	set -l currentPomodoroTask (it2getvar user.currentPomodoroTask)

	set -lx cmd $argv[1]

	# implicit cmd
	# if $cmd = '' and -u or -d are set, treat it as "start"
	if test -z "$cmd"
		if test -n "$_flag_duration$_flag_until" # TODO how does set -q work with multiple vars?
			set cmd "start"
		end
		if set -q _flag_task
			set cmd "amend"
		end
	end

	switch $cmd
	# case break
	# 	echo take a break
	case amend
		if not test -n "$currentPomodoro"
			echo "No pomodoro running"
		else
			if set -q _flag_until
				# TODO set date to tomorrow if time is < now
				echo -e "setting pomodoro to expire at $_flag_until"
				set pomoExpires (date -j (string replace -ra ':' '' $_flag_until) +%s)
				# set -l expiration (date -j -f "%H:%M" (string replace -ra ':' '' $_flag_until))
				# set pomoExpires (date -j -f "%H:%M" (string replace -ra ':' '' $_flag_until) +%s)
			end
			if set -q _flag_duration
				set pomoDuration $_flag_duration
				echo -e "setting pomodoro for $pomoDuration minutes"
				set pomoExpires (date -v $(printf "+%dM" $pomoDuration) +%s)
			end
			if set -q _flag_task
				echo -e "setting task to $_flag_task"
				iterm2_set_user_var currentPomodoroTask $_flag_task
			end
		end
	case clear reset cancel
		if not test -n "$currentPomodoro"
			echo "No pomodoro running"
		else
			echo clearing pomodoro
			iterm2_set_user_var currentPomodoro
			# iterm2_set_user_var currentPomodoroTask
		end
	case finish done end stop
		if not test -n "$currentPomodoro"
			echo "No pomodoro running"
		else
			# todo: write to log
			# convert timestamp to logfmt: (date -jf "+%Y-%m-%dT%H:%M:%S%z" $currentPomodoro | sed 's@^.\{22\}@&:@')
			echo ending pomodoro
			iterm2_set_user_var currentPomodoro
			# iterm2_set_user_var currentPomodoroTask
		end
	case start new
		if test -n "$currentPomodoro"
			echo already started
		else
			set -l pomoDuration 25
			set -l pomoExpires

			if set -q _flag_until
				# TODO set date to tomorrow if time is < now
				echo -e "starting pomodoro until $_flag_until"
				set pomoExpires (date -j (string replace -ra ':' '' $_flag_until) +%s)
				# set -l expiration (date -j -f "%H:%M" (string replace -ra ':' '' $_flag_until))
				# set pomoExpires (date -j -f "%H:%M" (string replace -ra ':' '' $_flag_until) +%s)
			else
				if set -q _flag_duration
					set pomoDuration $_flag_duration
				end
				echo -e "starting pomodoro for $pomoDuration minutes"
				set pomoExpires (date -v $(printf "+%dM" $pomoDuration) +%s)
			end

			if set -q _flag_task
				echo -e "setting task to $_flag_task"
				iterm2_set_user_var currentPomodoroTask $_flag_task
			end

			# set -U currentPomodoro (date +%s)
			# set -U currentPomodoro (date '+%Y-%m-%dT%H:%M:%S%z' | sed 's@^.\{22\}@&:@')
			iterm2_set_user_var currentPomodoro $pomoExpires
		end
	case status ''
		if test -n "$currentPomodoro"
			set -l now (date +%s)

			# pomo expired
			if test "$now" -gt $currentPomodoro
				echo "Pom has finished"
			else # pomo running
				set -l secondsRemaining (math $currentPomodoro - $now)
				echo (math -s0 $secondsRemaining / 60):(string pad --char=0 -w2 (math $secondsRemaining % 60))
				if test -n "$currentPomodoroTask"
					echo $currentPomodoroTask
				end
			end
		else
			echo "No pomodoro active"
		end
	case '*'
		echo -e -s "Unrecognized argument $cmd"
	end
end
