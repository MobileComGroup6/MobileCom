%%
clear all;
close all;
clc;
ProjectSettings.verbose = true;
Fs = 4096;

medium = Medium;

dataRate = 8;
chippingRate = 8;

pnGenerator = PNGenerator(16*3);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'fhss', Fs, dataRate,chippingRate);
sender.setGaussianSNR(10);

jammer = Jammer(medium, Fs);

test_data = randi([0,1],1024,1);

sender.send(test_data);

jammer.jam(5, 5 , 3); %frequency, bandwidth (power of 2 optimally), power in multiples of standard output
%jammer.jam(150, 50 , 3);
%jammer.jam(200, 50 , 2);
%jammer.jam(250, 50 , 2);
%jammer.jam(300, 50 , 2);
%jammer.jam(350, 50 , 2);
%jammer.jam(400, 50 , 2);

receiver = Receiver(medium, sequence, 'fhss', Fs, dataRate, chippingRate);

received = receiver.receive();



biterrors = sum(abs(test_data-received))
assert(isequal(test_data, received));



