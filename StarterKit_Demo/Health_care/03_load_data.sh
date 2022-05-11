echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"
time = `date`
echo $time

## PLEASE modify the line below to the directory where your raw file sits and remove the '#'
export healthcare_data_dir=/home/tigergraph/01_health_care/healthcare_data/


#start all TigerGraph services
gadmin start all


gsql -g faers "run loading job load_job_faer using
v_THER=\"${healthcare_data_dir}/THER.csv\",
v_INDI=\"${healthcare_data_dir}/INDI.csv\",
v_REAC=\"${healthcare_data_dir}/REAC.csv\",
v_OUTC=\"${healthcare_data_dir}/OUTC.csv\",
v_RPSR=\"${healthcare_data_dir}/RPSR.csv\",
v_DRUG=\"${healthcare_data_dir}/DRUG.csv\",
v_DEMO=\"${healthcare_data_dir}/DEMO.csv\""


echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"
time = `date`
echo $time

