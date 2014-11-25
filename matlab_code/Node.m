classdef Node < handle %handle is superclass and provides event machanisms
	%Properties
	properties
		Medium
		NumOfChannels = 8
		ChippingRate
		SampleRate
		DataRate
		CarrierFrequency = 100;
		bandwidth = 30;
		Mode
	end
	
	methods (Access=protected)
		function sampledData = sampleData(self, data, rate)
			%sample the sequence
			partLength = self.SampleRate / rate;
			sampledData = repmat(data', [partLength, 1, 1]);
			sampledData = sampledData(:);
		end
	end
end