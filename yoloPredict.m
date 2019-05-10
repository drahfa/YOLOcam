function out = yoloPredict (yoloml,image, plotflag)
% yoloPredict
if nargin < 3
    plotflag = 0;
end

if plotflag == 1
    figure(1);
    imagesc(image);
end

%run the image through the network. Replace 'gpu' with 'cpu' if you do not
%have a CUDA enbled GPU.

tic
out = predict(yoloml,image,'ExecutionEnvironment','gpu');
toc

if plotflag == 1
    %plot the 1x1470 output vector. Indices 1-980 are class probabilities,
    %981-1079 are cell/box probabilities, and 1080-1470 are bounding box parameters
    figure(2)
    plot(out)
end
return