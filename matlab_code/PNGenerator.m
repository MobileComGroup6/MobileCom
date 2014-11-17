classdef PNGenerator < comm.PNSequence
    %PNGenerator extends comm.PNSequence by adding a property to access the
    %generated Pn sequence without having to generate a new one.
    
    properties (Access = private)
        Pn
    end
    
    methods
        %class constructor
        function self = PNGenerator(length)
            self.SamplesPerFrame = length;
            self.InitialConditions = randi([0,1],1,size(self.Polynomial,2)-1);
        end
        
        function pn = generate(self,l)
            pn = self.step();
            if l > length(pn)
                % if the length we need is longer than the sequence length,
                % repeat itself
                factor = ceil(l/length(pn));
                pn = repmat(pn,factor,1);
            end
            pn = pn(1:l);
            self.Pn = pn;
        end
        
        function pn = getPn(self,l)
            if length(self.Pn) ~= l
                self.generate(l);
            end
            pn = self.Pn;
        end
    end
    
end

