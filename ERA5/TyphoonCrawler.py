import urllib.request
from bs4 import BeautifulSoup
import re
import os
import time

# open the url and read
def getHtml(url):
    req = urllib.request.Request(url)
    req.add_header('User-Agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.92 Safari/537.36')
    page = urllib.request.urlopen(req)
    html = page.read().decode('UTF-8')
    page.close()
    return html

# compile the regular expressions and find
# all stuff we need
def getUrl(html):
    name = r'\/tropical_cyclones\/\d{4}_\d{4}\/jtwc\/tropical_cyclone_[\/\-a-zA-Z0-9]+.htm'
    urlName = re.compile(name)
    NameList = urlName.findall(html)
    urlList = list()
    for eaceName in NameList:
        urlList.append('http://australiasevereweather.com'+eaceName)
    return(urlList)

def getFile(url,num):
    fileName = url.split('/')[-1].split('_')[-1]
    fileName = fileName.replace('htm','txt')
    fileName = "No" + str(num) + "_" + fileName
    req = urllib.request.Request(url)
    req.add_header('User-Agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.92 Safari/537.36')
    page = urllib.request.urlopen(req)
    soup = BeautifulSoup(page,"html.parser")
    table = soup.p.table.tr.td.pre.contents[0]
    table = table.split('\n')
    #print(text)
    file = open(fileName, 'w')
    for eachLine in table:
        file.write(eachLine)
        file.write('\n')
    #file.write(str(soup.p.table.tr.td.pre.contents))
    file.close()
    page.close()
    print("No." + str(num) + " : Sucessful to download" + " " + fileName)


rawUrl = 'http://australiasevereweather.com/cyclones/summary_jtwc.htm'
html = getHtml(rawUrl)
urlList = getUrl(html)
print(len(urlList))

if os.path.exists('Typhoon_download'):
    pass
else:
    os.mkdir('Typhoon_download')
os.chdir(os.path.join(os.getcwd(), 'Typhoon_download'))

num = 1
for eachUrl in urlList:
    if num == 698:
        num += 1
        continue
    else:
        getFile(eachUrl,num)
        num += 1
        time.sleep(8)