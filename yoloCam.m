function yoloCam
% yoloCam: Running YOLO Object Detection via webcam
% Copyright: Ahmad Faisal Ayob, May 2019
% Written in MATLAB 2019a
%
% Credits: the initial codes for the pre-trained YOLO modification and testing can
% be found from the works of James Browning (2019), YOLO Object Detection in MATLAB, Start to Finish
% https://towardsdatascience.com/yolo-object-detection-in-matlab-start-to-finish-3f78ec80419d
%
% "Thanks James for your wonderful work" ~ Faisal

if exist('yoloml') ~= 1
    load('yoloml.mat')
end
% Initiate webcam. Make sure Webcam Support for MATLAB was installed in
% your computer
cam = webcam(1);
n=1;
while n ==1
plotflag = 0;

% get image via ScreenGrab or webcam
image = single(imresize(snapshot(cam),[448 448]))/255;

% Define 20 class labels that yolo has been trained on. Classes are in
% alphabetical order.
classLabels = ["aeroplane",	"bicycle",	"bird"	,"boat",	"bottle"	,"bus"	,"car",...
    "cat",	"chair"	,"cow"	,"diningtable"	,"dog"	,"horse",	"motorbike",	"person",	"pottedplant",...
    "sheep",	"sofa",	"train",	"tvmonitor"];

out = yoloPredict (yoloml, image, plotflag);
[contain, cellProb, cellIndex,outArray, classMaxIndex] = yoloReshape (out,plotflag);
% check if no object detected via the use of [contain]
if nnz(contain) ~= 0
    boxes = yoloPlot (contain, cellProb, cellIndex, outArray, classMaxIndex, classLabels, plotflag);
    
    nonIntersectBoxes = yoloIntersect(classLabels, boxes,image);
    
    % plot result with 'non max suppression' or 'non intersected boxes'
    imshow(image);
    hold on
    for i = 1:length(nonIntersectBoxes)
        if nonIntersectBoxes(i).nonMax == 1
            textStr = convertStringsToChars(classLabels(nonIntersectBoxes(i).classIndex));
            position = [(boxes(i).cellIndex(2)-1)*448/7 (nonIntersectBoxes(i).cellIndex(1)-1)*448/7];
            text(position(1),position(2),textStr,'Color',[0 1 0],'fontWeight','bold','fontSize',12);
            rectangle('Position',nonIntersectBoxes(i).coords, 'EdgeColor','green','LineWidth',2);
        end
    end
    hold off
else
    imshow(image); %so no boxes detected, just show image without box
end

end
clear cam
