import os
import glob
import time
from multiprocessing import Pool
from PIL import Image


def convert(imgFile):
    im = Image.open(imgFile)
    im.save('save/' + imgFile[0:imgFile.find(".")] + '.jpg')



if __name__ == '__main__':
    start = time.clock()

    imgFiles = glob.glob('*.bmp')
    os.mkdir('save')

    pool = Pool(processes=12)
    pool.map(convert, imgFiles)
    pool.close()
    pool.join()
    end = time.clock()

    print('Conversion completed in: ' + str(end - start) + ' s')

