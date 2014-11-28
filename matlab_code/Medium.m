classdef Medium < handle %handle is superclass and provides event machanisms
	%Properties
	%private class properties.
	properties (Access = private)
		Data
		Length
		NFFT = 100000; % inserts (NFFT - length(Data)) padding to FFT
	end
	
	%Methods
	methods
		%class constructor
		function self = Medium()
			self.Data = zeros(self.NFFT,1);
		end
		
		function nfft = getNFFT(self)
			nfft = self.NFFT;
		end
		
		function power = getPower(self, fromF, toF)
			faxis = (0:self.NFFT-1)*(10000/self.NFFT);
			
			lower = find(faxis >= fromF);
			lower = lower(1);
			
			higher = find(faxis <= toF);
			higher = higher(end);
			
			power = sum(self.Data(lower:higher) .* conj(self.Data(lower:higher))) / ...
				(higher-lower);
		end
		
		function writeF(self, fdata)
			self.Data = self.Data + fdata;
			self.visualizeSpectrum();
		end
		
		function write(self, data)
			% Store original data length, so we can restore signal later,
			% necessary because of addition of padding
			self.Length = length(data);
			
			%disp('Power in time Domain:')
			%disp(sum(data.^2));
			
			% Add data on the medium
			self.Data = self.Data + fft(data, self.NFFT);
						
			self.visualizeSpectrum();
		end
		
		function visualizeSpectrum(self)
			if ProjectSettings.verbose
				% Visualize data on Medium (passband, not baseband)
				figure;
				% 1000 is sampling frequency, should be some kind of variable
				% here
				faxis = 10000/2*linspace(0,1,self.NFFT/2+1);
				fft_vis = abs(self.Data)/self.NFFT;
				fft_vis = fft_vis(1:self.NFFT/2+1);
				plot(faxis(1:4000), fft_vis(1:4000)); title('Data on Medium');
				xlabel('Frequency (Hz)');
			end
		end
		
		function dLength = getDataLength(self)
			dLength = self.Length;
		end
		
		function data = read(self)
			% read data
			data = ifft(self.Data, self.NFFT);
			data = data(1:self.Length);
		end
		
		function clear(self)
			% clear medium
			self.Data = zeros(self.NFFT,1);
		end
	end
	
end
