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

jammer.jam(100, 16 , 2.5); %frequency, bandwidth (power of 2 optimally), power in multiples of standard output


receiver = Receiver(medium, sequence, 'dsss', Fs, dataRate, chippingRate);

received = receiver.receive();



biterrors = sum(abs(test_data-received))
assert(isequal(test_data, received));



