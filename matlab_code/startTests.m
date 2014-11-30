%How to use:
%The following configuration s are allowed:
% More than one frequnecy OR more then one power or more than one sender

%%
clear all
close all
clc

%%
% setup

loadRandom = false;
saveRandom = true;

%define some paramters for all tests
dataRate= 10;
dataLength = 10;
chippingRate = [10];
chipLength = [10];%,100,1000];
repetitions = 30;
maxNumberOfSenders = 200;
%load or save random numbers, so the same numbers can be used for all
%tests
if loadRandom
   load('randInt.mat', 'randomNumbers')
else
    %the factor 32 is just to make sure we have enough test data even is
    %someone usese more than maxNumberOfSenders senders
    numRandInt = repetitions*length(chippingRate)*length(chipLength)*maxNumberOfSenders*32;
    randomNumbers = randi([0,1],dataLength,numRandInt);
    if saveRandom
        save('randInt.mat', 'randomNumbers')
    end
end   

% for each testcase run testExe
% testExe(  mode,   dataRate,   chippingRates,  chipLengths,    numberOfSenders,        freqs,    bandwidths,   snrs,	randomNumbers,  repetitions)

%DSSS Tests
%test-case d1: DSSS with wideband noise
 testExe(    'dsss', dataRate,   chippingRate,   chipLength,     1,                    100,          100,       [0.1:0.1:1],  randomNumbers,  repetitions);
%test-case d2: DSSS with narrowband noise
 testExe(    'dsss', dataRate,   chippingRate,   chipLength,     1,                    100,          10,       [1:10],  randomNumbers,  repetitions);
%test-case d3: DSSS with multiple users
 testExe(    'dsss', dataRate,   chippingRate,   chipLength,     5,                    100,          30,        [8],    randomNumbers,  repetitions);


%FHSS tests
%test-case f1: FHSS with wideband noise, jamming frequency in middle of the channels with a bandwidth of all 8 channels
 testExe(    'fhss', dataRate,   chippingRate,   chipLength,     1,                   100+4*30,   240,         0.1,     randomNumbers,  repetitions);
%test-case f2: FHSS with narrowband noise, jamming just one channel (#3)
 testExe(    'fhss', dataRate,   chippingRate,   chipLength,     1,                   100+2*30,    30,         0.1,     randomNumbers,  repetitions);
%test-case f3: FHSS with multiple users
 testExe(    'fhss', dataRate,   chippingRate,   chipLength,     5,                   100,   30,         8,     randomNumbers,  repetitions);
