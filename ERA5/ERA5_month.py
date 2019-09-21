#####################################################################################################
# this program can download one month of data, and each day's data is stored in an .nc file.
# this program will run begin the line67,from the if statement
# the downloadYear can change to any year you want
#####################################################################################################   
#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
import time

def makeDate(downloadYear,downloadMonth,dayStart,dayEnd):
    date = list()
    target = list()
    bigMonth = (1,3,5,7,8,10,12)
    smallMonth = (4,6,9,11)
    targetLine = '2D_' + str(downloadYear) + str(downloadMonth).rjust(2,'0')
    dateLine = str(downloadYear) + '-' + str(downloadMonth).rjust(2,'0') + '-'
    # make the target file name and date series
    # the format of target file is '2D_20100101.nc'
    # the format of target file is 2010-01-01
    # the following code automatically judge whether a month is bigMonth or smallMonth, so the corresponding end date is 30 or 31.
    # if the month is february, it also will be judged whether the downloadYear is leap year.
    if downloadMonth in bigMonth:
        if dayEnd > 31:
            dayEnd = 31
    elif downloadMonth in smallMonth:
        if dayEnd > 30:
            dayEnd = 30
    elif downloadMonth == 2:
        if ((downloadYear % 4 == 0) and (downloadYear % 100 != 0)) or downloadYear % 400 == 0:
            if dayEnd > 29:
                dayEnd = 29
        else:
            if dayEnd > 28:
                dayEnd = 28
    totalDayNun = dayEnd - dayStart + 1
    for index in range(totalDayNun):
        date.append(dateLine + str(index+dayStart).rjust(2,'0'))
        target.append(targetLine + str(index+dayStart).rjust(2,'0') + '.nc')


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
    days = len(date)
    for index in range(days):
        # change the "date" and "target" value in basic control dictionary
        controlDict["date"] = date[index]
        controlDict["target"] = target[index]
        server = ECMWFDataServer()
        server.retrieve(controlDict)
        # the program will pause 100 second
        time.sleep(100)

# this is the main function
if __name__ == '__main__':
    # you can change the 'downloadYear' 'downloadMonth' 'dayStart' 'dayEnd'  to any number you want
    downloadYear = 2010
    downloadMonth = 3
    dayStart = 1
    dayEnd = 31
    # this function will generate date and file name according to the format requirements of ecmwf.
    (date,target) = makeDate(downloadYear,downloadMonth,dayStart,dayEnd)
    # download files by month
    downloadData(date,target)