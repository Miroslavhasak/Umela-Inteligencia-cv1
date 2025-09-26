% Eliminujte kríženie v GA. 

clc; clear;
numgen = 500;    % number of generations
lpop = 50;       % number of chromosomes in population
lstring = 10;     % number of genes in a chromosome
M = 500;          % maximum of the search space

runs = 5;         % kolko krat spustit
bestResults = zeros(1, runs);       % najlepsie vysledky
avgEvolution = zeros(1, numgen);    % priemerna krivka
allEvolutions = zeros(runs, numgen); % ulozi evoluciu z kazdeho behu

figure(1); hold on;

for r = 1:runs
    Space = [ones(1,lstring)*(-M); ones(1,lstring)*M];
    Delta = Space(2,:)/100;
    Pop = genrpop(lpop, Space);

    evolution = zeros(1, numgen);

    % Evolucia
    for gen = 1:numgen
        Fit = testfn3(Pop);
        evolution(gen) = min(Fit);

        Best = selbest(Pop, Fit, [2,0]);
        Old = selrand(Pop, Fit, 18);

        Work1 = selsus(Pop, Fit, 15);
        Work2 = selsus(Pop, Fit, 15);

        %Work1 = crossov(Work1, 1, 0);

        Work2 = mutx(Work2, 0.15, Space);
        Work2 = muta(Work2, 0.15, Delta, Space);

        Pop = [Best; Old; Work1; Work2];
    end

    % uloz najlepsiu hodnotu z tohto behu
    bestResults(r) = min(evolution);

    % pricitaj evoluciu pre vypocet priemeru
    avgEvolution = avgEvolution + evolution;

    % uloz evoluciu behu pre neskorsie porovnanie
    allEvolutions(r,:) = evolution;

    % vykresli jednotlive behy modrou
    plot(evolution, 'b');
end

% priemerna krivka
avgEvolution = avgEvolution / runs;
plot(avgEvolution, 'r', 'LineWidth', 2);

% najlepšia krivka zo všetkých behov (s najnižšou finálnou hodnotou)
[~, bestRun] = min(bestResults);
plot(allEvolutions(bestRun,:), 'g', 'LineWidth', 2);

% vypis vysledky
disp('Priemer najlepsich hodnot:');
disp(mean(bestResults));

disp('Globalne najlepsia hodnota:');
disp(min(bestResults));
