echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"

##PLEASE modify the line below to the directory where your raw file sits and remove the '#'
export antifraud_data_dir=/home/tigergraph/06_AntiFraud/AntiFraud_data/


#start all TigerGraph services
gadmin start all


gsql -g AntiFraud "run loading job load_job_antifraud using
v_client=\"${antifraud_data_dir}/client.csv\",
v_userDevice=\"${antifraud_data_dir}/userDevice.csv\",
v_client_referral=\"${antifraud_data_dir}/client_referral.csv\",
v_device=\"${antifraud_data_dir}/device.csv\",
v_payment=\"${antifraud_data_dir}/payment.csv\",
v_transaction=\"${antifraud_data_dir}/transaction.csv\""


echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"
