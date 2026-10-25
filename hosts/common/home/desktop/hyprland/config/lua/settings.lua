hl.config({
    input = {
        kb_layout = "real-prog-dvorak,us",
        follow_mouse = 1,
        repeat_delay = 250,
        repeat_rate = 50,
        touchpad = {
            natural_scroll = true,
        },
    },
    general = {
        gaps_in = 4,
        gaps_out = 4,
        border_size = 2,
        col = {
            active_border = {
                colors = { "rgba(f5c2e7aa)", "rgba(cba6f7aa)" },
                angle = 45,
            },
            inactive_border = "rgba(313244aa)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            noise = 0.01,
            vibrancy = 0.2,
            passes = 4,
            size = 7,
            popups = true,
            popups_ignorealpha = 0.2,
        },
        shadow = {
            enabled = true,
            color = 0x55000000,
            offset = { 0, 15 },
            range = 100,
            render_power = 2,
            scale = 0.97,
        },
    },
    dwindle = {
        preserve_split = true,
        split_width_multiplier = 0.75,
    },
    layout = {
        single_window_aspect_ratio = { 16, 10 },
    },
    animations = {
        enabled = false,
    },
})
