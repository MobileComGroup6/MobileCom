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
    end
    
end

