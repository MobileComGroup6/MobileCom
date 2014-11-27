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
% testExe(  mode,   dataRate,   chippingRates,  chipLengths,    numberOfSenders,    jammingMode,    freqs,   powers,	randomNumbers,  repetitions)

%DSSS Tests
%test-case d1: DSSS with wideband noise
% testExe(    'dsss', dataRate,   chippingRate,   chipLength,     1,                  'wideband',     100,    [1:20],   randomNumbers,  repetitions);
%test-case d2: DSSS with multiple users
% testExe(    'dsss', dataRate,   chippingRate,   chipLength,     maxNumberOfSenders,                  'wideband',     100,    [1],   randomNumbers,  repetitions);


%FHSS tests
%test-case f1
testExe(    'fhss', dataRate,   chippingRate,   chipLength,     1,                  'narrowband',   [100:5:150],  1,      randomNumbers,  repetitions);