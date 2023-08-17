inputDialogues4 = LOAD 'hdfs:///user/arpita/inputs/episodeIV_dialouges.txt' USING PigStorage('\t') AS(name:chararray, line:chararray);
inputDialogues5 = LOAD 'hdfs:///user/arpita/inputs/episodeV_dialouges.txt' USING PigStorage('\t') AS(name:chararray, line:chararray);
inputDialogues6 = LOAD 'hdfs:///user/arpita/inputs/episodeVI_dialouges.txt' USING PigStorage('\t') AS(name:chararray, line:chararray);


-- Filter out first 2 lines from each file
ranked4 = RANK inputDialogues4;
OnlyDialogues4 = FILTER ranked4 BY (rank_inputDialogues4 > 2);
ranked5 = RANK inputDialogues5;
OnlyDialogues5 = FILTER ranked5 BY (rank_inputDialogues5 > 2);
ranked6 = RANK inputDialogues6;
OnlyDialogues6 = FILTER ranked6 BY (rank_inputDialogues6 > 2);



-- Merge the three inputs
inputData = UNION OnlyDialogues4, OnlyDialogues5, OnlyDialogues6;


-- Group By Name
groupByName = GROUP inputData BY name;


-- Count the number of Dialogues by each Character
names = FOREACH groupByName GENERATE $0 as name, COUNT($1) as no_of_lines;
namesOrdered = ORDER names BY no_of_lines DESC;

-- Remove the outputs folder
rmf hdfs:///user/arpita/outputs;

-- Store results in HDFS
STORE namesOrdered INTO 'hdfs:///user/arpita/outputs' USING PigStorage('\t');

