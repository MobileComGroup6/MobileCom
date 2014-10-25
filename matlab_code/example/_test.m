%%test property getter and setter
sender = Sender([0 1 0 1]);
content = sender.MessageContent;
content = strcat(content, ' AND THIS!');
sender.MessageContent = content;
%another way to access properties
sender.('MessageContent')

%remove the object, since Matlab showed some strange behavior. It did not
%create a new instance after modifying the class' source. Not sure if this
%is needed though.
clear sender;
%% test static methods
Sender.printClassName();

