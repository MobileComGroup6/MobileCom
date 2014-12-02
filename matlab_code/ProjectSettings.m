classdef ProjectSettings
    
    methods (Static)
        function out = verbose(in)
            persistent verbose;
            if isempty(verbose)
                verbose = true;
            end
            if nargin
                verbose = in;
            end
            out = verbose;
            
        end
        
        function out = saveResultPlots(in)
            persistent saveResultPlots;
            if isempty(saveResultPlots)
                saveResultPlots = true;
            end
            if nargin
                saveResultPlots = in;
            end
            out = saveResultPlots;
            
        end
        
    end
    
end

