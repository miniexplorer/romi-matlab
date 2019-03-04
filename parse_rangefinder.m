function parse_rangefinder( message )
%PARSE_ODOMETRY Parses odometry message and store data on
%ME.odometry matrix.
%   Converts binary variables to MATLAB doubles an stores them.

global ME

measurements = zeros(1,16);

for k=1:16
    measurements(k) = double(typecast(uint8(message(k*2-1:k*2)), 'uint16'));

    % Discards measurements above 1270 mm.
    if measurements(k) >= 1270
        measurements(k) = 1;
    end
end

ME.compass.updatePlot(measurements);
ME.rangefinder_dataset.add(measurements);
% disp('Rangefinder:');disp(measurements);

end
