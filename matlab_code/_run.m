clear all

medium = Medium;
pnGenerator = comm.PNSequence;
% Set chip length to 100
pnGenerator.SamplesPerFrame = 100;
p_n = pnGenerator.step();

sender = Sender(medium, p_n);
receiver = Receiver(medium, p_n);
jammer = Jammer(medium);

sender.send([1;0;0;1;0]);
receiver.receive();