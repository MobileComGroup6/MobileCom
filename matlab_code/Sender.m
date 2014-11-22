classdef Sender < SendingNode
%Properties
    properties (Access = private)
       pnCode
       BPSKModulator
       numOfSamples
    end
    
    properties
        Mode
        ChippingRate
        SampleRate
        DataRate
        CarrierFrequency = 100;
    end

%Methods
    methods
        %class constructor
        function self = Sender(medium, pnCode, mode, samplesPerSecond, dataRate, chippingRate)
            self.Medium = medium;
            self.BPSKModulator = comm.BPSKModulator;
            self.pnCode = pnCode;
            self.Mode = mode;
            self.SampleRate = samplesPerSecond;
            self.DataRate = dataRate;
            self.ChippingRate = chippingRate;
        end        
        
        function send(self, data)
            disp('Sending data:');
            disp(data);
            self.numOfSamples = length(data)/self.DataRate * self.SampleRate;
            if strcmp(self.Mode, 'dsss')
            	% spread data
                data_spreaded = self.DSSSSpread(data);
                % modulate data
                mData = pmmod(double(data_spreaded), self.CarrierFrequency, self.SampleRate, pi/2);
                
								% visualize part of modulated signal
								figure;
								plot(mData(1:200)); title('Modulated Signal');
								ylim([-3,3]);
            elseif strcmp(self.Mode, 'fhss')
                % modulate data
                mData = self.BPSKModulator.step(data);
                % calculate channel nr. using Pn sequence
                channelNr = self.getChannelNr();
                disp(['sending on channel ', num2str(channelNr)]);
            	% spread data / do hopping
                mData = self.FHSSSpread(mData, channelNr);
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
            pn = self.pnCode;
            dataSampled = self.sampleData(data, self.DataRate);
            pnSampled = self.sampleData(pn, self.ChippingRate);
            factor = ceil(length(dataSampled)/length(pnSampled));
            if factor > 1
                pnSampled = repmat(pnSampled,factor,1);
            end
            pnSampled = pnSampled(1:length(dataSampled));
            data_spreaded = xor(dataSampled, pnSampled);
						
						% Visualize Data and PN Sequence
						figure;
						subplot(3,1,1); stairs(dataSampled); title('Data')
						ylim([-1,2]);
						subplot(3,1,2); stairs(pnSampled); title('PN Sequence');
						ylim([-1,2]);
						subplot(3,1,3); stairs(data_spreaded); title('Spread Data');
						ylim([-1,2]);
						
				end
        
        function data_spreaded = FHSSSpread(self, mData, channelNr)
            % TODO: implement spreading for FHSS
            data_spreaded = mData;
        end
        
        function channelNr = getChannelNr(self)
            % Generate a new Pn sequence
            l = log2(self.NumOfChannels);
            pn = self.pnGenerator.generate(l);
            % Calculating frequency word
            channelNr = bin2dec(num2str(pn(1:l)'));
        end
    end
    
end