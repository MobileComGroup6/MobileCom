% Regression Tests should be placed in here.
% Each test has its own section and can be executed independant
% Use assert, and isequal for the tests.
% Avoid disp
% Create new tests rather than modifying the existing

%% one section for each test
clear all
close all
clc

samplesPerSecond = 4096;
%% Send an receive random data using DSSS without noise

%setup

dataRate = 4;
chippingRate = 64;
medium = Medium;
pnGenerator = PNGenerator(100);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'dsss', samplesPerSecond, dataRate,chippingRate);
receiver = Receiver(medium, sequence, 'dsss', samplesPerSecond, dataRate,chippingRate);
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
    medium.clear();
end

%% Send an receive random data using FHSS

%setup
dataRate = 4;
chippingRate = 64;
medium = Medium;
pnGenerator = PNGenerator(3*12);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'fhss',samplesPerSecond, dataRate,chippingRate);
receiver = Receiver(medium, sequence, 'fhss',samplesPerSecond, dataRate,chippingRate);
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
    medium.clear();
end


%% Send an receive random data using DSSS without noise with short PN sequence

%setup
dataRate = 4;
chippingRate = 64;
medium = Medium;
pnGenerator = PNGenerator(4);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'dsss', samplesPerSecond, dataRate,chippingRate);
receiver = Receiver(medium, sequence, 'dsss', samplesPerSecond, dataRate,chippingRate);

test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
    medium.clear();
end

%% Send an receive random data using FHSS with short PN sequence

%setup
dataRate = 4;
chippingRate = 64;
medium = Medium;
pnGenerator = PNGenerator(3*4);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'fhss',samplesPerSecond, dataRate,chippingRate);
receiver = Receiver(medium, sequence, 'fhss',samplesPerSecond, dataRate,chippingRate);
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
    medium.clear();
end

%% Make sure in DSSS another receiver (with another PN sequence) can not read data

%setup
dataRate = 4;
chippingRate = 64;
medium = Medium;
pnGenerator = PNGenerator(100);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'dsss', samplesPerSecond, dataRate,chippingRate);
receiver = Receiver(medium, sequence, 'dsss', samplesPerSecond, dataRate,chippingRate);
sequence = pnGenerator.step();
receiver2 = Receiver(medium, sequence, 'dsss', samplesPerSecond, dataRate,chippingRate);
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
    data_rec2 = receiver2.receive();
    assert(~isequal(test_data(:,k), data_rec2));
    medium.clear();
end

%% Make sure in FHSS another receiver (with another PN sequence) can not read data

%setup
dataRate = 4;
chippingRate = 64;
medium = Medium;
pnGenerator = PNGenerator(3*12);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'fhss',samplesPerSecond, dataRate,chippingRate);
receiver = Receiver(medium, sequence, 'fhss',samplesPerSecond, dataRate,chippingRate);
sequence = pnGenerator.step();
receiver2 = Receiver(medium, sequence, 'fhss',samplesPerSecond, dataRate,chippingRate);
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
    data_rec2 = receiver2.receive();
    assert(~isequal(test_data(:,k), data_rec2));
    medium.clear();
end

%% Test random number seed

seed = rng(0, 'twister');
rng(seed)
randi(10, 3)
rng(seed)
randi(10, 3)
%% Test clear medium

%setup
dataRate = 4;
chippingRate = 64;
medium = Medium;
pnGenerator = PNGenerator(3*12);
sequence = pnGenerator.step();
sender = Sender(medium, sequence, 'fhss',samplesPerSecond, dataRate,chippingRate);
receiver = Receiver(medium, sequence, 'fhss',samplesPerSecond, dataRate,chippingRate);
sequence = pnGenerator.step();
receiver2 = Receiver(medium, sequence, 'fhss',samplesPerSecond, dataRate,chippingRate);
test_data = randi([0,1],10,1);

jammer = Jammer(medium, samplesPerSecond);

%test
sender.send(test_data(:));
jammer.jam(100, 100, 0.01);
data_rec = receiver.receive();
assert(isequal(test_data(:), data_rec));

medium.clear();
data_rec = receiver.receive();
assert(isequal(data_rec, zeros(size(data_rec))));