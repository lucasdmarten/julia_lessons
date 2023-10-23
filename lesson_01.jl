import NCDatasets as nc
using FStrings
import Dates as datetime
using LinearAlgebra
using Plots


@info "Start lesson 01"

dateobj = datetime.DateTime(2021,12,1)
@info dateobj

lon, lat = -53, -32
values_ur, values_hi, times = [], [], []


function get_indexes(latitudes, longitudes, lat, lon)
    latvals = [deg2rad(lat) for lat in latitudes]
    lonvals = [deg2rad(lon) for lon in longitudes]
    lat0_rad = deg2rad(lat)
    lon0_rad = deg2rad(lon)
    
    minindex_x = argmin(abs.(latvals .- lat0_rad))
    minindex_y = argmin(abs.(lonvals .- lon0_rad))
    
    return minindex_x, minindex_y
end

function zfill_python(X, pad, strfill)
    @info "In zfill_python...."
    return lpad(X, pad, strfill)
end

function open_netcdf(dataset::nc.Dataset)
    dataarray = dataset["T2"][:,:]
    times = dataset["Time"][:,:]

    latitudes = dataset["XLAT"][1,:]
    longitudes = dataset["XLONG"][:,1]

    return dataarray, times, latitudes, longitudes
end

function vapour_pressure(temperature)
    return 6.108 * exp.((17.27 .* temperature) ./ (temperature .+ 273.3))
end

function heat_index(temperature, relative_humidity)
    temperature = (temperature .* 1.8) .+ 32
    st = -42.379 .+ (2.04901523 .* relative_humidity)  .+ (10.14333127 .* relative_humidity)  .+ (-0.22475541 .* temperature .* relative_humidity)  .+ (-6.883783 .* 0.001 .* (temperature .^ 2)) .+ (-5.481717 .* 0.01 .* (relative_humidity .^ 2)) .+ (1.22874 .* 0.001 .* (temperature .^ 2) .* relative_humidity) .+ (8.5282 .* 0.0001 .* temperature .* (relative_humidity .^ 2)) .+ (-1.99 .* 0.000001 .* (temperature .^ 2) .* (relative_humidity .^ 2))
    st[st .< temperature] = temperature[st .< temperature]
    st = (st .- 32) ./ 1.8
    return st
end

values_temperature = []
values_pottemperature = []
values_press = []
values_mixratio = []
times = []



for i in 1:100
    date = dateobj + datetime.Hour(i)
    input_file = datetime.Dates.format(date, f"yyyy/mm/wrf2D_D01_yyyy-mm-dd_HH0000.nc")

    path_to = dirname(input_file)
    
    @info "$date - In loop..."

    if isfile(input_file)   
        try
            dataset = nc.Dataset(input_file)
            @info "Open: $input_file"

            temperature = dataset["T2"][:,:] .- 273.15
            pottemperature = dataset["TH2"][:,:] .- 273.15
            pressure = dataset["PSFC"][:,:] ./ 100
            mixratio = dataset["Q2"][:,:] .* 1000    

            _times = dataset["Time"][:,:]
            latitudes = dataset["XLAT"][1,:]
            longitudes = dataset["XLONG"][:,1]

            @info "Getting data from $input_file"

            mkpath("$path_to/temperature_plots")
            mkpath("$path_to/pottemperature_plots")
            mkpath("$path_to/pressure_plots")
            mkpath("$path_to/mixratio_plots")
            
            @info "Gen maps temperature"
            heatmap(latitudes, longitudes, temperature[:,:,1], yflip=true, clims=(0,40))
            savefig("$path_to/temperature_plots/temperature_$i.png")

            #@info "Gen maps pottemperature"
            #heatmap(latitudes, longitudes, pottemperature[:,:,1], yflip=true) #, clims=(50,100))
            #savefig("$path_to/pottemperature_plots/pottemperature_$i.png")

            @info "Gen maps pressure"
            heatmap(latitudes, longitudes, pressure[:,:,1], yflip=true, clims=(800,1050))
            savefig("$path_to/pressure_plots/pressure_$i.png")

            #@info "Gen maps mixratio"
            #heatmap(latitudes, longitudes, mixratio[:,:,1], yflip=true, clims=(50,100))
            #savefig("$path_to/mixratio_plots/mixratio_$i.png")

            
            @info "Getting the values from lat: $lat and lon: $lon"
            minindex_x, minindex_y = get_indexes(latitudes, longitudes, lat, lon)

            val_temperature = temperature[minindex_x, minindex_y]
            val_pottemperature = pottemperature[minindex_x, minindex_y]
            val_press = pressure[minindex_x, minindex_y]
            val_mixratio = mixratio[minindex_x, minindex_y]

            append!(values_temperature, val_temperature)
            append!(values_pottemperature, val_pottemperature)

            append!(values_press, val_press)
            append!(values_mixratio, val_mixratio)

            append!(times, i)

            @info "extract val_temperature $val_temperature"
            @info "extract val_pottemperature $val_pottemperature"

            @info "extract val_press $val_press"
            @info "extract val_mixratio $val_mixratio"

        catch
            @warn "Cannot open netcdf $input_file"

        end

    else
        @info "is not file valid..."

    end
end

plot(times,[val_temperature val_press])
@info "plotting"
savefig("./plot.png")