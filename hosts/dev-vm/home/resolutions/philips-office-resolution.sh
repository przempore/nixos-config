xrandr --newmode "3440x1440_60.00"  419.50  3440 3696 4064 4688  1440 1443 1453 1493 -hsync +vsync
xrandr --addmode Virtual-1 3440x1440_60.00

xrandr --output Virtual-1 --primary --mode 3440x1440_60.00 --pos 0x0 --rotate normal

feh --bg-fill $HOME/.background-image
