%How to use:
%The following configuration s are allowed:
% More than one frequnecy OR more then one power OR more than one sender OR
% more than one bandwidth

%When using different frequency to jam, make sure, that the first frequency
%is not within the transmission bandwidth, and that frequency 2:n+1 cover
%channel 1:n. This is requierd to have a corrct x-axis label in the plot

%%
clear all
close all
clc

%%
% setup

loadRandom = true;
saveRandom = false;

%define some paramters for all tests
dataRate= 8;
dataLength = 1024;
%multiples of dataRate
chippingRateFHSS = [1/8, 1/2 , 4 , 16];
chippingRateFHSS = chippingRateFHSS * dataRate;
%absolute values
chippingRateDSSS = [16, 32, 64, 96];
chipLength = [16,64]; %must be at least 4
repetitions = 2;
maxNumberOfSenders = 200;
gaussSNR = 10;
%load or save random numbers, so the same numbers can be used for all
%tests
if loadRandom
   load('randInt.mat', 'randomNumbers')
else
    %the factor 32 is just to make sure we have enough test data even is
    %someone usese more than maxNumberOfSenders senders
    numRandInt = repetitions*length(chippingRateDSSS)*length(chipLength)*maxNumberOfSenders*32;
    randomNumbers = randi([0,1],dataLength,numRandInt);
    if saveRandom
        save('randInt.mat', 'randomNumbers')
    end
end   

% for each testcase run testExe
% testExe(mode, dataRate, chippingRates, chipLengths, numberOfSenders, freqs, powers, bandwidths, randomNumbers, repetitions, testName)

ProjectSettings.saveResultPlots(true);

%DSSS Tests

%DSSS with multiple users
% testExe(    'dsss', dataRate,   chippingRateDSSS,   chipLength,     [1:1:15],   gaussSNR,   100,	0,          100,	randomNumbers,  repetitions, 'numSenders');

% DSSS with wideband noise
% testExe(    'dsss', dataRate,   chippingRateDSSS,   chipLength,     1,          gaussSNR,	100,	[0:1:15],	1000,	randomNumbers,  repetitions, 'wideband');

%DSSS narrowband
%TODO: This is still weird!
% testExe(    'dsss', dataRate,   chippingRateDSSS,   chipLength,     1,          gaussSNR,	100,	[0:1:15],	16,     randomNumbers,  repetitions, 'narrowband');

%DSSS with different bandwidthes
%TODO: The SNR recreases, the wider the bandwidth of the noise is. THis
%makes a interpretation harder.
% testExe(    'dsss', dataRate,   chippingRateDSSS,   chipLength,     1,          gaussSNR,	100,	100,	[1,5,10,20,100,500,1000],  randomNumbers,  repetitions, 'bandwidth');


%FHSS tests

%FHSS with multiple users
%testExe(    'fhss', dataRate,   chippingRateFHSS,   chipLength,     [1:1:15],	gaussSNR,	100,    0,          100,    randomNumbers,  repetitions, 'numSenders');

%FHSS with wideband noise, jamming frequency in middle of the channels with a bandwidth of all 8 channels
%testExe(    'fhss', dataRate,   chippingRateFHSS,   chipLength,     1,          gaussSNR,	300,	[0:1:15],	1000,	randomNumbers,  repetitions, 'wideband');

%FHSS narrowband
 %TODO: This is still weird!
testExe(    'fhss', dataRate,   chippingRateFHSS,   chipLength,     1,          gaussSNR,	[5,[100:50:100+8*50]],	3,	50,     randomNumbers,  repetitions, 'narrowband');

%FHSS with different bandwidthes
%TODO: The SNR decreases, the wider the bandwidth of the noise is. THis
%makes a interpretation harder.
%testExe(    'fhss', dataRate,   chippingRateFHSS,   chipLength,     1,          gaussSNR,	300,          100,       [1,5,10,20,100,500,1000],  randomNumbers,  repetitions, 'bandwidth');


%Different gaussian SNR
%testExe(    'fhss', dataRate,   chippingRateFHSS,   chipLength,     1,          [-2:-1:-10],	300,          0,       100,  randomNumbers,  repetitions, 'gaussianSNR');
