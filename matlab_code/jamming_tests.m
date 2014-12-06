%%
%clear all;
close all;
clc;
ProjectSettings.verbose(true);
Fs = 4096;

medium = Medium;

dataRate = 8;
chippingRate = 4;

pnGenerator = PNGenerator(16*3);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'fhss', Fs, dataRate,chippingRate);
sender.setGaussianSNR(10);

jammer = Jammer(medium, Fs);

test_data = randi([0,1],128,1);

sender.send(test_data);

jammer.jam(612, 4 , 2); %frequency, bandwidth (power of 2 optimally), power in multiples of standard output
%jammer.jam(100+128*1, 64 , 2.5);
%jammer.jam(100+128*2, 64 , 2.5);
%jammer.jam(100+128*3, 64 , 2.5);
%jammer.jam(100+128*4, 64 , 3);
%jammer.jam(100+128*5, 64 , 3);
%jammer.jam(100+128*6, 64 , 3);
%jammer.jam(100+128*7, 64 , 3);


receiver = Receiver(medium, sequence, 'fhss', Fs, dataRate, chippingRate);

received = receiver.receive();

biterrors = sum(abs(test_data-received))/size(test_data,1)
assert(isequal(test_data, received));
%% Test different bandwidths and powers
close all;

numRep = 5;
medium.clear();

powers = [0.5, 2, 3, 4, 5, 6];
bandwidths = [1000];

ProjectSettings.verbose(false);

ber = zeros(numRep,6);
for i=1:6
	for r=1:numRep
		sender.send(test_data);
		
		jammer.jam(550, bandwidths(1), powers(i));
		
		receiver = Receiver(medium, sequence, 'fhss', Fs, dataRate, chippingRate);
		
		received = receiver.receive();
		
		medium.clear();
		
		biterrors = sum(abs(test_data-received))/size(test_data,1)
		ber(r, i) = biterrors;
	end
	
end

close all;
avg = mean(ber);
figure;
plot(bandwidths, avg);





