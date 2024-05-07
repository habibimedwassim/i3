#!/usr/bin/python

import dbus
import os
import sys

try:
    bus = dbus.SessionBus()
    spotify = bus.get_object("org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")

    if os.environ.get('BLOCK_BUTTON'):
        control_iface = dbus.Interface(spotify, 'org.mpris.MediaPlayer2.Player')
        if os.environ['BLOCK_BUTTON'] == '1':
            control_iface.Previous()
        elif os.environ['BLOCK_BUTTON'] == '2':
            control_iface.PlayPause()
        elif os.environ['BLOCK_BUTTON'] == '3':
            control_iface.Next()
        elif os.environ['BLOCK_BUTTON'] == '4':
            # Increase volume
            volume_iface = dbus.Interface(spotify, 'org.freedesktop.DBus.Properties')
            current_volume = volume_iface.Get('org.mpris.MediaPlayer2.Player', 'Volume')
            volume_iface.Set('org.mpris.MediaPlayer2.Player', 'Volume', min(current_volume + 0.1, 1.0))
        elif os.environ['BLOCK_BUTTON'] == '5':
            # Decrease volume
            volume_iface = dbus.Interface(spotify, 'org.freedesktop.DBus.Properties')
            current_volume = volume_iface.Get('org.mpris.MediaPlayer2.Player', 'Volume')
            volume_iface.Set('org.mpris.MediaPlayer2.Player', 'Volume', max(current_volume - 0.1, 0.0))

    spotify_iface = dbus.Interface(spotify, 'org.freedesktop.DBus.Properties')
    props = spotify_iface.Get('org.mpris.MediaPlayer2.Player', 'Metadata')

    if sys.version_info > (3, 0):
        print(str(props['xesam:artist'][0]) + " - " + str(props['xesam:title']))
    else:
        print(props['xesam:artist'][0] + " - " + props['xesam:title']).encode('utf-8')
except dbus.exceptions.DBusException:
    exit