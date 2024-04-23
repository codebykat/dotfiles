#!/usr/bin/env python3
import iterm2
import os
import re
import time

# global variables to cache status
last_update = 0
status = ''

# icons
icon = '󰂄'

# nf-md-battery-outline, nf-md-battery_10 through nf-md-battery_90, nf-md-battery-full
discharging_icons = ['󰂎','󰁺','󰁻','󰁼','󰁽','󰁾','󰁿','󰂀','󰂁','󰂂','󰁹']

# nf-md-battery-charging_n
charging_icons = ['󰢟','󰢜','󰂆','󰂇','󰂈','󰢝','󰂉','󰢞','󰂊','󰂋','󰂅']

async def main(connection):
    battery_component = iterm2.StatusBarComponent(
        short_description="battery status",
	detailed_description="Show the battery status",
        knobs=[],
        exemplar="󰂂 85% | 10:50",
        update_cadence=60,
        identifier="com.codebykat.kat.iterm.status.battery")

    @iterm2.StatusBarRPC
    async def battery_callback(
        knobs
    ):
        global last_update
        global status

        # we don't really need to update the battery status more frequently than once per minute
        now = time.time()
        if(last_update and now - last_update < 60):
            return status

        last_update = now
        return _get_status()

    def _get_status():
        global last_update
        global regex
        global status

        pmstat = os.popen('pmset -g batt').read()
        m = regex.search(pmstat)
        if not m:
            last_update = None # don't cache a missing result
            return '🤔'
        percent = m.group('level')

        stat = m.group('status')
        # source = m.group('source')

        status_icon = icon
        status_percent = ''
        status_time = ''

         # don't display percent when fully charged
        if (stat != 'charged'):
            status_percent = f' {percent}%'

        # charging level icons
        if (stat == 'discharging'):
            status_icon = discharging_icons[round(int(percent) / 10)]
        elif (stat == 'charging'):
            status_icon = charging_icons[round(int(percent) / 10)]

        # time remaining to charge or discharge
        if m.group('time') and m.group('time') != '0:00':
            status_time = f' | {m.group("time")}'

        status = f'{status_icon}{status_percent}{status_time}'
        return status

    global regex
    regex = re.compile('''drawing from '(?P<source>.*?)'.*\n.*?(?P<level>\d+)%;\s?.*?(?P<status>.*?);.?(?:(?P<time>\S*) remaining)?''')

    await battery_component.async_register(connection, battery_callback)


iterm2.run_forever(main)
