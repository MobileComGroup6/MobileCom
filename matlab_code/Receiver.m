classdef Receiver < Node
	%Properties
	%private class properties.
	properties (Access = private)
		pnCode
		numOfSamples
		BPSKDemodulator
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
		function self = Receiver(medium, pnCode, mode, samplesPerSecond, dataRate, chippingRate)
			self.Medium = medium;
			self.BPSKDemodulator = comm.BPSKDemodulator;
			self.pnCode = pnCode;
			self.Mode = mode;
			self.SampleRate = samplesPerSecond;
			self.DataRate = dataRate;
			self.ChippingRate = chippingRate;
		end
		
		function data_despreaded = receive(self)
			% read data on medium
			mData = self.Medium.read();
			if strcmp(self.Mode, 'dsss')
				% demodulate data
				%data = self.BPSKDemodulator.step(mData);
				data = pmdemod(mData,self.CarrierFrequency, self.SampleRate, pi/2);
				% despread data
				data_despreaded = self.DSSSDespread(data);
			elseif strcmp(self.Mode, 'fhss')
				% calculate channel nr. using Pn sequence
				channelNr = self.getChannelNr();
				disp(['reading on channel ', num2str(channelNr)]);
				% despread data
				data = self.FHSSDespread(mData, channelNr);
				% demodulate data
				data_despreaded = self.BPSKDemodulator.step(data);
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
		function data_despread = DSSSDespread(self, data)
			% Get the current Pn sequence
			pn = self.pnCode;
			sampledData = data;
			sampledData(sampledData<0.5) = 0;
			sampledData(sampledData>=0.5) = 1;
			
			pnSampled = self.sampleData(pn, self.ChippingRate);
			factor = ceil(length(sampledData)/length(pnSampled));
			if factor > 1
				pnSampled = repmat(pnSampled,factor,1);
			end
			pnSampled = pnSampled(1:length(sampledData));
			
			data_despread = xor(sampledData, pnSampled);
			
			symbolLength = self.SampleRate/self.DataRate;
			numOfSymbols = length(data_despread)/symbolLength;
			
			mat = reshape(data_despread,symbolLength,numOfSymbols,1);
			
			data_despread = im2bw(mean(mat,1),0.5)';
		end
		
		function data_despreaded = FHSSDespread(self, mData, channelNr)
			% TODO: implement despreading for FHSS
			data_despreaded = mData;
		end
		
		function channelNr = getChannelNr(self)
			% Get the current Pn sequence
			l = log2(self.NumOfChannels);
			pn = self.pnGenerator.getPn(l);
			% Calculating frequency word
			channelNr = bin2dec(num2str(pn(1:l)'));
		end
	end
end