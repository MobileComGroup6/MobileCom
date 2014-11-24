classdef Jammer < SendingNode
	%Properties
	properties (Access = private)
		JammingMode
	end
	
	%Methods
	methods
		%class constructor
		function self = Jammer(medium, samplingRate, mode)
			self.Medium = medium;
			self.SampleRate = samplingRate;
			self.JammingMode = mode;
		end
		
		function send(self, data)
		end
		
		function jam(self, frequency, power)
			length = self.Medium.getDataLength();
			if (isempty(length))
				length = 1000;
			end
			
			if (strcmp(self.JammingMode, 'narrowband'))
				noise = narrowbandNoise(self,length, power);
			elseif (strcmp(self.JammingMode, 'wideband'))
				noise = widebandNoise(self,length, power);
			end
			
			Fs = self.SampleRate;
			Fc = frequency;
			
			% Modulate noise to jamming frequency
			modulated = pmmod(noise, Fc, Fs, pi/2);
			
			% write data to medium
			self.Medium.write(modulated);
		end
	end
	
	methods (Access=private)
		
		function noise = generateNoise(self, length, power, sigma)			
			% Generate Gaussian Noise
			signal = wgn(1, length, power);
			
			% Generate 1D Gaussian Filter with desired sigma
			w = 2*ceil(1.5*sigma)+1; % Filter Window
			filter = 1/(sqrt(2*pi)*sigma)*exp(-(-w:w).^2/(2*sigma^2));
			
			noise = conv(signal, filter, 'same');
		end
		
		function wbNoise = widebandNoise(self, length, power)
			wbNoise = generateNoise(self,length, power, 1.0);
		end
		
		function nbNoise = narrowbandNoise(self, length, power)
			nbNoise = generateNoise(self,length, power, 20.0);
		end
	end
	
end