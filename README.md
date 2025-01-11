# Multi-Location Weather Forecasting Application
This application provides an easy and interactive way to track weather forecasts for multiple locations. Users can view, add, edit, or delete locations, with weather details like weekly highs and lows displayed visually using bar graphs.

# Features:
1. A homepage with a list of locations.
2. Create a new location with an ip address or zipcode.
3. View the highs and lows of the week and visualize them on a bar graph.
4. Edit or delete locations.
5. Frontend support for API error handling.
# Installation:
**Clone the repository:**

    git clone https://github.com/oliverwstevens/weather.git

**Change directory:**

    cd weather
**Install dependencies:**

    bundle install
**Apply migrations:**

    rails db:migrate
**Start the Rails server**

    rails s

**Open Browser and visit:**

    http://localhost:3000
# How to Use:

1. Homepage:
   Visit the homepage to see a list of all your locations.
   Click on a location to view its weather details.
2. View Weather Details:
   Observe the high and low temperatures for the week.
   Analyze the weather patterns using the bar graph.
3. Add a Location:
   Click the “New Location” button.
   Enter a valid ZIP code or IP address and submit the form.
   If the input is invalid, an error message will guide you to correct it.
4. Edit or Remove a Location:
   Select a location from the list.
   Use the "Edit" button to modify its details or the "Remove" button to remove it.
