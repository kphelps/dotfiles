# This deals with dbus, etc.
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# The the .Xresources, I have more config in there.
xrdb ~/.Xresources

# Set the DPI. On Macbook Pro's, the screen is 226ppi, but I like to have
# everything a little bit smaller.
xrandr --dpi 220
xrdb ~/.Xresources.hidpi
# Double the GTK+3 widget scale. NOTE: You must set the GTK+3 font to half size
# due to a bug in GTK+3 that the devs I talked to wont acknowledge.
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5
# Do the same with Qt5, the other Qt/KDE options do general things to make Qt5
# apps look/run better.
#export QT_DEVICE_PIXEL_RATIO=2
export QT_STYLE_OVERRIDE=Breeze
export KDE_FULL_SESSION=1
export KDE_SESSION_VERSION=5
export SAL_USE_VCLPLUGIN=kde5
xset +fp /home/kphelps/.fonts
xset fp rehash
xrandr --output eDP1 --auto
i3
