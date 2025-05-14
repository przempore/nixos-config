if type "xrandr" > /dev/null; then
    PRIMARY=$(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1)
    OTHERS=$(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1)
    MONITOR=$PRIMARY polybar --reload mainbar &
    sleep 1
    for m in $OTHERS; do
      MONITOR=$m polybar --reload mainbar &
    done
else
    polybar --reload mainbar &
fi
