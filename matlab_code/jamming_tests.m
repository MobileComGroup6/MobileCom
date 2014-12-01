%%
%clear all;
close all;
clc;

Fs = 4096;

medium = Medium;

dataRate = 4;
chippingRate = 64;

pnGenerator = PNGenerator(3*12);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'dsss', Fs, dataRate,chippingRate);

jammer = Jammer(medium, Fs);

test_data = randi([0,1],100,1);

sender.send(test_data);

jammer.jam(100, 20, 2); %frequency, bandwidth, power in multiples of standard output


receiver = Receiver(medium, sequence, 'dsss', Fs, dataRate, chippingRate);

received = receiver.receive();

assert(isequal(test_data, received));



