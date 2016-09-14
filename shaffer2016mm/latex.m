classdef latex
    methods(Static)
        function beginTableBenchmark
            % \begin{table} %[b]
            % \centering
            % \caption{Performance on ROMA Dataset.}
            % \tabcolsep=0.11cm
            % \begin{tabular}{|l|c|c|c|c|c|} % \hline
            % \cline{2-6}
            % \multicolumn{1}{c|}{} & \multicolumn{5}{|c|}{Complete dataset} \\
            % \cline{2-6}
            % \multicolumn{1}{c|}{} & $\hat{g}$ & $DR$ & $DA$ & $F$ & $VRI$ \\ \hline
        end
        function tablePart2Header
            % %table 2
            % \multicolumn{1}{c|}{} & \multicolumn{5}{|c|}{Adverse lighting conditions} \\  % Adverse Light
            % \cline{2-6}
            % \multicolumn{1}{c|}{} & $\hat{g}$ & $DR$ & $DA$ & $F$ & $VRI$ \\ \hline
        end
        
        function endTableBenchmark
            % \end{tabular}
            % \label{tbl-accuracyComparison}
            % \end{table}
        end
    end
end