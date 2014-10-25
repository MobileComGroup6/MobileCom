classdef SendingNode < Node
%Properties
    %protected class properties.
    properties(Access = protected)
        Modulator
    end
    
%Methods
    %abstract methods
    methods (Abstract)
        send(data)
    end
    
end