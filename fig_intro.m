% I = imread('h49-50_1-2.png');
% J = I(1:end/2,:,:);
% imwrite(J, 'h49_1-2.png');

RGB = imread('h49_1-2.png');
RGB = im2double(RGB);

%% offset-correction
offset = [-0.2534,-0.1970,-0.0932];
ORGB = RGB;
for c = 1:3
    ORGB(:,:,c) = ORGB(:,:,c) - offset(c);
    ORGB(:,:,c) = ORGB(:,:,c)./(1-offset(c));
end

% imwrite(RGB, 'rgb.png');
imwrite(ORGB, 'orgb.png');

%% Color Space Conversion
HSV = rgb2hsv(RGB);
OHSV = rgb2hsv(ORGB);

%% Feature Match
iptsetpref('ImshowBorder','tight');
featmatch.harris(HSV(:,1:end/2,2),HSV(:,(end/2+1):end,2));
print(gcf, 'match', '-djpeg');
featmatch.harris(OHSV(:,1:end/2,2),OHSV(:,(end/2+1):end,2));
print(gcf, 'omatch', '-djpeg');
return;

%% Edge Detection 

e = edge(HSV(:,:,2),'canny');
oe = edge(OHSV(:,:,2),'canny');

imwrite(e, 'e.png');
imwrite(oe, 'oe.png');

return;

%% Color-based Segmentation using Felzen
norm = @(I)bsxfun(@rdivide,I,sum(I,3)); % chromaticity image
normRGB = norm(RGB);
normORGB = norm(ORGB);
% Fig(normRGB, normORGB)
%  Fig(3*normRGB, 3*normORGB)

% Fig(HSV(:,:,2), OHSV(:,:,2))
segfun = @regseg.kmeans; %@(im)regseg.felzen(im,0.3,500,50); %@regseg.felzen; % @watershed; % 
 
seg = segfun(RGB);
oseg = segfun(ORGB);

imwrite(label2rgb(seg), 'seg.png');
imwrite(label2rgb(oseg), 'oseg.png');

% Fig(label2rgb([seg, oseg]))


