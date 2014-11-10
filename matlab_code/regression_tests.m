% Regression Tests should be placed in here.
% Each test has its own section and can be executed independant
% Use assert, and isequal for the tests.
% Avoid disp
% Create new tests rather than modifying the existing

%% one section for each test
clear all
clc

%% Send an receive random data using DSSS without noise

%setup
medium = Medium;
pnGenerator = PNGenerator(100);
sender = Sender(medium, pnGenerator, 'dsss');
receiver = Receiver(medium, pnGenerator, 'dsss');
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
end

%% Send an receive random data using FHSS

%setup
medium = Medium;
pnGenerator = PNGenerator(100);
sender = Sender(medium, pnGenerator, 'fhss');
receiver = Receiver(medium, pnGenerator, 'fhss');
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
end