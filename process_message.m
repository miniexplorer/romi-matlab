function process_message(obj,event)
%PROCESS_MESSAGE Processes incoming data on serial port.
%   Reads serial port, search for start of frame (0x0685) and processes
%   messages according to the identifier (third byte of the message).

while obj.BytesAvailable
    readval = fread(obj,1);
    
    if readval == 6 % Look for start of frame 0x0685 (6=0x06, 133=0x85).
        readval(2) = fread(obj,1);
        
        if strcmp(lastwarn, '')
            
            if readval(2) == 133
                readval(3) = fread(obj,1);
                
                if strcmp(lastwarn, '')
                    switch readval(3)                            
                        case 'O'
                            msg_length = 28;
                            [readvalues,count,msg] = fread(obj,msg_length);
                            if count == msg_length
                                parse_odometry(readvalues);
                            end
                            
                        case 'F'
                            matrix_dimensions = fread(obj,2);
                            if strcmp(lastwarn, '')
                                if matrix_dimensions(1) > 0 && matrix_dimensions(2) > 0
                                    msg_length = matrix_dimensions(1) * matrix_dimensions(2) * 4;
                                    [readvalues,count,msg] = fread(obj,msg_length);
                                    if count == msg_length
                                        parse_float_matrix(matrix_dimensions', readvalues');
                                    end
                                end
                            end
                            
                        otherwise
                            append_text(readval);
                    end
                else
                    disp('Message incomplete!');
                end
            else
                append_text(readval);
            end
        else
            disp('Message incomplete!');
        end
    else
        append_text(readval);
    end
end

print_on_console();
end

function print_on_console()
global ME
if ~isempty(ME.serial_text)
    disp( char(ME.serial_text) );
    ME.serial_text = [];
end
end

function append_text(text)
global ME
ME.serial_text = [ME.serial_text text];
end

function out = parse_float_matrix(dim, vals)
array = [];

for k=1:4:length(vals)
    array = [array double(typecast(uint8(vals(k:k+3)), 'single'))];
end

out = reshape(array, fliplr(dim)).'

global ME
ME.temporario = out;
end