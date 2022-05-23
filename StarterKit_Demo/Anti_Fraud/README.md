# Anti-Fraud (AML)

# 1. 스키마 DDL

- 01_schema_DDL.gsql 다운로드

```bash
$wget https://raw.githubusercontent.com/byungje/Tigergraph/main/StarterKit_Demo/Anti_Fraud/01_schema_DDL.gsql
```

[01_schema_DDL.gsql](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/01_schema_DDL.gsql)

```graphql
CREATE VERTEX transaction(PRIMARY_ID id STRING, ts UINT, amount FLOAT) WITH STATS="OUTDEGREE_BY_EDGETYPE", PRIMARY_ID_AS_ATTRIBUTE="false"
CREATE VERTEX User(PRIMARY_ID id STRING, signupEpoch UINT, mobile STRING, trust_score FLOAT) WITH STATS="OUTDEGREE_BY_EDGETYPE", PRIMARY_ID_AS_ATTRIBUTE="false"
CREATE VERTEX Device_Token(PRIMARY_ID id STRING, is_banned BOOL, os_name STRING, os_version STRING, model STRING, carrier STRING, is_rooted BOOL, is_emulator BOOL, device_name STRING, trust_score FLOAT) WITH STATS="OUTDEGREE_BY_EDGETYPE", PRIMARY_ID_AS_ATTRIBUTE="false"
CREATE VERTEX Payment_Instrument(PRIMARY_ID id STRING, token_handle STRING, token_type STRING, card_issuing_country_iso2 STRING, card_issuing_bank STRING, card_bin STRING, trust_score FLOAT) WITH STATS="OUTDEGREE_BY_EDGETYPE", PRIMARY_ID_AS_ATTRIBUTE="false"
CREATE DIRECTED EDGE User_Transfer_Transaction(FROM User, TO transaction) WITH REVERSE_EDGE="User_Transfer_Transaction_Rev"
CREATE UNDIRECTED EDGE User_to_Device(FROM User, TO Device_Token)
CREATE UNDIRECTED EDGE User_to_Payment(FROM User, TO Payment_Instrument)
CREATE DIRECTED EDGE User_Refer_User(FROM User, TO User) WITH REVERSE_EDGE="User_Referred_By_User"
CREATE DIRECTED EDGE User_Receive_Transaction(FROM User, TO transaction) WITH REVERSE_EDGE="User_Receive_Transaction_Rev"

CREATE GRAPH AntiFraud(transaction, User, Device_Token, Payment_Instrument, User_Transfer_Transaction, User_to_Device, User_to_Payment, User_Refer_User, User_Receive_Transaction)https://tigergraph-testdrive-testdata.s3.amazonaws.com/antifraud-cloud_data.tar.g
```

- 01_schema_DDL.gsql 실행

```bash
$gsql 01_schema_DDL.gsql
```

# 2. 데이터 다운로드

```bash
$wget https://tigergraph-testdrive-testdata.s3.amazonaws.com/antifraud-cloud_data.tar.gz
$tar xzvf antifraud-cloud_data.tar.gz
```

![Untitled](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/Untitled.png)

![Untitled](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/Untitled%201.png)

# 3. Loading Job 생성

```bash
$wget https://raw.githubusercontent.com/byungje/Tigergraph/main/StarterKit_Demo/Anti_Fraud/02_load_data.gsql
```

[02_load_data.gsql](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/02_load_data.gsql)

```graphql
USE GRAPH AntiFraud

CREATE LOADING JOB load_job_antifraud FOR GRAPH AntiFraud {
      DEFINE FILENAME v_client;
      DEFINE FILENAME v_userDevice;
      DEFINE FILENAME v_client_referral;
      DEFINE FILENAME v_device;
      DEFINE FILENAME v_payment;
      DEFINE FILENAME v_transaction;
    

      LOAD v_client TO VERTEX User VALUES($0, $1, $2, $3) USING SEPARATOR="\t", HEADER="true", EOL="\n";
      LOAD v_device TO VERTEX Device_Token VALUES($0, $1, $2, $3, $4, $5, $6, $7, $8, $10) USING SEPARATOR="\t", HEADER="true", EOL="\n";
      LOAD v_payment TO VERTEX Payment_Instrument VALUES($1, $2, $3, _, $5, $7, $10) USING SEPARATOR="\t", HEADER="true", EOL="\n";
      LOAD v_transaction TO VERTEX transaction VALUES($0, $4, $3) USING SEPARATOR="\t", HEADER="true", EOL="\n";
      
      LOAD v_userDevice TO EDGE User_to_Device VALUES($0, $1) USING SEPARATOR="\t", HEADER="true", EOL="\n";
      LOAD v_client_referral TO EDGE User_Refer_User VALUES($1, $0) USING SEPARATOR="\t", HEADER="true", EOL="\n";
      LOAD v_payment TO EDGE User_to_Payment VALUES($0, $1) USING SEPARATOR="\t", HEADER="true", EOL="\n";
      LOAD v_transaction TO EDGE User_Transfer_Transaction VALUES($2, $0) USING SEPARATOR="\t", HEADER="true", EOL="\n";
      LOAD v_transaction TO EDGE User_Receive_Transaction VALUES($1, $0) USING SEPARATOR="\t", HEADER="true", EOL="\n";
    
	}
```

- 02_load_data.gsql 실행

```bash
$gsql 02_load_data.gsql
```

![Untitled](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/Untitled%202.png)

# 4. 데이터 업로드

- 03_load_data.sh 파일 내 export 경로 수정해서 실행!!!

```bash
$wget https://raw.githubusercontent.com/byungje/Tigergraph/main/StarterKit_Demo/Anti_Fraud/03_load_data.sh
```

[03_load_date.sh](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/03_load_date.sh)

```bash
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
```

- 03_load_data.sh 실행

```bash
$./03_load_data.sh
```

![Untitled](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/Untitled%203.png)

# 5. Query Install

```bash
$wget https://raw.githubusercontent.com/byungje/Tigergraph/main/StarterKit_Demo/Anti_Fraud/04_query.gsql
```

[04_query.gsql](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/04_query.gsql)

```graphql
USE GRAPH AntiFraud

CREATE OR REPLACE QUERY SameReceiverSender(vertex<transaction> transaction_input) FOR GRAPH AntiFraud {
/* 
 This query is used to find out whether a user conduct fraudulent transaction for themselves 
 via fake accounts.
 
 Given an input transaction, return true when its receiver and sender are connected via 
 Device_Token and Payment_Instrument within 4 steps.    

  Sample input
  transaction: any integer between 1 and 1000.
*/
  OrAccum<bool> @fromReceiver, @fromSender;
  OrAccum<bool> @@isSame;

  SetAccum<edge> @@edgeSet;

  Start (ANY) = {transaction_input};

  // get the sender and receiver
  Start = SELECT t FROM Start:s-((User_Receive_Transaction_Rev|User_Transfer_Transaction_Rev):e)-:t
          ACCUM
            // mark the sender and receiver according to the edge type
            case when e.type == "User_Receive_Transaction_Rev" then
              t.@fromReceiver += true
            else
              t.@fromSender += true
            end
            ,@@edgeSet += e
  ;

  // traverse for 4 steps, or the paths of sender and receiver meets each other
  WHILE Start.size() > 0 AND @@isSame == false LIMIT 4 DO
    Start = SELECT t FROM Start:s-((User_to_Device|User_to_Payment):e)-:t
            // do not traverse the vertexes that were visited
            WHERE t.@fromReceiver == false AND t.@fromSender == false
            ACCUM t.@fromReceiver += s.@fromReceiver,
                  t.@fromSender += s.@fromSender
                  ,@@edgeSet += e
            POST-ACCUM
              // when two paths meets in the middle
              CASE WHEN t.@fromReceiver == true AND t.@fromSender THEN
                @@isSame += true
              END
    ;
  END;

  // output the result
  PRINT @@isSame;
  PRINT @@edgeSet;
}

CREATE OR REPLACE QUERY InvitedUserBehavior (VERTEX<User> inputUser) FOR GRAPH AntiFraud {
/* 
 This query is motivated to detect those fraudulent users who conduct activities to earn 
 referral bonus. How do we do that? 

 Given an input user, this query traverses the graph, finds out how many two-hop users that
 are indirectly invited by the input user. That is, the users invited by the input user's
 invitees. It also calculates the transferred total money from the one-hop invitees. 
 Finally, the traversed subgraph is returned. Intuitively, if it's a fraudulent user, we
 can tell from the money transferred from their direct invitees; and their indirect invitees
 should be small or zero. 
 
Sample input
  inputUser: 5354357 | 30746939 | 23189347
*/
  //declare some variables to store aggregates.
  SumAccum<int> @@invitedPersonNum;
  SumAccum<float> @@totalAmountSent;
  SetAccum<edge> @@visRes;

  //assign the input user to the "start" variable, which is a SET.
  start = {inputUser};  

  //one-step traversal. From the start set, via the User_Refer_User edge,
  //find all the invitees of the input user; store them into the "users" variable. 
  //Put all touched edges into a variable for visualization purpose.
  users = SELECT t
          FROM start:s-(User_Refer_User:e)-:t
	  ACCUM @@visRes += e;

  //Aggregate the amounts of all transactions conducted by the one-hop invitees into
  //variable @@totalAmountSent. Also, store the traversed edges into variable  @@visRes.
  trans = SELECT t
          FROM users:s-((User_Transfer_Transaction):e)-:t
          ACCUM
            @@totalAmountSent += t.amount,
            @@visRes += e;

  //Second-hop traversal. Find users invited by the one-hop invitees.
  //store their count in @@invitedPersonNum. And record the traversed edges into @@visRes. 
  users = SELECT t
          FROM users:s-(User_Refer_User:e)-:t
          WHERE t != inputUser
          ACCUM @@visRes += e
	        POST-ACCUM @@invitedPersonNum += 1;
  //return 2-hop invitees count, total transferred money by 1-hop and 2-hop invitees,
  //and the subgraph.
  PRINT @@invitedPersonNum, @@totalAmountSent, @@visRes;
}

CREATE OR REPLACE QUERY RepeatedUser (vertex<User> receiver) for GRAPH AntiFraud {
/*
 Given a money receiver, this query is to discover whether there exists relationships among 
 those people who have sent money to this receiver. 
   
  1) Starting from a receiver, find all of her transactions receiving money.
  2) Find all the senders from the transactions collected in step 1)
  3) Start from the senders in step 2), go as far as 8 steps from each sender, 
     find all the senders that are connected to other senders by a path made of 
     Device_Token, Payment_Instrument, and Users.
  4) Output all the transactions started by the senders found in step 3) and received by the input user.

  Sample input
  receiver: Recommend to use 1223 as input. Or, try integer between 1 and 500.
*/
  
  SumAccum<int> @msgRcv;
  OrAccum<bool> @isS, @isRepeated;
  MaxAccum<vertex> @max;
  MinAccum<vertex> @min;
  SetAccum<vertex> @@linkedJoint;

  SetAccum<edge> @@edgeSet;
 
  Start (ANY) = {receiver};

  // get all transactions the receiver get money from.
  transactions = select t from Start:s-(User_Receive_Transaction:e)-:t
          ACCUM @@edgeSet += e
          post-accum t.@isS += true;

  // get all senders related to the above transactions.
  Start = select t from transactions:s-(User_Transfer_Transaction_Rev:e)-:t
          ACCUM @@edgeSet += e
          post-accum t.@msgRcv += 1,
                     t.@isS += true,
                     t.@max = t,
                     t.@min = t;

  // Traverse 8 step from the senders. min/max is used to find joint node
  WHILE (Start.size() > 0) limit 8 DO
    Start = select t from Start:s-((User_to_Device|User_to_Payment):e)-:t
            WHERE t.@msgRcv == 0
            ACCUM
              t.@msgRcv += 1,
              t.@min += s.@min,
              t.@max += s.@max
            POST-ACCUM
              // when received message from different source
              CASE WHEN t.@msgRcv > 1 AND t.@min != t.@max THEN
                @@linkedJoint += t
              END
    ;   
  END;

  Start = {@@linkedJoint};

  // trace back to the source senders from the vertexes that joint multiple paths
  WHILE (Start.size() > 0) DO
    Start = select t from Start:s-((User_to_Device|User_to_Payment):e)-:t
            WHERE t.@msgRcv != 0
            ACCUM @@edgeSet += e
            POST-ACCUM
              s.@msgRcv = 0,
              CASE WHEN t.@isS THEN
                t.@isRepeated += true
              END;
  END;
  // get the transactions to output
  transactions = select s from transactions:s-(User_Transfer_Transaction_Rev:e)-:t
          where t.@isRepeated == true
          accum @@edgeSet += e
  ;

  print transactions [transactions.amount];
  print @@edgeSet;
}
set exit_on_error = "true"

CREATE OR REPLACE QUERY fraudConnectivity (VERTEX<User> inputUser, FLOAT trustScore) FOR GRAPH AntiFraud syntax v1 {
/* 
  This query finds all connect users/payment cards/device that has low credit score.  

  Starting with a user X find all other users connected to  
  X through device token, payment instrument connected via transactions in 3 steps

  Sample input
  User: any integer between 1 and 500
  trustScore: any float number (e.g. 0.1)
  
  Note: In versions 3.5 and earlier, the SAMPLE clause was only supported in Syntax V1, 
  so this query uses Syntax V1. The default Syntax V2 may be used in future versions that support SAMPLE.
*/

  OrAccum<bool> @visited;
  SumAccum<int> @@result;
  SetAccum<edge> @@visResult;

  Start (_) = {inputUser};  

  // keep traverse for 3 steps
  WHILE Start.size()>0 limit 3 DO
    Start = SELECT t
         FROM Start:s-(:e)-:t
         // sample clause for better visualization result
         SAMPLE 15 EDGE WHEN s.outdegree() >= 20
         WHERE t.@visited == false AND t != inputUser 
         ACCUM	
           @@visResult += e
         POST-ACCUM
           CASE WHEN t.trust_score < trustScore THEN
             @@result += 1
           END,
           t.@visited += true
         
    ;
  END;

  print @@result;
  print @@visResult;
}
```

- 04_query.gsql 실행 → 쿼리 생성

![Untitled](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/Untitled%204.png)

- Install Query

```graphql
install query *
```

![Untitled](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/Untitled%205.png)

# 6. GraphStudio

- 데이터

![Untitled](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/Untitled%206.png)

- Installed Query

![Untitled](Anti-Fraud%20(AML)%2093b3ac3260a94cc1ad5f01b78620f7f1/Untitled%207.png)