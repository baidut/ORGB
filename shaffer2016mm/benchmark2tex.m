function benchmark2tex(filename) % read benchmark.txt, generate latex for evaluation report


if nargin < 1, filename = 'benchmark.txt'; end

T = readtable(filename);

s = load_extractors;
%TODO: all fields
extractors = [s.luv_v, s.y, s.i_theta, s.i_alpha, s.i_b, s.saturation, ...
    s.hue, s.s_prime];%get_default_extractors();

% algos = unique(T.Method);

help latex.beginTableBenchmark

%% complete dataset
for extractor = extractors %algos
    isAlgo = strcmp(T.Method,extractor.name);
    if sum(isAlgo) == 0; continue; end
    t = T(isAlgo,:);
    confmat = ConfMat(table2struct(t(:,end-3:end))); % TP...
    fprintf('%s \t&', extractor.tex);
    confmat.toTex();
end

help latex.tablePart2Header

% adverse
for extractor = extractors
    isAlgo = strcmp(T.Method,extractor.name);
    if sum(isAlgo) == 0; continue; end
    isScen = strcmp(T.Scenario,'AdverseLight');
    t = T(isAlgo&isScen,:);
    confmat = ConfMat(table2struct(t(:,end-3:end))); % TP...
    fprintf('%s \t&', extractor.tex);
    confmat.toTex();
end

help latex.endTableBenchmark

% %% complete dataset
% for algo = algos(1) %algos
%     isAlgo = strcmp(T.Method,algo);
%     t = T(isAlgo,:);
%     confmat = ConfMat(table2struct(t(:,end-3:end))); % TP...
%     fprintf('%s \t& %s', algo.tex, confmat.toTex());
% end
% 
% help table2
% 
% % adverse
% for algo = algos(1) %algos
%     isAlgo = strcmp(T.Method,algo);
%     isScen = strcmp(t.Scenario,'AdverseLight');
%     t = T(isAlgo&isScen,:);
%     confmat = ConfMat(table2struct(t(:,end-3:end))); % TP...
%     fprintf('%s \t& %s', algo.tex, confmat.toTex());
% end


end

