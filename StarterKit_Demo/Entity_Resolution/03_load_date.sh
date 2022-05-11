echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"

## PLEASE modify the line below to the directory where your raw file sits and remove the '#'
export entity_resolution_data_dir=/home/tigergraph/05_Entity_Resolution/Entity_Resolution_Data/


#start all TigerGraph services
gadmin start all


gsql -g entity_resolution "run loading job load_job_video_play using
v_video_play=\"${entity_resolution_data_dir}/video_play.csv\""
gsql -g entity_resolution "run loading job load_job_video using
v_video=\"${entity_resolution_data_dir}/video.csv\""
gsql -g entity_resolution "run loading job load_job_video_genre using
v_video_genre=\"${entity_resolution_data_dir}/video_genre.csv\""
gsql -g entity_resolution "run loading job load_job_video_keyword using
v_video_keyword=\"${entity_resolution_data_dir}/video_keyword.csv\""
gsql -g entity_resolution "run loading job load_job_entity using
v_entity=\"${entity_resolution_data_dir}/entity.csv\""

echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"

