clear all

medium = Medium;
pnGenerator = PNGenerator(100);

sender = Sender(medium, pnGenerator, 'dsss');
receiver = Receiver(medium, pnGenerator, 'dsss');
jammer = Jammer(medium);

for k = 1:3
    disp(['Test ', num2str(k), ':']);
    sender.send(randi([0,1],5,1));
    receiver.receive();
end