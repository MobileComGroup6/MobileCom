classdef Receiver < Node
%Properties
    %private class properties.
    properties (Access = private)
        P_n
        Demodulator
    end

%Methods
    methods
        %class constructor
        function self = Receiver(medium, p_n)
            self.Medium = medium;
            self.P_n = p_n;
            self.Demodulator = comm.BPSKDemodulator;
        end        
        
        function receive(self)
            % read data on medium
            mData = self.Medium.read();
            % demodulate data
            data = self.Demodulator.step(mData);
            % despread data
            data_despreaded = self.despread(data);
            disp('Received data:');
            disp(data_despreaded);
        end
    end
    
    methods (Access=private)
        function data_despreaded = despread(~, data)
            % TODO: implement despreading
            data_despreaded = data;
        end
    end
    
end