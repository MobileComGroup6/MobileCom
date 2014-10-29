classdef Sender < SendingNode
%Properties
    properties (Access = private)
       pnGenerator
       BPSKModulator
       FSKModulator
    end
    
    properties
        Mode
    end

%Methods
    methods
        %class constructor
        function self = Sender(medium, pnGenerator, mode)
            self.Medium = medium;
            self.BPSKModulator = comm.BPSKModulator;
            self.FSKModulator = comm.FSKModulator;
            self.pnGenerator = pnGenerator;
            self.Mode = mode;
        end        
        
        function send(self, data)
            disp('Sending data:');
            disp(data);
            if strcmp(self.Mode, 'dsss')
            	% spread data
                data_spreaded = self.DSSSSpread(data);
                % modulate data
                mData = self.BPSKModulator.step(data_spreaded);
            elseif strcmp(self.Mode, 'fhss')
                % modulate data using FSK modulator
                FSKmData = self.FSKModulator.step(data);
                % calculate channel nr. using Pn sequence
                channelNr = self.getChannelNr();
                disp(['sending on channel ', num2str(channelNr)]);
            	% spread data
                mData = self.FHSSSpread(FSKmData, channelNr);
            elseif strcmp(self.Mode, 'none')
                % modulate data
                mData = self.BPSKModulator.step(data);
            else
                error(['invalid mode: ', self.Mode]);
            end
            % write data to medium
            self.Medium.write(mData);
        end
    end
    
    methods (Access=private)
        function data_spreaded = DSSSSpread(self, data)
            % Generate a new Pn sequence
            pn = self.pnGenerator.generate();
            if size(pn,1) < size(data,1)
                error('Pn is shorter than the data.');
            end
            pn = pn(1:size(data));
            % Replace 0 by -1 to make the spreading work
            data(data==0) = -1;
            pn(pn==0) = -1;
            % Multiply the data with the Pn sequence
            data_spreaded = data .* pn;
            % Change back -1 to 0
            data_spreaded(data_spreaded==-1) = 0;
        end
        
        function data_spreaded = FHSSSpread(self, FSKmData, channelNr)
            % TODO: implement spreading for FHSS
            data_spreaded = FSKmData;
        end
        
        function channelNr = getChannelNr(self)
            % Generate a new Pn sequence
            pn = self.pnGenerator.generate();
            numOfChannels = self.FSKModulator.ModulationOrder;
            l = log2(numOfChannels);
            if size(pn,1) < l
                error('Pn is too short to encode all channels.');
            end
            % Calculating frequency word
            channelNr = bin2dec(num2str(pn(1:l)'));
        end
    end
    
end