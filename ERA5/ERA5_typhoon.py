#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
import time

def makeDate(typehoonFileName):
    date = list()
    target = list()
    typehoonFile = open(typehoonFileName,'r')
    lineNum = 0
    for eachLine in typehoonFile:
        lineNum += 1
        tempLine = eachLine.split()
        if lineNum > 2 and len(tempLine) != 0:
            target.append(tempLine[0] + '.np')
            date.append(tempLine[1] + '-' + tempLine[2].rjust(2,'0') + '-' +  tempLine[3].rjust(2,'0') +'/to/' + \
                        tempLine[1] + '-' + tempLine[4].rjust(2, '0') + '-' +  tempLine[5].rjust(2, '0'))

    return (date,target)


def downloadData(date,target):
    # Basic control dictionary
    controlDict = {
        "class": "ea",
        "dataset": "era5",
        "date": "2008-04-13/to/2008-04-19",
        "area": "26.5/105.0/2.0/124.0",
        "expver": "1",
        "levtype": "sfc",
        "number": "0",
        "param": "34.128/151.128/165.128/166.128",
        "stream": "enda",
        "time": "00:00:00/03:00:00/06:00:00/09:00:00/12:00:00/15:00:00/18:00:00/21:00:00",
        "type": "an",
        "grid": "0.125/0.125",
        "format": "netcdf",
        "target": "0802.SEA"
        }
    days = len(date)
    for index in range(days):
        controlDict["date"] = date[index]
        controlDict["target"] = target[index]
        server = ECMWFDataServer()
        server.retrieve(controlDict)
        time.sleep(100)

if __name__ == '__main__':
    typehoonFileName = 'Typhoon.SEA'
    (date,target) = makeDate(typehoonFileName)
    downloadData(date,target)
