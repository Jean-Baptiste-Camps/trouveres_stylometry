# Clean
rm train_cleaned_*/*
rm unseen_cleaned/*tokenized*
rm *_lemmas/*
rm *_pos/*
# Train data
~/boudams/env/bin/boudams tag ~/boudams/models/fro_denorm.boudams_model train_cleaned/*
mv train_cleaned/*tokenized* train_cleaned_segm/
~/pie/env/bin/pie tag "train_cleaned_segm/*.tokenized.txt" ~/pie/fro_expan_02b-normalised-2022_04_22-12_24_15.tar
mv train_cleaned_segm/*pie* train_cleaned_segm+norm/
perl -i -pe "s/^.*\t(.+)$/\1/g" train_cleaned_segm+norm/*.tokenized-pie.txt
perl -i -pe "s/\n/ /g"  train_cleaned_segm+norm/*.tokenized-pie.txt
perl -i -pe "s/normalised //g"  train_cleaned_segm+norm/*.tokenized-pie.txt
~/pie-extended/env/bin/pie-extended tag fro train_cleaned_segm+norm/*tokenized-pie.txt
cp train_cleaned_segm+norm/*-pie-pie.txt train_cleaned_segm+norm+lemmat/
cp train_cleaned_segm+norm/*-pie-pie.txt train_lemmas/
cp train_cleaned_segm+norm/*-pie-pie.txt train_pos/
# Unseen data (with proper envs)
~/boudams/env/bin/boudams tag ~/boudams/models/fro_denorm.boudams_model unseen_cleaned/*
~/pie/env/bin/pie tag "unseen_cleaned/*.tokenized.txt" ~/pie/fro_expan_02b-normalised-2021_07_01-09_49_27.tar
perl -i -pe "s/^.*\t(.+)$/\1/g" unseen_cleaned/*.tokenized-pie.txt
perl -i -pe "s/\n/ /g"  unseen_cleaned/*.tokenized-pie.txt
perl -i -pe "s/normalised //g"  unseen_cleaned/*.tokenized-pie.txt
~/pie-extended/env/bin/pie-extended tag fro unseen_cleaned/*tokenized-pie.txt
cp unseen_cleaned/*tokenized-pie-pie.txt unseen_lemmas/
cp unseen_cleaned/*tokenized-pie-pie.txt unseen_pos/
# And then, get just lemmas or pos
perl -i -pe "s/^[^\t]+\t([^\t]+)\t.*\n/\1\n/g" *_lemmas/*
perl -i -pe "s/^[^\t]+\t[^\t]+\t([^\t]+)\t.*\n/\1\n/g" *_pos/*
perl -i -pe "s/^lemma\n//g" *_lemmas/*
perl -i -pe "s/^POS\n//g" *_pos/*
