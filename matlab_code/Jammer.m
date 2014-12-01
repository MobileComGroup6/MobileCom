classdef Jammer < SendingNode
	
	%Properties
	properties (Access = private)
		JammingMode
	end
	
	%Methods
	methods
		%class constructor
		function self = Jammer(medium, samplingRate)
			self.Medium = medium;
			self.SampleRate = samplingRate;
		end
		
		function send(self, data)
		end
		
		function jam(self, frequency, bandwidth, snr)
			
			lowerF = frequency-bandwidth/2;
			higherF = frequency+bandwidth/2;
			
			signalPower = self.Medium.getPower(lowerF, higherF);
			noisePower = signalPower / (10^(snr/10));
			
			height = noisePower / bandwidth;
			
			NFFT = self.Medium.getNFFT();			
			faxis = (0:NFFT-1)*(self.SampleRate/NFFT);
			
			lower = find(faxis >= lowerF);
			lower = lower(1);
			
			higher = find(faxis <= higherF);
			higher = higher(end);
			
			range = length(lower:higher);
			cnoise = self.generateComplexNoise(range, height);
			
			noiseFFT = zeros(1, NFFT);
			noiseFFT(lower:higher) = cnoise;
			
			self.Medium.writeF(noiseFFT');
		end
	end
	
	methods (Access=private)
		function cnoise = generateComplexNoise(self, length, absolute)
			phase = 2*pi*rand(1, length);
			cnoise = absolute * exp(1i.*phase);
		end
	end
	
end