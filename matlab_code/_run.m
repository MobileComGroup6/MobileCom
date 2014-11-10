clear all

medium = Medium;
pnGenerator = PNGenerator(100);

sender = Sender(medium, pnGenerator, 'dsss');
receiver = Receiver(medium, pnGenerator, 'dsss');
jammer = Jammer(medium);

for k = 1:3
    disp(['DSSS - Test ', num2str(k), ':']);
    sender.send(randi([0,1],5,1));
    receiver.receive();
end

sender = Sender(medium, pnGenerator, 'fhss');
receiver = Receiver(medium, pnGenerator, 'fhss');

for k = 1:3
    disp(['FHSS - Test ', num2str(k), ':']);
    sender.send(randi([0,1],5,1));
    receiver.receive();
end