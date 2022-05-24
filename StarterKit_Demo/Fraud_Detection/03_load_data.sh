echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"

## PLEASE modify the line below to the directory where your raw file sits and remove the '#'
export fraud_detection_data_dir=/home/tigergraph/07_Fraud_Detection/fraud_detection_data/


#start all TigerGraph services
gadmin start all

gsql -g Fraud_Detection "run loading job load_job_bank using
v_bank=\"${fraud_detection_data_dir}/bank.csv\""

gsql -g Fraud_Detection "run loading job load_job_merchant_account using
v_merchant_account=\"${fraud_detection_data_dir}/merchant_account.csv\""

gsql -g Fraud_Detection "run loading job load_job_merchant_payment using
v_merchant_payment=\"${fraud_detection_data_dir}/merchant_payment.csv\""

gsql -g Fraud_Detection "run loading job load_job_payment using
v_payment=\"${fraud_detection_data_dir}/payment.csv\""

gsql -g Fraud_Detection "run loading job load_job_device using
v_device=\"${fraud_detection_data_dir}/device.csv\""

gsql -g Fraud_Detection "run loading job load_job_user using
v_user=\"${fraud_detection_data_dir}/user.csv\""

gsql -g Fraud_Detection "run loading job load_job_user_account using
v_user_account=\"${fraud_detection_data_dir}/user_account.csv\""

gsql -g Fraud_Detection "run loading job load_job_device_phone_number using
v_device_phone_number=\"${fraud_detection_data_dir}/device_phone_number.csv\""

echo "data now : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"
