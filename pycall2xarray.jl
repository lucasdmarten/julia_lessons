import NCDatasets as nc

dataset = nc.Dataset("../WRF_4KM_2D/2021/12/wrf2D_D01_2021-12-11_080000.nc")
data = dataset["T2"][:,:]


@time println(size(exp.(data)))