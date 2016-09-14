s = load_extractors;
cfg.extractors = s.saturation; %[s.luv_v, s.saturation,s.hue, s.s_prime];%get_default_extractors();
cfg.roma_path = 'oroma';

T = benchmark_extractors_on_roma (cfg);
writetable(T, 'benchmark_oroma.txt');


s = load_extractors;
cfg.roma_path = 'roma';

T = benchmark_extractors_on_roma (cfg);
writetable(T, 'benchmark_roma.txt');


benchmark2tex('benchmark_roma.txt');
benchmark2tex('benchmark_oroma.txt');