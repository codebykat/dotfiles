#!/usr/bin/env python3

import iterm2
import asyncio
import time

# iTerm Pomodoro timer
# Uses an iTerm global variable that acts as a singleton (is synced between sessions)

# filename = "~/.pomodoro/current"
# to pause running pomodoro:
# - move ~/.pomodoro/current to ~/.pomodoro/paused

# to resume:
# - move paused to current
# - add timediff?? between when it was paused and now

# pause and resume?
# paused_at timestamp
# when paused - set paused_at timestamp to now()
# when resumed - calculate time paused, add to pomodoro expiration time
# auto-resume?
# interface:
# - pom pause (indefinite pause)
# - pom pause 5 (5 minute break)
# - pom resume (resume paused timer)
# - pom start (resume if paused)

# - pom start (start 25 minute timer)
# - pom start 10 (start 10 minute timer)
# - pom until 15:00 (start timer with provided end time)

# - pom cancel (cancel timer)
# - pom stop / end (finish timer)

# - pom start -t "task description"

# editing an existing timer
# - pom add 5 (add 5 minutes)
# - pom reset (reset to 25m)?
# - pom task "task description"


# icon_pom_end = '󱫪' # nf-md-timer-stop
# icon_pom_start = '󰅐' # nf-md-clock_outline
# icon_pom_end = '󰅐' #nf-md-clock-outline
# icon_pom_expired = '󰗎' # nf-md-clock_alert_outline
# icon_pom_expired = '󱫑' # nf-md-timer_check_outline
icon_pom_expired = '󰦕' #nf-md-progress_alert
# icon_pom_end = '󱫫' #nf-md-timer_stop_outline
# icon_pom_pause = '󱫟' #nf-md-timer_pause_outline
# icon_pom_start = '󱫡' #nf-md-timer_play_outline
# icon_pom_start = '󰔛' #nf-md-timer_outline
icon_pom_start = '󰅐'
# icon_pom_end = '󰔛' #nf-md-timer_outline
# icon_pom_start = '󰦖' #nf-md-progress_clock

# nf-md-clock_time_N_outline for N=one through twelve
icon_ticking = ['󱑋','󱑌','󱑍','󱑎','󱑏','󱑐','󱑑','󱑒','󱑓','󱑔','󱑕','󱑖']
# these are reversed
# icon_ticking = ['\U000f1456', '\U000f1455', '\U000f1454', '\U000f1453', '\U000f1452', '\U000f1451', '\U000f1450', '\U000f144f', '\U000f144e', '\U000f144d', '\U000f144c', '\U000f144b']

timer_variable = 'user.currentPomodoro'

async def main(connection):
    app = await iterm2.async_get_app(connection)

    pomodoro_component = iterm2.StatusBarComponent(
        short_description="pomodoro status",
        detailed_description="Show the pomodoro status",
        knobs=[],
        exemplar=f"{icon_pom_start} 25:00",
        update_cadence=1,
        identifier="com.codebykat.kat.iterm.status.pomodoro")

    # Set the click handler
    @iterm2.RPC
    async def onclick(session_id):
        # session = app.get_session_by_id(session_id)
        # current_pomodoro = await session.async_get_variable("user.currentPomodoro")
        current_pomodoro = await app.async_get_variable(timer_variable)
        if(current_pomodoro):
            await app.async_set_variable(timer_variable, None)
        else:
            now = int(time.time())
            await app.async_set_variable(timer_variable, now + (25 * 60))
            # await app.async_invoke_function('fish -c "set -U currentPomodoro"')
            # os.popen(f'/opt/homebrew/bin/fish -C "set -Ux currentPomodoro {now}"')
            # await session.async_send_text(f'fishpom start 1>/dev/null\n')

    @iterm2.StatusBarRPC
    async def pomodoro_statusbar_callback(
        knobs,
        current_pomodoro=iterm2.Reference(f"iterm2.{timer_variable}?"),
        # current_pomodoro=iterm2.Reference("user.currentPomodoro?"),
        # current_pomodoro_task=iterm2.Reference("user.currentPomodoroTask?"),
    ):
        # current_pomodoro = await app.async_get_variable("user.currentPomodoro")

        # update variable across all sessions
        # await _set_global_var(current_pomodoro)

        if(current_pomodoro in [None, False, '']):
            return f'{icon_pom_start}'

        return _get_status(int(current_pomodoro), '')

    def _get_status(pomodoro_expires_at, pomodoro_task='') -> str:
        current_time = int(time.time())
        time_left = pomodoro_expires_at - current_time

        if(time_left > 0):
            m, s = divmod(time_left, 60)
            h, m = divmod(m, 60)
            tick = (s % 12) - 1
            icon = icon_ticking[tick]
            if(h > 0):
                status = f'{pomodoro_task}{h:d}:{m:02d}:{s:02d} {icon}'
            else:
                status = f'{pomodoro_task}{m:01d}:{s:02d} {icon}'
        else:
            if(current_time % 2): # blink the divider
                status = f'00:00 {icon_pom_expired}'
            else:
                status = f'00 00 {icon_pom_expired}'
        return status

    async def register_pomodoro_component():
        await pomodoro_component.async_register(connection, pomodoro_statusbar_callback, onclick=onclick)


    # When a timer is set in any session (e.g. by a shell script), propagate it globally
    async def monitor_session_variables():
        async def on_session_start(session_id):
            # initially set the variable from the global session
            session = app.get_session_by_id(session_id)
            current_pomodoro = await app.async_get_variable(timer_variable)
            await session.async_set_variable(timer_variable, current_pomodoro)

            # monitor for changes to the session variable
            async with iterm2.VariableMonitor(connection, iterm2.VariableScopes.SESSION, timer_variable, 'active') as mon:
                while True:
                    # Block until variable changes
                    pom = await mon.async_get()

                    # set the variable globally
                    await app.async_set_variable(timer_variable, pom)

        await (iterm2.EachSessionOnceMonitor.async_foreach_session_create_task(app, on_session_start))

    async def monitor_global_variable():
        # monitor for changes to the global variable
        async with iterm2.VariableMonitor(connection, iterm2.VariableScopes.APP, timer_variable, None) as mon:
            while True:
                # Block until variable changes
                pom = await mon.async_get()

                # set the variable in every session
                for window in app.windows:
                    for tab in window.tabs:
                        for session in tab.sessions:
                            await session.async_set_variable(timer_variable, pom)


    # register the status bar component
    asyncio.create_task(register_pomodoro_component())

    # monitor session variables for changes
    asyncio.create_task(monitor_session_variables())

    # monitor global variable for changes
    asyncio.create_task(monitor_global_variable())

iterm2.run_forever(main)
