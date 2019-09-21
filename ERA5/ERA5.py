import cdsapi


def downloadData(year,qurter):

    controlDict = {
        'product_type': 'reanalysis',
        'format': 'netcdf',
        'variable': [
            'mean_direction_of_wind_waves', 'mean_wave_direction_of_first_swell_partition',
            'mean_wave_direction_of_second_swell_partition',
            'mean_wave_direction_of_third_swell_partition', 'mean_wave_period_based_on_second_moment_for_wind_waves',
            'mean_wave_period_of_first_swell_partition',
            'mean_wave_period_of_second_swell_partition', 'mean_wave_period_of_third_swell_partition',
            'significant_height_of_wind_waves',
            'significant_wave_height_of_first_swell_partition', 'significant_wave_height_of_second_swell_partition',
            'significant_wave_height_of_third_swell_partition',
            'wave_spectral_directional_width_for_swell', 'wave_spectral_directional_width_for_wind_waves',
            'wave_spectral_peakedness',
            'wave_spectral_skewness'
        ],
        'year': '2000',
        'month': [
            '01', '02', '03'
        ],
        'day': [
            '01', '02', '03',
            '04', '05', '06',
            '07', '08', '09',
            '10', '11', '12',
            '13', '14', '15',
            '16', '17', '18',
            '19', '20', '21',
            '22', '23', '24',
            '25', '26', '27',
            '28', '29', '30',
            '31'
        ],
        'time': [
            '00:00', '01:00', '02:00',
            '03:00', '04:00', '05:00',
            '06:00', '07:00', '08:00',
            '09:00', '10:00', '11:00',
            '12:00', '13:00', '14:00',
            '15:00', '16:00', '17:00',
            '18:00', '19:00', '20:00',
            '21:00', '22:00', '23:00'
        ]
    }

    controlDict['year'] = str(year)
    if qurter == 1:
        controlDict['month'] = ['01','02','03']
    elif qurter == 2:
        controlDict['month'] = ['04', '05', '06']
    elif qurter == 3:
        controlDict['month'] = ['07', '08', '09']
    elif qurter == 4:
        controlDict['month'] = ['10', '11', '12']

    fileName = str(year) +'_' + str(qurter) + '.nc'

    c = cdsapi.Client()
    c.retrieve('reanalysis-era5-single-levels',controlDict,fileName)


# this is the main function
if __name__ == '__main__':
    yearStart = 2000
    yearEnd = 2005   # Do not download data for yearEnd
    for year in range(yearStart,yearEnd):  # Only download the data from yearStar to yearEnd-1
        for quarter in range(4):
            quarter += 1
            print('Downloading data for the ' + str(quarter) + ' quarter of ' + str(year))
            downloadData(year,quarter)