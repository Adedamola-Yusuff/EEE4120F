image_sizes = [
    [800,600],   %SVGA
    [1280,720],  %HD
    [1920,1080], %Full HD
    [2048,1080], %2K Cinema
    [2560,1440], %2K QHD
    [3840,2160], %4K UHD
    [5120,2880], %5K
    [7680,4320]  %8K UHD
]

names = ["SVGA","HD","FullHD","2K","QHD","4K UHD","5K","8K UHD"];
workers = 2:6;

fprintf("Measuring parallel execution time for %s with %d workers", names(3), workers(3))