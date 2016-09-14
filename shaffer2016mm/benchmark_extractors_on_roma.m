function T = benchmark_extractors_on_roma (cfg)
%BENCHMARK_EXTRACTORS_ON_ROMA 
% print latex string in commander window, output 
%
% USAGE
%  benchmark_extractors_on_roma (extractors)
%
% INPUTS
%  extractors - struct array
%   extractor
%   .name   - string
%   .run    - function handle
%   .tex    - name string in latex
%   .paramOfSituation - 1x10 cell of additional parameters, use cell(1,10) if none.
%
% If extractor is not given, then default extractors will be used.
%
% OUTPUTS
%  
% 

if nargin == 0
    cfg = struct;
end


if ~isfield(cfg, 'roma_path')
    cfg.roma_path = 'roma';
end
% cfg.roma_path = 'roma';

if ~isfield(cfg, 'extractors')
    s = load_extractors;
    cfg.extractors = [s.y, s.i_theta, s.i_alpha, s.i_b, s.saturation, ...
        s.hue, s.s_prime];%get_default_extractors();
end

%%?cache
% if ~exist('extractors', 'var')
    roma = RomaDataset(cfg.roma_path);
% end

T = table;

for extractor = cfg.extractors, idx = 0;
    for situation = roma.Situations, idx = idx + 1;
        % for each scenario
        for scenario = roma.Scenarios
            imagefiles = roma.getImageFile(situation{1}, scenario{1});
            labelfiles = roma.getRoadLabelFile(imagefiles);
            
            samples = struct('imagefile',imagefiles, 'labelfile',labelfiles);
            N = numel(samples);
            if N == 0,continue;end
          
            param = extractor.paramOfSituation(idx); 
            if ~isempty(param{:})
                extra = @(im)extractor.run(im,param{:});
            else
                extra = @(im)extractor.run(im);%% TODO
            end

            algo = extractor;
            algo.run = @(im)(RoadDetectionComplex(extra).parseImage(im));
            
            fprintf('Bechmarking [Algo: %s, Situation: %s, Scenario: %s]...', ...
                algo.name, situation{1}, scenario{1});
            
            % benchmark
            for n = 1:N
                im1 = imread(samples(n).imagefile);
                im2 = imread(samples(n).labelfile);
                % preproc
                samples(n).image     = im1;
                samples(n).actual    = im2;
            end
    
            for n = 1:N, samples(n).predict = algo.run(samples(n).image); end
            
            suffix = sprintf('_%s.jpg', algo.name);
            rename = @(f) [f(1:end-4) suffix];
            s = ConfMat.eval(samples,'bound',3, 'savedata', true, 'rename', rename); 
            disp done
           
            % build table 
            Filename  = imagefiles;
            Method    = repmat({algo.name}, [N 1]);
            Scenario  = repmat(scenario, [N 1]);
            Situation = repmat(situation, [N 1]);
            disp(s);
            TP = s.TP(:); TN = s.TN(:); FP = s.FP(:); FN = s.FN(:);
            t = table(Method, Filename, Situation, Scenario, TP, FP, TN, FN);
            
            % append table
            T = [T;t];
        end
    end
end



%% Generate latex for each algorithm
% all datasets


% adversed light condition
% related to file?

% situation condition
% each file come with a confmat

% algos = unique(T.Method);


end

function result = benchmark(algos, samples, varargin)
%BENCHMARK Evaluate pixel-wise segmentation algorithms on one image
% dataset.
%
% REQUIRED INPUTS
%  algos         - 1xN struct of algo
%   algo
%   .name   - string
%   .run    - function handle
% 
%  samples    - 1xN struct of data
%   sample
%   .imagefile % raw image file
%   .labelfile % groundtruth image file
%
% PARAMETERS
%  preproc     - do prepocessing on raw image which is not count in time.
%  bound       - [0]
%  roi         - perform roi selection on raw image and groundtruth.
%  resize      - resize raw image and groundtruth.
%
% OUTPUTS
%
%
% EXAMPLE 1

%
% EXAMPLE 2

%   Copyright 2015-2016 Zhenqiang Ying.

assert(isstruct(algos));
assert(isstruct(dataset));

p = inputParser;
p.KeepUnmatched = true;
p.addParameter('preproc',   '', @ischar);
p.parse(varargin{:});
param = p.Results;
extra = p.Unmatched; % pass param

N = numel(samples);

for algo = algos
    fprintf('Benchmarking: %s...', algo.name);
    
    for n = 1:N
        im1 = imread(samples(n).imagefile);
        im2 = imread(samples(n).labelfile);
        if ~isempty(param.preproc),
            im1 = param.preproc(im1);
            im2 = param.preproc(im2);
        end
        samples(n).image     = im1;
        samples(n).actual    = im2;
    end
    
    %% benchmarking...
    tic;
    for n = 1:N, samples(n).preidct = algo.run(samples(n).image); end
    time = toc/N;
    
    result.(algo.name).confmat = ConfMat(samples, extra);
    result.(algo.name).time = time;
    % rename (1:end-4) '_', algo.name, '.bmp'];
    
    %     count = count + 1;
    %
    %     algo.dumpFiles = maskedImgFile;
    %
    %     this.algos{count} = algo;
end

% this.algos = [this.algos{:}]; % cell 2 struct array
end