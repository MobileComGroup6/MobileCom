classdef Sender < SendingNode
	%Properties
	
	properties (Access = public)
		pnCode
		numOfSamples
		power = 1;
		gaussianSNR = 10;
	end
	properties (Access = private)
		
		
	end
	
	%Methods
	methods
		%class constructor
		function self = Sender(medium, pnCode, mode, samplesPerSecond, dataRate, chippingRate)
			self.Medium = medium;
			self.pnCode = pnCode;
			self.Mode = mode;
			self.SampleRate = samplesPerSecond;
			self.DataRate = dataRate;
			self.ChippingRate = chippingRate;
		end
		
		function setGaussianSNR(self, snr)
			self.gaussianSNR = snr;
		end
		
		function sendPower(self, data, power)
			self.power = power;
			send(self, data);
			self.power = 1;
		end
		
		function send(self, data)
			if ProjectSettings.verbose
				disp('Sending data:');
				disp(data);
			end
			self.numOfSamples = length(data)/self.DataRate * self.SampleRate;
			if strcmp(self.Mode, 'dsss')
				% spread data
				data_spreaded = self.DSSSSpread(data);
				% modulate data
				mData = pmmod(double(data_spreaded), self.CarrierFrequency, self.SampleRate, pi/2);
			elseif strcmp(self.Mode, 'fhss')
				% modulate data
				% calculate channel nr. using Pn sequence
				channels = self.getChannelNr();
				% does only sample right now
				mData = self.FHSSSpread(data);
				%compute some needed parameters
				chipLength = self.SampleRate/self.ChippingRate;
				chipNum = ceil(length(mData)/chipLength);
				
				%adjust chipping sequence length to data length
				factor = ceil(chipNum/length(channels));
				if factor > 1
					channels = repmat(channels,factor,1);
				end
				channels = channels(1:chipNum);
				
				%slice sampled data and modulate per chip
				toSend = [];
				for i = 0:chipNum-1
					part = mData(i*chipLength+1:(i+1)*chipLength);
					channel = channels(i+1);
                    frequency = self.CarrierFrequency + (channel * self.bandwidth);
					partModulated = pmmod(double(part),frequency, self.SampleRate, pi/2);
					toSend = [toSend;partModulated];
				end
				%send data
				mData = toSend;
			elseif strcmp(self.Mode, 'none')
				% modulate data
				dataSampled = self.sampleData(data, self.DataRate);
				mData = pmmod(double(dataSampled), self.CarrierFrequency, self.SampleRate, pi/2);
			else
				error(['invalid mode: ', self.Mode]);
			end
			
			% Add Noise
			mData = awgn(mData, self.gaussianSNR, 'measured');
			
			if ProjectSettings.verbose
				% Visualize data sent to medium
				figure;
				plot(mData(1:200)); title('Modulated Signal');
				ylim([-3,3]);
			end
			
			% write data to medium
			self.Medium.write(self.power.*mData);
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
			
			if ProjectSettings.verbose
				% Visualize Data and PN Sequence
				figure;
				subplot(3,1,1); stairs(dataSampled); title('Data')
				ylim([-1,2]);
				subplot(3,1,2); stairs(pnSampled); title('PN Sequence');
				ylim([-1,2]);
				subplot(3,1,3); stairs(data_spreaded); title('Spread Data');
				ylim([-1,2]);
			end
			
		end
		
		function data_spreaded = FHSSSpread(self, mData)
			% TODO: implement spreading for FHSS
			data_spreaded = self.sampleData(mData, self.DataRate);
			
			if ProjectSettings.verbose
				figure; stairs(data_spreaded); title('Data');
				ylim([-1,2]);
			end
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