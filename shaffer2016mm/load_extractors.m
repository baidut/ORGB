function extractors = load_extractors()

extractors .i_theta     .run = @rgb2ii.alvarez2011;
extractors .i_alpha     .run = @(image, alpha)rgb2ii.maddern2014(image, alpha, false);
extractors .i_b         .run = @rgb2ii.ying2016;
extractors .saturation  .run = @(im)(1-gray.saturation(im));
extractors .hue         .run = @(im)(1-gray.hue(im)); 
extractors .s_prime     .run = @(im)(1-gray.sprime(im));
extractors .y           .run = @(im)im2double(rgb2gray(im));
extractors .luv_v       .run = @(im)(1-histeq(gray.luv_v(im)));

extractors .i_theta     .tex = '$\mathcal{I''}_{\theta}$';
extractors .i_alpha     .tex = '$\mathcal{I''}_{\alpha}$';
extractors .i_b         .tex = '$\mathcal{I''}_{b}(ours)$';
extractors .saturation  .tex = '$S$';
extractors .hue         .tex = '$H$';
extractors .s_prime     .tex = '$S''$';
extractors .y           .tex = '$Y$';
extractors .luv_v       .tex = '$V(CIELUV)$';

extractors .i_theta     .name = 'i_theta';
extractors .i_alpha     .name = 'i_alpha';
extractors .i_b         .name = 'i_b';
extractors .saturation  .name = 'saturation';
extractors .hue         .name = 'hue';
extractors .s_prime     .name = 's_prime';
extractors .y           .name = 'gray';
extractors .luv_v       .name = 'luv_v';

extractors .i_theta     .paramOfSituation = num2cell([.18 .22 .11 .11 .11 .11 .17 .30 .21 .22]);
extractors .i_alpha     .paramOfSituation = num2cell([.69 .52 .42 .42 .43 .43 .66 .90 .81 .83]);
extractors .i_b         .paramOfSituation = num2cell([.20 .10 .01 .01 .05 .05 .05 .13 .07 .07]);
extractors .saturation  .paramOfSituation = repmat({[]},[1 10]);
extractors .hue         .paramOfSituation = repmat({[]},[1 10]);
extractors .s_prime     .paramOfSituation = repmat({[]},[1 10]);
extractors .y           .paramOfSituation = repmat({[]},[1 10]);
extractors .luv_v       .paramOfSituation = repmat({[]},[1 10]);

% add othe attributes of extractor here
% extractors .i_theta .paramOfKitti = ...

% add your extractor here
% extractors .custom = struct('run', @..., 'tex', '$$' ...
end