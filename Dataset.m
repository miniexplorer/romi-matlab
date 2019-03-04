classdef Dataset < handle
    properties
        index = 1
        dataset
        array_length
        first_add_flag = 1
    end
    
    methods        
        function add(obj, data)
            if obj.first_add_flag == 1
                obj.first_add_flag = 0;
                obj.array_length = length(data);
                obj.dataset = zeros(1e6, obj.array_length);
            end
            
            obj.dataset(obj.index,:) = data(1:obj.array_length);
            obj.index = obj.index + 1;
        end
        
        function out = getDataset(obj)
            out = obj.dataset(1:obj.index-1, :);
        end
    end
end

