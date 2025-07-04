xrandr --newmode "3840x1600_60.00"  521.75  3840 4128 4544 5248  1600 1603 1613 1658 -hsync +vsync
xrandr --addmode Virtual-1 3840x1600_60.00

xrandr --output Virtual-1 --primary --mode 3840x1600_60.00 --pos 0x0 --rotate normal
