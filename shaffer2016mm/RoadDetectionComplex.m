classdef RoadDetectionComplex < RoadDetectionFramework
    % this class show another example of extending our main framework
    % this extension use multi-segmentation 
    % instead of bi-segmentation to support complex conditions.
    
   %% Main Steps Implementation
    methods (Static)
        function im = imageFiltering(im)
            im = medfilt2(im, [8 8]);
        end
        
        function bw = applyMorphologicalFiltering(bw) % do nothing
        end
    end
    
    methods (Access = public)
        function this = RoadDetectionComplex(extractor)
            this@RoadDetectionFramework(extractor);
        end
    end

end
