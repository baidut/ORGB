classdef RoadDetectionFramework
    %RoadDetectionFramework provides the interface of our proposed road
    % detection framework. Extend this class to build your customed
    % implementation.
    % This class also provide a simple implemetation that you can reuse.
    %
    % USAGE: bw = roadDetectionFramework(extractor).parseImgFile(file);
    %
    % See also RoadDetectionImplementation.
    
    properties (GetAccess = public, SetAccess = private)
        extractor
    end
    
    %% Public methods
    methods (Access = public)
        function this = RoadDetectionFramework(extractor)
            this.extractor = extractor;
        end
        
        function roadMask = parseImage(this, im)
            [roi, roiMask] = this.applyRoiDetermination(im);
            roadMask = false([size(im,1) size(im,2)]);
            
            feature  = this.extractor(roi);
            feature  = this.applyFiltering(feature);
            
            segments = this.applySegmentation(feature);
            roadSeg  = this.applyConnectedComponentAnalysis(segments);
            roadSeg  = this.applyMorphologicalFiltering(roadSeg);
            
            roadRoiMask = this.applyHolesFilling(roadSeg);
            % repair mask
            %roi --> full image
            roadMask(roiMask) = roadRoiMask;
            %Fig(feature, label2rgb(segments), roadSeg, roadMask)
        end
        
        function roadMask = parseImageFile(this, imgFile)
            im = imread(imgFile);
            roadMask = this.parseImage(this, im);
        end
    end
    
    %% Main Steps API
    %     methods (Abstract,Static)
    %       applyRoiDetermination(im)
    %       applyFiltering(im)
    %       applySegmentation(im)
    %       applyConnectedComponentAnalysis(bw)
    %       applyMorphologicalFiltering(bw)
    %       applyHolesFilling(bw)
    %     end
    %
    % you can override any module in your subclass if you like :)
    methods (Static)
        % Since these methods is static, each module is independent.
        % Paramater control between modules can be implemented in class
        % constructor.
        
        function [im, roiMask] = applyRoiDetermination(im)
            % Select the lower half of image as ROI
            %im = im((round(end/2)+1):end,:,:); %%%%% todo fix this
            roiMask = false([size(im,1) size(im,2)]);
            roiMask((round(end*3/5)+1):end,:,:) = 1;
            
            im = im((round(end*3/5)+1):end,:,:);
        end
        
%         function bw = revertRoi(bw)
%             % ROI -> full image
%             %bw = [false(size(bw));bw];
%             
%             bw = %[false(size(bw).*[2 1]);bw];
%         end
        
        function im = applyFiltering(im)
            im = imfilter(im, ones(8)/64, 'corr', 'replicate');
            % im = medfilt2(im, [8 8]);
            im = wiener2(im, [8 8]);
        end
        
        function segments = applySegmentation(im)
            segments = regseg.felzen(im, 1.2,300,1000); % 1.5,600,1000
        end
        
        function maxConnected = applyConnectedComponentAnalysis(segments)
            % return the area with the max size of a binary image.
%             maxConnected = false(size(bw));
%             CC = bwconncomp(bw);
%             
%             numPixels = cellfun(@numel,CC.PixelIdxList);
%             [~,idx] = max(numPixels);
%             maxConnected(CC.PixelIdxList{idx}) = 1;

            stat = regionprops(segments,'Centroid','Area','PixelIdxList');
			[~,index] = max([stat.Area]);
			maxConnected = (segments == index);
        end
        
        function bw = applyMorphologicalFiltering(bw)
            bw =  imopen(bw, strel('disk',8,8));
            % 8x8 is the size of a jpeg block
            % using 8x8 is better than 4x4
        end
        
        function bw = applyHolesFilling(bw)
            bw = imfill(bw,'holes');
        end
    end
end
