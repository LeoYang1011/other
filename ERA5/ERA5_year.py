#####################################################################################################
# this program can download a full year of data, and each month's data is stored in an .nc file.
# this program will run begin the line61,from the if statement
# the downloadYear can change to any year you want
#####################################################################################################   
#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
import time

def makeDate(downloadYear,monthStart,monthEnd):
    date = list()
    target = list()
    bigMonth = (1,3,5,7,8,10,12)
    smallMonth = (4,6,9,11)
    # make the target file name and date series
    # the format of target file is '2D_201001.nc'
    # the format of target file is 2010-01-01/to/2010-01-31
    # the following code automatically judge whether a month is bigMonth or smallMonth, so the corresponding end date is 30 or 31.
    # if the month is february, it also will be judged whether the downloadYear is leap year.
    totalMonthNum = monthEnd - monthStart + 1
    for index in range(totalMonthNum):
        target.append('2D_' + str(downloadYear) + str(index+monthStart).rjust(2,'0') + '.nc')
        dateLine = str(downloadYear) + '-' + str(index+monthStart).rjust(2,'0') + '-01/to/' + str(downloadYear) + \
                   '-' + str(index+monthStart).rjust(2,'0')
        if index+monthStart in bigMonth:
            date.append(dateLine + '-31')
        elif index+monthStart in smallMonth:
            date.append(dateLine + '-30')
        elif index+monthStart == 2:
            if ((downloadYear % 4 == 0) and (downloadYear % 100 != 0)) or downloadYear % 400 == 0:
                date.append(dateLine + '-29')
            else:
                date.append(dateLine + '-28')

    return (date,target)

def downloadData(date,target):
    # Basic control dictionary
    controlDict = {
        "class": "ea",
        "dataset": "era5",
        "date": "noDate",
        "direction": "1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24",
        "area": "38.5/119/29/131",
        "expver": "1",
        "frequency": "1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30",
        "number": "0",
        "param": "251.140",
        "stream": "ewda",
        "time": "00:00:00/03:00:00/06:00:00/09:00:00/12:00:00/15:00:00/18:00:00/21:00:00",
        "grid": "0.25/0.25",
        "format": "netcdf",
        "target": "noTarget"
        }
    months = len(date)
    for index in range(months):
        # change the "date" and "target" value in basic control dictionary
        controlDict["date"] = date[index]
        controlDict["target"] = target[index]
        server = ECMWFDataServer()
        server.retrieve(controlDict)
        # the program will pause 100 second
        time.sleep(100)

# this is the main function
if __name__ == '__main__':
    # you can change the 'downloadYear' 'monthStart' 'monthEnd' to any number you want
    downloadYear = 2010
    monthStart = 1
    monthEnd = 12
    # this function will generate date and file name according to the format requirements of ecmwf.
    (date,target) = makeDate(downloadYear,monthStart,monthEnd)
    # download files by month
    downloadData(date,target)