% setup

loadRandom = false;
saveRandom= true;

%define some paramters for all tests
dataRate= 8;
dataLength = 16;
chippingRate = [64,128,256];
chipLength = [8,16,32];
repetitions = 2;
maxNumberOfSenders = 2
%load or save random numbers, so the same numbers can be used for all
%tests
if loadRandom
   load('randInt.mat', 'randomNumbers')
else
    numRandInt = repetitions*length(chippingRate)*length(chipLength)*maxNumberOfSenders*32;
    randomNumbers = randi([0,1],dataLength,numRandInt);
    if saveRandom
        save('randInt.mat', 'randomNumbers')
    end
end   

% for each testcase run testExe

%DSSS Tests

%test-case 1: DSSS
% testExe(mode, dataRates, chippingRates, chipLengths, numberOfSenders, jammingMode, freqs, powers, randomNumbers, repetitions)
testExe('dsss', dataRate, chippingRate, chipLength, 1, 'wideband',100, [1,2,3], randomNumbers, repetitions);
