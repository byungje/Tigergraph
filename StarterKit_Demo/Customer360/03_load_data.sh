echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"

## PLEASE modify the line below to the directory where your raw file sits and remove the '#'
export customer360_data_dir=/home/tigergraph/04_Customer360/Custome360_data/


#start all TigerGraph services
gadmin start all

gsql -g customer "run loading job load_job_Lead using
v_Lead=\"${customer360_data_dir}/Lead.csv\""

gsql -g customer "run loading job load_job_OpportunityContactRole using
v_OpportunityContactRole=\"${customer360_data_dir}/OpportunityContactRole.csv\""

gsql -g customer "run loading job load_job_Campaign using
v_Campaign=\"${customer360_data_dir}/Campaign.csv\""

gsql -g customer "run loading job load_job_CampaignMember using
v_CampaignMember=\"${customer360_data_dir}/CampaignMember.csv\""

gsql -g customer "run loading job load_job_Opportunity using
v_Opportunity=\"${customer360_data_dir}/Opportunity.csv\""

gsql -g customer "run loading job load_job_Account using
v_Account=\"${customer360_data_dir}/Account.csv\""

gsql -g customer "run loading job load_job_Contact using
v_Contact=\"${customer360_data_dir}/Contact.csv\""

echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"

