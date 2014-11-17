classdef Medium < handle %handle is superclass and provides event machanisms
%Properties
    %private class properties.
    properties (Access = private)
        Data
    end
    
%Methods  
    methods        
        function write(self, data)
            % TODO: add data instead of replacing it
            % transform data and write it to the medium
            self.Data = fft(data);
        end
        
        function data = read(self)
            % read data
            data = ifft(self.Data);
        end
        
        function clear(self)
            % clear medium
            self.Data = [];
        end
    end
    
end