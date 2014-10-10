%sample class to test object oriented programming in matlab
%documentatin: http://www.mathworks.ch/ch/help/matlab/object-oriented-programming.html

%Classnames are Upper Case and CamelCase
classdef Sender < handle %handle is superclass and provides event machanisms
%Properties    
    %define class properties
    %Property names are Upper Case and CamelCase
    properties
       MessageContent = 'test content'; %init default value. Will be overwriten by constructor.
    end
    
    %static properties
    properties(Constant = true)
        ClassName = 'Sender';
    end    
    %private class properties. Other property attributes see http://www.mathworks.ch/ch/help/matlab/matlab_oop/property-attributes.html#brjjwcj-1
    properties(SetAccess = private, GetAccess = private)
        RandPattern
    end
    
%Methods
    %define class methods
    methods
        
        %class constructor
        function obj = Sender(pattern)
            obj.RandPattern = pattern;
        end
        
        %these getters and setters are automaticaly called when assigning
            %or querying the property.
        %getter
        function content = get.MessageContent(object)
            content = object.MessageContent;
            'debug: MessageContent has been queried'
        end
        %setter
        function obj = set.MessageContent(obj, content)
           obj.MessageContent = content; 
           strcat('debug: MessageContent has been set to: ', content)
        end
        
        function send(obj)
            strcat('Sending message: ', MessageContent)
            notify(obj, 'MessageSent');
        end
    end
    
    methods(Static = true)
        function  printClassName()
           strcat('Class name is: ', Sender.ClassName)
        end
    end 
    
%Events
    events
        MessageSent
    end
    
end