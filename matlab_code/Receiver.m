classdef Receiver < Node
%Properties
    %private class properties.
    properties (Access = private)
        pnGenerator
        BPSKDemodulator
        FSKDemodulator
    end
    
    properties
        Mode
    end

%Methods
    methods
        %class constructor
        function self = Receiver(medium, pnGenerator, mode)
            self.Medium = medium;
            self.BPSKDemodulator = comm.BPSKDemodulator;
            self.FSKDemodulator = comm.FSKDemodulator;
            self.pnGenerator = pnGenerator;
            self.Mode = mode;
        end        
        
        function receive(self)
            % read data on medium
            mData = self.Medium.read();
            if strcmp(self.Mode, 'dsss')
                % demodulate data
                data = self.BPSKDemodulator.step(mData);
                % despread data
                data_despreaded = self.DSSSDespread(data);
            elseif strcmp(self.Mode, 'fhss')
                % calculate channel nr. using Pn sequence
                channelNr = self.getChannelNr();
                disp(['reading on channel ', num2str(channelNr)]);
                % despread data
                data = self.FHSSDespread(mData, channelNr);
                % demodulate data
                data_despreaded = self.FSKDemodulator.step(data);
            elseif strcmp(self.Mode, 'none')
                % demodulate data
                data_despreaded = self.BPSKDemodulator.step(mData);
            else
                error(['invalid mode: ', self.Mode]);
            end

            disp('Received data:');
            disp(data_despreaded);
        end
    end
    
    methods (Access=private)
        function data_despreaded = DSSSDespread(self, data)
            % Get the current Pn sequence
            pn = self.pnGenerator.Pn;
            if size(pn,1) < size(data,1)
                error('Pn is shorter than the data.');
            end
            pn = pn(1:size(data));
            % Replace 0 by -1 to make the spreading work
            data(data==0) = -1;
            pn(pn==0) = -1;
            % Multiply the data with the Pn sequence
            data_despreaded = data .* pn;
            % Change back -1 to 0
            data_despreaded(data_despreaded==-1) = 0;
        end
        
        function data_despreaded = FHSSDespread(self, mData, channelNr)
            % TODO: implement despreading for FHSS
            data_despreaded = mData;
        end
        
        function channelNr = getChannelNr(self)
            % Get the current Pn sequence
            pn = self.pnGenerator.Pn;
            numOfChannels = self.FSKDemodulator.ModulationOrder;
            l = log2(numOfChannels);
            if size(pn,1) < l
                error('Pn is too short to encode all channels.');
            end
            % Calculating frequency word
            channelNr = bin2dec(num2str(pn(1:l)'));
        end
    end
    
end