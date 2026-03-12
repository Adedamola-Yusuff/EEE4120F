% =========================================================================
% Practical 2: Mandelbrot-Set Serial vs Parallel Analysis
% =========================================================================
%
% GROUP NUMBER:
%
% MEMBERS:
%   - Member 1 Name, Student Number
%   - Member 2 Name, Student Number

%% ========================================================================
%  PART 1: Mandelbrot Set Image Plotting and Saving
%  ========================================================================
%  Inputs:
%       mandelbrot_matrix   :  2D matrix of iteration counts
%       filename            :  name of file to save image to
% DONE: Implement Mandelbrot set plotting and saving function
function mandelbrot_plot(mandelbrot_matrix, filename)
    % Create a new figure
    figure;
    
    % Plot the matrix as an image
    imagesc(mandelbrot_matrix)

    % Ensures that the pixels aren't stretched
    axis equal;

    % Fills the axes box tightly around the data by setting the axis lmits
    % equal to the range of the data
    axis tight;
    
    % We don't really want to see the axes. Also, it would just look nice
    % in the report
    axis off;

    % Controls the coloring of iteration values. Could also use
    % colormap(pink) and others although these two were the best
    colormap("turbo");
    colorbar;

    % Add title
    title('Mandelbrot Set');

    % Save the figure to file
    saveas(gcf, filename);
    close(gcf);
end

%% ========================================================================
%  PART 2: Serial Mandelbrot Set Computation
%  ========================================================================`
%  Inputs:
%       width          => Contributes to the resolution of the image. This
%       is essentially how many pixels the image is broken up into
%       horizontally
%
%       height         => Also contributes to the resolution of the image
%       and is ho many pixels the image is broken up into vertically
%
%       max_iterations => This number is the point at which we're saying "if
%       the magnitude doesn't surpass 2 once we've reached this many
%       iterations, it never will". Obviously, this is an estimation.
% DONE: Implement serial Mandelbrot set computation function
function [mandel] = mandelbrot_serial(width, height, max_iterations)
    % Coordinate limits
    xmin = -2.0;
    xmax = 0.5;
    ymin = -1.2;
    ymax = 1.2;

    % Preallocate matrix (important for performance)
    mandel = zeros(height, width);

    % Loop over pixels
    for ix = 1:width
        for iy = 1:height

            % Mapping each pixel to the complex plane area represented by
            % xmin, xmax, ymin and ymax
            x0 = xmin + (ix-1)*(xmax-xmin)/(width-1);
            y0 = ymin + (iy-1)*(ymax-ymin)/(height-1);

            % Initial conditions are 0 since the equation is initially
            % f_c(z) = z^2 + c, where c is the complex value represented by
            % the pixel we're currently on at this stage in the code. z
            % is initially 0, then becomes c, then becomes c^2 + c etc. as
            % we iteratively evaluate f until x^2 + y^2 >= 4 or
            % iteration >= max_iterations
            x = 0;
            y = 0;
            iteration = 0;

            % Mandelbrot iteration
            while (iteration < max_iterations) && (x^2 + y^2 <= 4)
                x_next = x^2 - y^2 + x0;
                y_next = 2*x*y + y0;

                x = x_next;
                y = y_next;

                iteration = iteration + 1;
            end

            % Store iteration count
            mandel(iy, ix) = iteration;
        end
    end
end

%% ========================================================================
%  PART 3: Parallel Mandelbrot Set Computation
%  ========================================================================
%
%DONE: Implement parallel Mandelbrot set computation function
function [mandel] = mandelbrot_parallel(width, height, max_iterations)

    % Coordinate limits
    xmin = -2.0;
    xmax = 0.5;
    ymin = -1.2;
    ymax = 1.2;

    % Preallocate matrix
    mandel = zeros(height, width);

    % Parallel outer loop
    parfor ix = 1:width
        for iy = 1:height

            % Map pixel to complex plane
            x0 = xmin + (ix-1)*(xmax-xmin)/(width-1);
            y0 = ymin + (iy-1)*(ymax-ymin)/(height-1);

            % Initial conditions
            x = 0;
            y = 0;
            iteration = 0;

            % Mandelbrot iteration
            while (iteration < max_iterations) && (x^2 + y^2 <= 4)
                x_next = x^2 - y^2 + x0;
                y_next = 2*x*y + y0;

                x = x_next;
                y = y_next;

                iteration = iteration + 1;
            end

            mandel(iy, ix) = iteration;
        end
    end
end


%% ========================================================================
%  PART 4: Testing and Analysis
%  ========================================================================
% Compare the performance of serial Mandelbrot set computation
% with parallel Mandelbrot set computation.

function run_analysis()
    % Array conatining all the image sizes to be tested
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

    max_iterations  = 1000;
    
    names = ["SVGA","HD","FullHD","2K","QHD","4K UHD","5K","8K UHD"];
    results = struct();
    % The data structure of results is:
    % results(i).name
    % results(i).width
    % results(i).height
    
    % results(i).serial_time
    % results(i).serial_image
    
    % results(i).parallel(w).workers
    % results(i).parallel(w).time
    % results(i).parallel(w).image
    % results(i).parallel(w).speedup
    % where i is the dimension that corresponds to image size and w is the
    % dimension that coresponds to the number of workers for the parallel
    % results
    
    %TODO: For each image size, perform the following:
    %   a. Measure execution time of mandelbrot_serial
    %   b. Measure execution time of mandelbrot_parallel
    %   c. Store results (image size, time_serial, time_parallel, speedup)  
    %   d. Plot and save the Mandelbrot set images generated by both methods

    %% ===== Calculation of mandelbrot serial execution time on each image size and storage of matrix result =====
    for i = 1:length(names)
        width = image_sizes(i,1);
        height = image_sizes(i,2);
    
        tic
        mandel = mandelbrot_serial(width,height,max_iterations);
        serial_time = toc;
        fprintf("\nFinished measuring serial execution time for image size %s \n", names(i))
    
        results(i).name = names(i);
        results(i).width = width;
        results(i).height = height;
        results(i).serial_time = serial_time;
        results(i).serial_image = mandel;
    end
 
    %% ===== Calculation of mandelbrot parallel execution time on each image size and storage of matrix result =====
    workers = 2:6;         % using feature('numcores'), it was found that the number of cores for this machine was 6. 
    for w = 1:length(workers)
        delete(gcp('nocreate'))
        parpool(workers(w))
        for i = 1:length(names)
            width = image_sizes(i,1);
            height = image_sizes(i,2);
    
            tic
            mandel = mandelbrot_parallel(width,height,max_iterations);
            t = toc;
    
            results(i).parallel(w).workers = workers(w);
            results(i).parallel(w).time = t;
            results(i).parallel(w).image = mandel;
            fprintf("\nFinished measuring parallel execution time for image size %s with %d workers \n", names(i), results(i).parallel(w).workers)
        end
    end

    disp(results(1).parallel)

    %% ===== Speedup Calculation =====
    for i = 1:length(results)
        for w = 1:length(results(i).parallel)
            results(i).parallel(w).speedup = results(i).serial_time / results(i).parallel(w).time;
            fprintf("\nFinished measuring speedup on image size %s when comparing parallel with %d workers and serial \n", names(i), results(i).parallel(w).workers)
        end
    end

    %% ===== Save Mandelbrot Images ====    
    for i = 1:length(results)
        % Save serial image
        filename = sprintf("mandelbrot_%s_serial.png", results(i).name);
        mandelbrot_plot(results(i).serial_image, filename);
        fprintf("\nFinished saving mandelbrot image from serial computation for %s \n", names(i))
        % Save parallel images
        for w = 1:length(results(i).parallel)
            num_workers = results(i).parallel(w).workers;
            filename = sprintf("mandelbrot_%s_parallel_%dw.png", results(i).name, num_workers);
            mandelbrot_plot(results(i).parallel(w).image, filename);
            fprintf("\nFinished saving mandelbrot image from parallel computation with %d workers for image size %s \n", results(i).parallel(w).workers, names(i))
        end
    end

    %% ===== Runtime Comparison Plot =====
    fprintf("\nMaking runtime comparison plot \n")
    serial_times = zeros(length(results),1);
    for i = 1:length(results)
        serial_times(i) = results(i).serial_time;
    end
    
    figure
    plot(serial_times,'LineWidth',4)
    hold on
    
    fprintf("iterate until %d",length(workers))
    for w = 1:length(workers)
        fprintf("\nw = %d\n", w)
        parallel_times = zeros(length(results),1);
        disp(parallel_times)
        for i = 1:length(results)
            parallel_times(i) = results(i).parallel(w).time;
            fprintf("\nparallel_time for %d workers with image size %s is %d \n", results(i).parallel(w).workers, names(i), parallel_times(i))
        end
        fprintf("\nw = %d\n", w)
        plot(parallel_times,'LineWidth',4)
        fprintf("\nw = %d\n", w)
        hold on
        fprintf("\nw = %d\n", w)
    end
    
    legend(["Serial","2 workers","3 workers","4 workers","5 workers","6 workers"],"FontSize",10)
    xlabel("Resolution Index","FontSize",25)
    ylabel("Execution Time (s)","FontSize",25)
    title("Serial vs Parallel Mandelbrot Execution Time","FontSize",30)
    grid on
    
    saveas(gcf,"runtime_comparison.png")

    %% ===== Speedup vs Workers Plot =====
    fprintf("\nMaking speedup vs workers plot \n")
    target = length(results); % use largest resolution (8K)
    
    speedups = zeros(length(workers),1);
    
    for w = 1:length(workers)
        speedups(w) = results(target).parallel(w).speedup;
    end
    
    figure
    plot(workers, speedups,'-o','MarkerSize',4,'LineWidth',4)
    
    xlabel("Number of Workers","FontSize",25)
    ylabel("Speedup","FontSize",25)
    title(sprintf("Speedup vs Workers (%s Resolution)", results(target).name),"FontSize",30)
    
    grid on
    
    saveas(gcf,"speedup_vs_workers.png")

    %% ===== Speedup vs Resolution =====
    fprintf("\nMaking speedup vs resolution plot \n")
    figure
    hold on
    
    for w = 1:length(workers)
    
        s = zeros(length(results),1);
    
        for i = 1:length(results)
            s(i) = results(i).parallel(w).speedup;
        end
    
        plot(s,'LineWidth',4)
        hold on    
    end
    
    legend(["2 workers","3 workers","4 workers","5 workers","6 workers"],"FontSize",10)
    xlabel("Resolution Index","FontSize",25)
    ylabel("Speedup","FontSize",25)
    title("Speedup vs Resolution","FontSize",30)
    grid on
    
    saveas(gcf,"speedup_vs_resolution.png")
    save("mandelbrot_results.mat","results")

    fprintf("Finished everything!")
end

run_analysis()