%%bash


conda create -n create_cistarget_databases \
    'python=3.10' \
    'numpy=1.21' \
    'pandas>=1.4.1' \
    'pyarrow>=7.0.0' \
    'numba>=0.55.1' \
    'python-flatbuffers'
    
# the motif list was found here: https://resources.aertslab.org/cistarget/motif_collections/


cd /home/lper0012/tasks/margo.montandon/reference/v10nr_clust_public/singletons/
ls -1 *.cb | sed -e 's/\.cb$//' > ../v10nr_cbust_public.txt

# download the matching reference fasta file for ensembl biomart and the rds of ranges used
cd /home/lper0012/tasks/margo.montandon/reference/
wget https://ftp.ensembl.org/pub/release-110/fasta/danio_rerio/dna/Danio_rerio.GRCz11.dna.primary_assembly.fa.gz


cd /home/lper0012/tasks/margo.montandon/Analysis/
#### Variables
genome_fasta='/home/lper0012/tasks/margo.montandon/reference/Danio_rerio.GRCz11.dna.primary_assembly.fa'
region_bed='SCENIC_results/consensus_peak_calling/consensus_regions.bed'
region_fasta='SCENIC_results/consensus_regions.fa'
database_suffix='Drerio_GRCz11_ensembl' 
path_to_motif_collection='/home/lper0012/tasks/margo.montandon/reference/v10nr_clust_public/singletons/'
motif_list='/home/lper0012/tasks/margo.montandon/reference/v10nr_clust_public/v10nr_cbust_public.txt'
n_cpu='20'
#### Get fasta sequences
module load bedtools2 # In our system, load BEDTools
bedtools getfasta -fi ${genome_fasta} -bed ${region_bed} -fo ${region_fasta}
#### Activate environment
 # In our system, initialize conda
conda activate create_cistarget_databases
#### Set ${create_cistarget_databases_dir} to https://github.com/aertslab/create_cisTarget_databases 
create_cistarget_databases_dir='create_cisTarget_databases'
#### Score the motifs - This will generate the scores database we will use later on for DEM

    
${create_cistarget_databases_dir}/create_cistarget_motif_databases.py \
-f ${region_fasta} \
-M ${path_to_motif_collection} \
-m ${motif_list} \
-o ${database_suffix} \
-t ${n_cpu} \
-l \
-s 555
done 
#### Create rankings
motifs_vs_regions_scores_feather = 'PATH_TO_MOTIFS_VS_REGIONS_SCORES_DATABASE'
${create_cista