classdef PNGenerator < comm.PNSequence
    %PNGenerator extends comm.PNSequence by adding a property to access the
    %generated Pn sequence without having to generate a new one.
    
    properties (GetAccess = public, SetAccess = private)
        Pn
    end
    
    methods
        %class constructor
        function self = PNGenerator(length)
            self.SamplesPerFrame = length;
            self.InitialConditions = randi([0,1],1,size(self.Polynomial,2)-1);
        end
        
        function pn = generate(self)
            pn = self.step();
            self.Pn = pn;
        end
    end
    
end

