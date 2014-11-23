classdef Receiver < Node
	%Properties
	%private class properties.
	properties (Access = private)
		pnCode
		numOfSamples
		BPSKDemodulator
		bandwidth
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
			self.bandwidth = 10;
		end
		
		function data_despread = receive(self)
			% read data on medium
			mData = self.Medium.read();
			if strcmp(self.Mode, 'dsss')
				% demodulate data
				%data = self.BPSKDemodulator.step(mData);
				data = pmdemod(mData,self.CarrierFrequency, self.SampleRate, pi/2);
				
				figure; plot(data); title('Demodulated Signal')
				
				% despread data
				data_despread = self.DSSSDespread(data);
			elseif strcmp(self.Mode, 'fhss')
				% calculate channel nr. using Pn sequence
				channels = self.getChannelNr();
				%disp(['reading on channel ', num2str(channelNr)]);
				% despread data
				%data = self.FHSSDespread(mData, channelNr);
				
				% demodulate data
				symbolLength = self.SampleRate/self.DataRate;
				numOfSymbols = length(mData)/symbolLength;
				
				chipLength = self.SampleRate/self.ChippingRate;
				
				chipNum = ceil(length(mData)/chipLength);
				
				factor = ceil(chipNum/length(channels));
				
				if factor > 1
					channels = repmat(channels,factor,1);
				end
				channels = channels(1:chipNum);
				
				demodulated = [];
				for i = 0:chipNum-1
					part = mData(i*chipLength+1:(i+1)*chipLength);
					channel = channels(i+1);
					partDemodulated = pmdemod(part,self.CarrierFrequency + channel * self.bandwidth, self.SampleRate, pi/2);
					demodulated = [demodulated;partDemodulated];
				end
				
				figure; plot(demodulated); title('Demodulated Signal')
				
				recoveredData = [];
				for i = 0:numOfSymbols-1
					part = demodulated(i*symbolLength+1:(i+1)*symbolLength);
					value = mean(part);
					recoveredData = [recoveredData;value];
				end
				data_despread = recoveredData;
				data_despread = im2bw(data_despread,0.5);
			elseif strcmp(self.Mode, 'none')
				% demodulate data
				data_despread = self.BPSKDemodulator.step(mData);
			else
				error(['invalid mode: ', self.Mode]);
			end
			
			disp('Received data:');
			disp(data_despread);
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
			% Generate a new Pn sequence
			l = log2(self.NumOfChannels);
			% Calculating frequency word
			channelNr = [];
			pn = self.pnCode;
			numOfWords = floor(length(pn)/l);
			for i = 0:numOfWords-1
				channelNr = [channelNr;bin2dec(num2str(pn(i*l+1:(i+1)*l)'))];
			end
		end
	end
end