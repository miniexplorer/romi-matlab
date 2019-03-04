function send_to_robot( input_args )
global ME

fprintf(ME.serial_port, input_args);

end

