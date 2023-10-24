import netCDF4 as nc
import time
import numpy as np

dt = 0
for i in range(0,99)
    dataset = nc.Dataset("../WRF_4KM_2D/2021/12/wrf2D_D01_2021-12-11_080000.nc")
    data = dataset["T2"][:]

    t1 = time.time()
    print(np.exp(data).shape)
    print(time.time()-t1)
