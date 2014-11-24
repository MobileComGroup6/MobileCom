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
		
		function write(self, data)
			% Handle case if existing and new data have different lenghts
			%{
			if (length(data) > self.Length)
				self.Data = padarray(self.Data, [length(data)-self.Length, 0], 'symmetric');
			else
				data = padarray(data, [self.Length-length(data), 0], 'symmetric');
			end
			%}
			
			% Store original data length, so we can restore signal later,
			% necessary because of addition of padding
			self.Length = length(data);
			%self.NFFT = 2^nextpow2(self.Length);
			
			% Add data on the medium
			self.Data = self.Data + fft(data, self.NFFT);
			
			% Visualize data on Medium (passband, not baseband)
			figure;
			% 1000 is sampling frequency, should be some kind of variable
			% here
			faxis = 10000/2*linspace(0,1,self.NFFT/2+1);
			fft_vis = fftshift(abs(self.Data));
			plot(faxis, fft_vis(self.NFFT/2:end)); title('Data on Medium');
			xlabel('Frequency (Hz)');
			
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
