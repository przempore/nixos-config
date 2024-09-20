local M = {}

-- Load the os module to get the current date
local os = require("os")

-- Create a table for month names
local month_names = {
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
}

-- Create a table for day names
local day_names = {
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
}

-- Function to get formatted date
function M.get_formatted_path()
    -- Get the current date
    local current_time = os.time()
    local date_table = os.date("*t", current_time)

    -- Format the date string
    local formatted_date = string.format(
        "%04d/%02d-%s/",
        date_table.year,
        date_table.month,
        month_names[date_table.month]
    )

    return formatted_date
end

function M.get_filename()
    -- Get the current date
    local current_time = os.time()
    local date_table = os.date("*t", current_time)

    -- Format the date string
    local formatted_date = string.format(
        "%04d-%02d-%02d-%s",
        date_table.year,
        date_table.month,
        date_table.day,
        day_names[date_table.wday]
    )

    return formatted_date
end

return M
