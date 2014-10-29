classdef Jammer < SendingNode
%Properties
    properties (Access = private)
        Modulator
    end    
    
%Methods
    methods
        %class constructor
        function self = Jammer(medium)
            self.Medium = medium;
            self.Modulator = comm.BPSKModulator;
        end        
        
        function send(self, data)
            % modulate data
            mData = self.Modulator.step(data);
            % write data to medium
            self.Medium.write(mData);
        end
    end
    
end