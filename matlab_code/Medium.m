classdef Medium < handle %handle is superclass and provides event machanisms
%Properties
    %private class properties.
    properties(SetAccess = private, GetAccess = private)
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
            % read data and clear medium
            data = ifft(self.Data);
            self.Data = [];
        end
    end
    
end