classdef Jammer < Sender
	
	%Properties
	properties (Access = private)
		JammingMode
        realMedium
	end
	
	%Methods
	methods
		%class constructor
		function self = Jammer(medium, samplingRate)			
            pnGenerator = PNGenerator(128);
            pnCode = pnGenerator.step();
            med = Medium();
            self = self@Sender(med, pnCode, 'dsss', samplingRate, 4, 16);
            self.realMedium = medium;
		end
		
		
		function jam(self, frequency, bandwidth, power)
			pnGenerator = PNGenerator(128);
            self.pnCode = pnGenerator.step();
            data = pnGenerator.step();
            self.CarrierFrequency = frequency;
            self.ChippingRate = round(bandwidth/2);
            
            lowerF = frequency-bandwidth/2;
			higherF = frequency+bandwidth/2;
            
            NFFT = self.Medium.getNFFT();			
			faxis = (0:NFFT-1)*(self.SampleRate/NFFT);
			
			lower = find(faxis >= lowerF);
			lower = lower(1);
			
			higher = find(faxis <= higherF);
			higher = higher(end);
            
            self.sendPower(data,power);
            spectrum = self.Medium.getData();
            spectrum(1:lower) = 0;
            spectrum(higher:end) = 0;
            self.realMedium.writeF(spectrum);
            
            
		end
	end
	
	methods (Access=private)
		function cnoise = generateComplexNoise(self, length, absolute)
			phase = 2*pi*rand(1, length);
			cnoise = absolute * exp(1i.*phase);
		end
	end
	
end