function harris(I1,I2)
% http://cn.mathworks.com/help/vision/ref/showmatchedfeatures.html

% I1 = rgb2gray(imread('parkinglot_left.png'));
% I2 = rgb2gray(imread('parkinglot_right.png'));
%% Detect SURF features
featfun = @detectFASTFeatures;
%@detectMinEigenFeatures; %@detectBRISKFeatures; %@detectSURFFeatures; % @detectHarrisFeatures

points1 = featfun(I1,'MinContrast',eps,'MinQuality', eps);
points2 = featfun(I2,'MinContrast',eps,'MinQuality', eps);
%% Extract features

% figure, imshow(I1); 
% hold on; plot(points1);return;

[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);
%% Match features.

indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(1:end, 1));
matchedPoints2 = vpts2(indexPairs(1:end, 2));
%% Visualize candidate matches.

figure; ax = axes;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
% title(ax, 'Candidate point matches');
% legend(ax, 'Matched points 1','Matched points 2');

end