%%
clear all;
close all;
clc;
ProjectSettings.verbose(true);
Fs = 4096;

medium = Medium;

dataRate = 8;
chippingRate = 64;

pnGenerator = PNGenerator(16*3);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'dsss', Fs, dataRate,chippingRate);
sender.setGaussianSNR(10);

jammer = Jammer(medium, Fs);

test_data = randi([0,1],128,1);

sender.send(test_data);

jammer.jam(5, 5 , 3); %frequency, bandwidth (power of 2 optimally), power in multiples of standard output
%jammer.jam(150, 50 , 3);
%jammer.jam(200, 50 , 2);
%jammer.jam(250, 50 , 2);
%jammer.jam(300, 50 , 2);
%jammer.jam(350, 50 , 2);
%jammer.jam(400, 50 , 2);


receiver = Receiver(medium, sequence, 'dsss', Fs, dataRate, chippingRate);

received = receiver.receive();

biterrors = sum(abs(test_data-received));
assert(isequal(test_data, received));
%% Test different bandwidths and powers
close all;

numRep = 5;
medium.clear();

powers = [0.5, 2, 3, 4, 5, 6];
bandwidths = [8, 16, 32, 64, 128, 256];

ProjectSettings.verbose(false);

ber = zeros(numRep,6);
for i=1:6
	for r=1:numRep
		sender.send(test_data);
		
		jammer.jam(100, bandwidths(i), powers(i));
		
		receiver = Receiver(medium, sequence, 'dsss', Fs, dataRate, chippingRate);
		
		received = receiver.receive();
		
		medium.clear();
		
		biterrors = sum(abs(test_data-received));
		ber(r, i) = biterrors;
	end
	
end

close all;
avg = mean(ber);
figure;
plot(bandwidths, avg);





