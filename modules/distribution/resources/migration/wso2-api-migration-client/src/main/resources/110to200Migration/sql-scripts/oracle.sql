ALTER TABLE AM_API  ADD  API_TIER VARCHAR(256)
/

CREATE TABLE  AM_ALERT_TYPES (
            ALERT_TYPE_ID INTEGER,
            ALERT_TYPE_NAME VARCHAR(255) NOT NULL ,
	    STAKE_HOLDER VARCHAR(100) NOT NULL,
            PRIMARY KEY (ALERT_TYPE_ID))
/

CREATE SEQUENCE AM_ALERT_TYPES_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER AM_ALERT_TYPES_TRIG
            BEFORE INSERT
            ON AM_ALERT_TYPES
            REFERENCING NEW AS NEW
            FOR EACH ROW
               BEGIN
                   SELECT AM_ALERT_TYPES_SEQ.nextval INTO :NEW.ALERT_TYPE_ID FROM dual;
               END;
/


CREATE TABLE  AM_ALERT_TYPES_VALUES (
            ALERT_TYPE_ID INTEGER,
            USER_NAME VARCHAR(255) NOT NULL ,
	    STAKE_HOLDER VARCHAR(100) NOT NULL ,
            CONSTRAINT AM_ALERT_TYPES_VALUES_CONST UNIQUE (ALERT_TYPE_ID,USER_NAME,STAKE_HOLDER))
/

CREATE TABLE  AM_ALERT_EMAILLIST (
	    EMAIL_LIST_ID INTEGER,
            USER_NAME VARCHAR(255) NOT NULL ,
	    STAKE_HOLDER VARCHAR(100) NOT NULL ,
            CONSTRAINT AM_ALERT_EMAILLIST_CONST UNIQUE (EMAIL_LIST_ID,USER_NAME,STAKE_HOLDER),
             PRIMARY KEY (EMAIL_LIST_ID))
/

CREATE SEQUENCE AM_ALERT_EMAILLIST_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER AM_ALERT_EMAILLIST_TRIG
            BEFORE INSERT
            ON AM_ALERT_EMAILLIST
            REFERENCING NEW AS NEW
            FOR EACH ROW
               BEGIN
                   SELECT AM_ALERT_EMAILLIST_SEQ.nextval INTO :NEW.EMAIL_LIST_ID FROM dual;
               END;
/

CREATE TABLE  AM_ALERT_EMAILLIST_DETAILS (
            EMAIL_LIST_ID INTEGER,
	    EMAIL VARCHAR(255),	    
            CONSTRAINT AM_ALERT_EMAIL_LIST_DET_CONST UNIQUE (EMAIL_LIST_ID,EMAIL))
/

INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('abnormalResponseTime', 'publisher')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('abnormalBackendTime', 'publisher')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('abnormalRequestsPerMin', 'subscriber')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('RequestPatternChanged', 'subscriber')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('UnusualIPAccessAlert', 'subscriber')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalRefreshAlert', 'subscriber')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('FrequentTierHittingAlert', 'subscriber')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalTierUsage', 'publisher')
/
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('healthAvailabilityPerMin', 'publisher')
/

-- AM Throttling tables --

CREATE TABLE AM_POLICY_SUBSCRIPTION (
            POLICY_ID INTEGER NOT NULL,
            NAME VARCHAR2(512) NOT NULL,
            DISPLAY_NAME VARCHAR2(512) DEFAULT NULL NULL,
            TENANT_ID INTEGER NOT NULL,
            DESCRIPTION VARCHAR2(1024) DEFAULT NULL NULL,
            QUOTA_TYPE VARCHAR2(25) NOT NULL,
            QUOTA INTEGER NOT NULL,
            QUOTA_UNIT VARCHAR2(10) NULL,
            UNIT_TIME INTEGER NOT NULL,
            TIME_UNIT VARCHAR2(25) NOT NULL,
            RATE_LIMIT_COUNT INTEGER DEFAULT NULL NULL,
            RATE_LIMIT_TIME_UNIT VARCHAR2(25) DEFAULT NULL NULL,
            IS_DEPLOYED INTEGER DEFAULT 0 NOT NULL,
	    CUSTOM_ATTRIBUTES BLOB DEFAULT NULL,
	    STOP_ON_QUOTA_REACH INTEGER DEFAULT 0 NOT NULL,
	    BILLING_PLAN VARCHAR2(20),
	          UUID VARCHAR2(256),
            PRIMARY KEY (POLICY_ID),
            CONSTRAINT SUBSCRIPTION_NAME_TENANT UNIQUE (NAME, TENANT_ID),
            UNIQUE (UUID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_POLICY_SUBSCRIPTION_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_POLICY_SUBSCRIPTION_seq_tr
 BEFORE INSERT ON AM_POLICY_SUBSCRIPTION FOR EACH ROW
 WHEN (NEW.POLICY_ID IS NULL)
BEGIN
 SELECT AM_POLICY_SUBSCRIPTION_seq.NEXTVAL INTO :NEW.POLICY_ID FROM DUAL;
END;
/

CREATE TABLE AM_POLICY_APPLICATION (
            POLICY_ID INTEGER NOT NULL,
            NAME VARCHAR2(512) NOT NULL,
            DISPLAY_NAME VARCHAR2(512) DEFAULT NULL NULL,
            TENANT_ID INTEGER NOT NULL,
            DESCRIPTION VARCHAR2(1024) DEFAULT NULL NULL,
            QUOTA_TYPE VARCHAR2(25) NOT NULL,
            QUOTA INTEGER NOT NULL,
            QUOTA_UNIT VARCHAR2(10) DEFAULT NULL NULL,
            UNIT_TIME INTEGER NOT NULL,
            TIME_UNIT VARCHAR2(25) NOT NULL,
            IS_DEPLOYED INTEGER DEFAULT 0 NOT NULL,
			CUSTOM_ATTRIBUTES BLOB DEFAULT NULL,
			      UUID VARCHAR2(256),
            PRIMARY KEY (POLICY_ID),
            CONSTRAINT AM_POLICY_APP_NAME_TENANT UNIQUE (NAME, TENANT_ID),
            UNIQUE (UUID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_POLICY_APPLICATION_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_POLICY_APPLICATION_seq_tr
 BEFORE INSERT ON AM_POLICY_APPLICATION FOR EACH ROW
 WHEN (NEW.POLICY_ID IS NULL)
BEGIN
 SELECT AM_POLICY_APPLICATION_seq.NEXTVAL INTO :NEW.POLICY_ID FROM DUAL;
END;
/

CREATE TABLE AM_API_THROTTLE_POLICY (
            POLICY_ID INTEGER NOT NULL,
            NAME VARCHAR2(512) NOT NULL,
            DISPLAY_NAME VARCHAR2(512) DEFAULT NULL NULL,
            TENANT_ID INTEGER NOT NULL,
            DESCRIPTION VARCHAR2 (1024),
            DEFAULT_QUOTA_TYPE VARCHAR2(25) NOT NULL,
            DEFAULT_QUOTA INTEGER NOT NULL,
            DEFAULT_QUOTA_UNIT VARCHAR2(10) NULL,
            DEFAULT_UNIT_TIME INTEGER NOT NULL,
            DEFAULT_TIME_UNIT VARCHAR2(25) NOT NULL,
            APPLICABLE_LEVEL VARCHAR2(25) NOT NULL,
            IS_DEPLOYED INTEGER DEFAULT 0 NOT NULL,
            UUID VARCHAR2(256),
            PRIMARY KEY (POLICY_ID),
            CONSTRAINT API_POLICY_NAME_TENANT UNIQUE (NAME, TENANT_ID),
            UNIQUE (UUID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_API_THROTTLE_POLICY_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_API_THROTTLE_POLICY_seq_tr
 BEFORE INSERT ON AM_API_THROTTLE_POLICY FOR EACH ROW
 WHEN (NEW.POLICY_ID IS NULL)
BEGIN
 SELECT AM_API_THROTTLE_POLICY_seq.NEXTVAL INTO :NEW.POLICY_ID FROM DUAL;
END;
/

CREATE TABLE AM_CONDITION_GROUP (
            CONDITION_GROUP_ID INTEGER NOT NULL,
            POLICY_ID INTEGER NOT NULL,
            QUOTA_TYPE VARCHAR2(25),
            QUOTA INTEGER NOT NULL,
            QUOTA_UNIT VARCHAR2(10) DEFAULT NULL NULL,
            UNIT_TIME INTEGER NOT NULL,
            TIME_UNIT VARCHAR2(25) NOT NULL,
            DESCRIPTION VARCHAR2(1024) DEFAULT NULL NULL,
            PRIMARY KEY (CONDITION_GROUP_ID),
            FOREIGN KEY (POLICY_ID) REFERENCES AM_API_THROTTLE_POLICY(POLICY_ID) ON DELETE CASCADE
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_CONDITION_GROUP_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_CONDITION_GROUP_seq_tr
 BEFORE INSERT ON AM_CONDITION_GROUP FOR EACH ROW
 WHEN (NEW.CONDITION_GROUP_ID IS NULL)
BEGIN
 SELECT AM_CONDITION_GROUP_seq.NEXTVAL INTO :NEW.CONDITION_GROUP_ID FROM DUAL;
END;
/

CREATE TABLE AM_QUERY_PARAMETER_CONDITION (
            QUERY_PARAMETER_ID INTEGER NOT NULL,
            CONDITION_GROUP_ID INTEGER NOT NULL,
            PARAMETER_NAME VARCHAR2(255) DEFAULT NULL,
            PARAMETER_VALUE VARCHAR2(255) DEFAULT NULL,
	    	IS_PARAM_MAPPING CHAR(1) DEFAULT 1,
            PRIMARY KEY (QUERY_PARAMETER_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE QUERY_PARAMETER_CONDITION_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER QUERY_PARAMETER_CONDITION_tr
 BEFORE INSERT ON AM_QUERY_PARAMETER_CONDITION FOR EACH ROW
 WHEN (NEW.QUERY_PARAMETER_ID IS NULL)
BEGIN
 SELECT AM_QUERY_PARAMETER_CONDITION_seq.NEXTVAL INTO :NEW.QUERY_PARAMETER_ID FROM DUAL;
END;
/

CREATE TABLE AM_HEADER_FIELD_CONDITION (
            HEADER_FIELD_ID INTEGER NOT NULL,
            CONDITION_GROUP_ID INTEGER NOT NULL,
            HEADER_FIELD_NAME VARCHAR2(255) DEFAULT NULL,
            HEADER_FIELD_VALUE VARCHAR2(255) DEFAULT NULL,
	    	IS_HEADER_FIELD_MAPPING CHAR(1) DEFAULT 1,
            PRIMARY KEY (HEADER_FIELD_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_HEADER_FIELD_CONDITION_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_HEADER_FIELD_CONDITION_tr
 BEFORE INSERT ON AM_HEADER_FIELD_CONDITION FOR EACH ROW
 WHEN (NEW.HEADER_FIELD_ID IS NULL)
BEGIN
 SELECT AM_HEADER_FIELD_CONDITION_seq.NEXTVAL INTO :NEW.HEADER_FIELD_ID FROM DUAL;
END;
/

CREATE TABLE AM_JWT_CLAIM_CONDITION (
            JWT_CLAIM_ID INTEGER NOT NULL,
            CONDITION_GROUP_ID INTEGER NOT NULL,
            CLAIM_URI VARCHAR2(512) DEFAULT NULL,
            CLAIM_ATTRIB VARCHAR2(1024) DEFAULT NULL,
	    IS_CLAIM_MAPPING CHAR(1) DEFAULT 1,
            PRIMARY KEY (JWT_CLAIM_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_JWT_CLAIM_CONDITION_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_JWT_CLAIM_CONDITION_seq_tr
 BEFORE INSERT ON AM_JWT_CLAIM_CONDITION FOR EACH ROW
 WHEN (NEW.JWT_CLAIM_ID IS NULL)
BEGIN
 SELECT AM_JWT_CLAIM_CONDITION_seq.NEXTVAL INTO :NEW.JWT_CLAIM_ID FROM DUAL;
END;
/

CREATE TABLE AM_IP_CONDITION (
  AM_IP_CONDITION_ID INTEGER NOT NULL,
  STARTING_IP VARCHAR2(45) NULL,
  ENDING_IP VARCHAR2(45) NULL,
  SPECIFIC_IP VARCHAR2(45) NULL,
  WITHIN_IP_RANGE CHAR(1) DEFAULT 1,
  CONDITION_GROUP_ID INTEGER NULL,
  PRIMARY KEY (AM_IP_CONDITION_ID)
 ,  CONSTRAINT fk_AM_IP_CONDITION_1    FOREIGN KEY (CONDITION_GROUP_ID)
    REFERENCES AM_CONDITION_GROUP (CONDITION_GROUP_ID)   ON DELETE CASCADE )

/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_IP_CONDITION_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_IP_CONDITION_seq_tr
 BEFORE INSERT ON AM_IP_CONDITION FOR EACH ROW
 WHEN (NEW.AM_IP_CONDITION_ID IS NULL)
BEGIN
 SELECT AM_IP_CONDITION_seq.NEXTVAL INTO :NEW.AM_IP_CONDITION_ID FROM DUAL;
END;
/

CREATE INDEX fk_AM_IP_CONDITION_1_idx ON AM_IP_CONDITION (CONDITION_GROUP_ID ASC)
/

CREATE TABLE AM_POLICY_GLOBAL (
            POLICY_ID INTEGER NOT NULL,
            NAME VARCHAR2(512) NOT NULL,
            KEY_TEMPLATE VARCHAR2(512) NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            DESCRIPTION VARCHAR2(1024) DEFAULT NULL NULL,
            SIDDHI_QUERY BLOB DEFAULT NULL,
            IS_DEPLOYED INTEGER DEFAULT 0 NOT NULL,
            UUID VARCHAR2(256),
            PRIMARY KEY (POLICY_ID),
            UNIQUE (UUID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_POLICY_GLOBAL_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_POLICY_GLOBAL_seq_tr
 BEFORE INSERT ON AM_POLICY_GLOBAL FOR EACH ROW
 WHEN (NEW.POLICY_ID IS NULL)
BEGIN
 SELECT AM_POLICY_GLOBAL_seq.NEXTVAL INTO :NEW.POLICY_ID FROM DUAL;
END;
/

CREATE TABLE AM_THROTTLE_TIER_PERMISSIONS (
  THROTTLE_TIER_PERMISSIONS_ID INTEGER NOT NULL,
  TIER VARCHAR2(50) NULL,
  PERMISSIONS_TYPE VARCHAR2(50) NULL,
  ROLES VARCHAR2(512) NULL,
  TENANT_ID INTEGER NULL,
  PRIMARY KEY (THROTTLE_TIER_PERMISSIONS_ID))
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE THROTTLE_TIER_PERMISSIONS_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER THROTTLE_TIER_PERMISSIONS_tr
 BEFORE INSERT ON AM_THROTTLE_TIER_PERMISSIONS FOR EACH ROW
 WHEN (NEW.THROTTLE_TIER_PERMISSIONS_ID IS NULL)
BEGIN
 SELECT THROTTLE_TIER_PERMISSIONS_seq.NEXTVAL INTO :NEW.THROTTLE_TIER_PERMISSIONS_ID FROM DUAL;
END;
/

CREATE TABLE AM_BLOCK_CONDITIONS (
  CONDITION_ID INTEGER NOT NULL,
  TYPE varchar2(45) DEFAULT NULL,
  VALUE varchar2(45) DEFAULT NULL,
  ENABLED varchar2(45) DEFAULT NULL,
  DOMAIN varchar2(45) DEFAULT NULL,
  UUID VARCHAR2(256),
  PRIMARY KEY (CONDITION_ID),
  UNIQUE (UUID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE AM_BLOCK_CONDITIONS_seq START WITH 1 INCREMENT BY 1
/
CREATE OR REPLACE TRIGGER AM_BLOCK_CONDITIONS_seq_tr
 BEFORE INSERT ON AM_BLOCK_CONDITIONS FOR EACH ROW
 WHEN (NEW.CONDITION_ID IS NULL)
BEGIN
 SELECT AM_BLOCK_CONDITIONS_seq.NEXTVAL INTO :NEW.CONDITION_ID FROM DUAL;
END;
/

-- End of API-MGT Tables --

--performance indexes start--
create index IDX_ITS_LMT on IDN_THRIFT_SESSION (LAST_MODIFIED_TIME)
/
create index IDX_IOAT_AT on IDN_OAUTH2_ACCESS_TOKEN (ACCESS_TOKEN)
/
create index IDX_IOAT_UT on IDN_OAUTH2_ACCESS_TOKEN (USER_TYPE)
/
create index IDX_AAI_CTX on AM_API (CONTEXT)
/
create index IDX_AAKM_CK on AM_APPLICATION_KEY_MAPPING (CONSUMER_KEY)
/
create index IDX_AAUM_AI on AM_API_URL_MAPPING (API_ID)
/
create index IDX_AAUM_TT on AM_API_URL_MAPPING (THROTTLING_TIER)
/
create index IDX_AATP_DQT on AM_API_THROTTLE_POLICY (DEFAULT_QUOTA_TYPE)
/
create index IDX_ACG_QT on AM_CONDITION_GROUP (QUOTA_TYPE)
/
create index IDX_APS_QT on AM_POLICY_SUBSCRIPTION (QUOTA_TYPE)
/
create index IDX_AS_AITIAI on AM_SUBSCRIPTION (API_ID,TIER_ID,APPLICATION_ID)
/
create index IDX_APA_QT on AM_POLICY_APPLICATION (QUOTA_TYPE)
/
create index IDX_AA_AT_CB on AM_APPLICATION (APPLICATION_TIER,CREATED_BY)
/
-- Performance indexes end--