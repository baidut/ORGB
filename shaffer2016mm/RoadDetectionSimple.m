classdef RoadDetectionSimple < RoadDetectionFramework
    % this class show an example of extending our main framework this
    % extension use bi-segmentation which is enough for relatively simple
    % scene, e.g. ROMA Datasets.
    
   %% Main Steps Implementation
    methods (Static)
        function bw = applySegmentation(im)
            bw = im2bw(im, graythresh( im ( im >0.2 & im < 0.8) ));
        end
        
        function bw = applyConnectedComponentAnalysis(bw) % do nothing
        end
    end
    
    methods (Access = public)
        function this = RoadDetectionSimple(extractor)
            this@RoadDetectionFramework(extractor);
        end
    end

end
