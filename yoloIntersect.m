function nonIntersectBoxes = yoloIntersect(classLabels, boxes,image)
% Step 4: yoloIntersect
iouThresh = 0.4;
% Begin non max suppression. If intersection over union of any two bounding boxes is
% higher than a defined threshold, and the two boxes contain the same class,
% remove the box with the the lower box probability.

for i = 1:length(boxes)
    for j = i+1:length(boxes)
        %calculate intersection over union (can also use bboxOverlapRatio
        %with proper toolbox
        intersect = rectint(boxes(i).coords,boxes(j).coords);
        union = boxes(i).coords(3)*boxes(i).coords(4)+boxes(j).coords(3)*boxes(j).coords(4)-intersect;
        iou(i,j) = intersect/union;
        if boxes(i).classIndex == boxes(j).classIndex && iou(i,j) > iouThresh
            [value(i) dropIndex(i)] = min([boxes(i).cellProb boxes(j).cellProb]);
            if dropIndex(i) == 1
                boxes(i).nonMax=0;
            elseif dropIndex(i) == 2
                boxes(j).nonMax=0;
            end
        end
    end
end

nonIntersectBoxes = boxes;

end