clear all

medium = Medium;
p_n = [1;0;1]; % TODO: use P_n generator from comm package

sender = Sender(medium, p_n);
receiver = Receiver(medium, p_n);
jammer = Jammer(medium);

sender.send([1;0;0;1;0]);
receiver.receive();