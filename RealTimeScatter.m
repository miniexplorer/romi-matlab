classdef RealTimeScatter < handle
    properties
        FH % figure handle
        AH % axes handle
        LH % scatter object
    end
    
    methods
        function obj = RealTimeScatter()
            obj.createBlankPlot();
        end
        
        function createBlankPlot(obj)
            obj.FH = figure;
            obj.AH = axes;
            hold(obj.AH, 'all');
            obj.LH = scatter(0,0); % only used to produce a line handle
            set(obj.LH, 'XData', [], 'YData', []);
            axis equal
            axis([0 90 0 120]);
        end
        
        
        function updatePlot(obj, x2, y2)
            X = get(obj.LH, 'XData');
            Y = get(obj.LH, 'YData');
            
            X(end+1) = x2;
            Y(end+1) = y2;
            
            set(obj.LH, 'XData', X, 'YData', Y);
            drawnow
        end
    end
end

