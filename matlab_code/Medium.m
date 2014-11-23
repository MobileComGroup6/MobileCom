classdef Medium < handle %handle is superclass and provides event machanisms
	%Properties
	%private class properties.
	properties (Access = private)
		Data
		Length
		NFFT = 10000; % inserts (NFFT - length(Data)) padding to FFT
	end
	
	%Methods
	methods
		function write(self, data)
			% Store original data length, so we can restore signal later,
			% necessary because of addition of padding
			self.Length = length(data);
			
			% TODO: add data instead of replacing it
			% transform data and write it to the medium
			self.Data = fft(data, self.NFFT);
			
			% Visualize data on Medium (passband, not baseband)
			figure;
			% 1000 is sampling frequency, should be some kind of variable
			% here
			faxis = 1000/2*linspace(0,1,self.NFFT/2+1);
			fft_vis = fftshift(abs(self.Data));
			plot(faxis, fft_vis(self.NFFT/2:end)); title('Data on Medium');
			xlabel('Frequency (Hz)');
			
		end
		
		function data = read(self)
			% read data
			data = ifft(self.Data, self.NFFT);
			data = data(1:self.Length);
		end
		
		function clear(self)
			% clear medium
			self.Data = [];
		end
	end
	
end
