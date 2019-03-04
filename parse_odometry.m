function parse_odometry( message )
%PARSE_ODOMETRY Parses odometry message and store data on
%ME.odometry matrix.
%   Converts binary variables to MATLAB doubles an stores them.

global ME

b1 = 1; encLeftAbs = double(typecast(uint8(message(b1:b1+3)), 'int32'));
b1 = b1 + 4; encRightAbs = double(typecast(uint8(message(b1:b1+3)), 'int32'));
b1 = b1 + 4; encLeftInc = double(typecast(uint8(message(b1:b1+3)), 'int32'));
b1 = b1 + 4; encRightInc = double(typecast(uint8(message(b1:b1+3)), 'int32'));
b1 = b1 + 4; X = double(typecast(uint8(message(b1:b1+3)), 'single'));
b1 = b1 + 4; Y = double(typecast(uint8(message(b1:b1+3)), 'single'));
b1 = b1 + 4; teta = double(typecast(uint8(message(b1:b1+3)), 'single'));

values = [ encLeftAbs, encRightAbs, encLeftInc, encRightInc, X, Y, teta ];

ME.scatter.updatePlot(X, Y);
ME.odometry_dataset.add(values);
disp('Odometry:'); disp(values);

% Plot odometry
addpoints(ME.plot_encLeftInc, ME.index, encLeftInc);
addpoints(ME.plot_encRightInc, ME.index, encRightInc);
ME.index = ME.index + 1;
drawnow

end

