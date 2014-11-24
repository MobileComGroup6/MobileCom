classdef Jammer < SendingNode
	%Properties
	properties (Access = private)
		
	end
	
	%Methods
	methods
		%class constructor
		function self = Jammer(medium)
			self.Medium = medium;
		end
		
		function send(self, data)
			% TODO: modulate data
			
			% write data to medium
			self.Medium.write(mData);
		end
	end
	
end