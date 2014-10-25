classdef Sender < SendingNode
%Properties
    properties
       P_n;
    end

%Methods
    methods
        %class constructor
        function self = Sender(medium, p_n)
            self.Medium = medium;
            self.Modulator = comm.BPSKModulator;
            self.P_n = p_n;
        end        
        
        function send(self, data)
            disp('Sending data:');
            disp(data);
            % spread data
            data_spreaded = self.spread(data);
            % modulate data
            mData = self.Modulator.step(data_spreaded);
            % write data to medium
            self.Medium.write(mData);
        end
    end
    
    methods (Access=private)
        function data_spreaded = spread(~, data)
            % TODO: implement spreading
            data_spreaded = data;
        end
    end
    
end