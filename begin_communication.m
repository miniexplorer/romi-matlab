function begin_communication( COM_port )
%BEGIN_COMMUNICATION Starts communication with the robot on serial port
%COM_port
%   Opens the serial port and initializes a global variable to store the
%   data read from the robot.

global ME

ME.serial_text = [];

% Class objects instantiation
ME.rangefinder_dataset = Dataset;   % Rangefinder dataset
ME.odometry_dataset = Dataset;      % Odometry dataset
ME.scatter = RealTimeScatter;       % Odometry plot chart

% Initialization of real-time plot of encoder ticks.
figure
ME.plot_encLeftInc = animatedline('MaximumNumPoints',60,'Color','b');
ME.plot_encRightInc = animatedline('MaximumNumPoints',60,'Color','r');
ME.index = 1;

ME.serial_port = serial(COM_port,   ...
    'BaudRate',                 115200,     ...
    'InputBufferSize',          4000,       ...
    'Timeout',                  1,         ...
    'TimerPeriod',              0.2,         ...
    'TimerFcn',                 @process_message );

fopen(ME.serial_port);

disp('Communication started.');

end

