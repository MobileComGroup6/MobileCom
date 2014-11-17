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


%% Send an receive random data using DSSS without noise with short PN sequence

%setup
medium = Medium;
pnGenerator = PNGenerator(4);
sender = Sender(medium, pnGenerator, 'dsss');
receiver = Receiver(medium, pnGenerator, 'dsss');
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
end

%% Send an receive random data using FHSS with short PN sequence

%setup
medium = Medium;
pnGenerator = PNGenerator(4);
sender = Sender(medium, pnGenerator, 'fhss');
receiver = Receiver(medium, pnGenerator, 'fhss');
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
end

%% Make sure in DSSS another receiver (with another PN sequence) can not read data

%setup
medium = Medium;
pnGenerator = PNGenerator(100);
pnGenerator2 = PNGenerator(100);
sender = Sender(medium, pnGenerator, 'dsss');
receiver = Receiver(medium, pnGenerator, 'dsss');
receiver2 = Receiver(medium, pnGenerator2, 'dsss');
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
    data_rec2 = receiver2.receive();
    assert(~isequal(test_data(:,k), data_rec2));
end

%% Make sure in FHSS another receiver (with another PN sequence) can not read data

%setup
medium = Medium;
pnGenerator = PNGenerator(100);
pnGenerator2 = PNGenerator(100);
sender = Sender(medium, pnGenerator, 'fhss');
receiver = Receiver(medium, pnGenerator, 'fhss');
receiver2 = Receiver(medium, pnGenerator2, 'fhss');
test_data = randi([0,1],10,3);

%test
for k = 1:size(test_data, 2)    
    sender.send(test_data(:,k));
    data_rec = receiver.receive();
    assert(isequal(test_data(:,k), data_rec));
    data_rec2 = receiver2.receive();
    assert(~isequal(test_data(:,k), data_rec2)); % currently failing because frequency hopping not implemented yet
end