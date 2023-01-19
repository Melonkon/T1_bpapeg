#!/bin/bash
rm GCF*
python3 sql.py 1

var="$(cat temp.txt)"\

if [ ! -z "$var" ];
then
	wget "$var"
        gunzip *.gz
        mv *.faa OrnAna.fa
        makeblastdb -in OrnAna.fa -dbtype prot -parse_seqids
        blastx -query T1.fa -db OrnAna.fa -outfmt 6 -out totaal.txt
        sort -k1,1 -k11,11g -k3,3nr totaal.txt | sort --merge -u -k1,1 > totaal_sort.txt

        cat totaal_sort.txt | awk '{print $2}' > ensemble_ids.txt
        grep -oE "^>\w+" OrnAna.fa | sed 's/>//g' >> proteoom_ids.txt
        rm Orn*
        rm temp.txt
        rm esum*
        rm tot*

        python3 sql.py 2;

        rm proteoom_ids.txt
	rm output.txt
        rm ensemble_ids.txt
fi

