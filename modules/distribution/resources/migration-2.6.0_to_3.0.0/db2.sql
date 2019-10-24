CREATE TABLE AM_SYSTEM_APPS (
       ID INTEGER NOT NULL,
       NAME VARCHAR(50) NOT NULL,
       CONSUMER_KEY VARCHAR(512) NOT NULL,
       CONSUMER_SECRET VARCHAR(512) NOT NULL,
       CREATED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       PRIMARY KEY (ID)
)
/
CREATE SEQUENCE AM_SYSTEM_APPS_SEQUENCE START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER AM_SYSTEM_APPS_TRIGGER NO CASCADE BEFORE INSERT ON AM_SYSTEM_APPS
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL
  BEGIN ATOMIC
    SET (NEW.ID)
    = (NEXTVAL FOR AM_SYSTEM_APPS_SEQUENCE);
  END
/

CREATE TABLE AM_API_CLIENT_CERTIFICATE (
  TENANT_ID INT NOT NULL,
  ALIAS VARCHAR(45) NOT NULL,
  API_ID INTEGER NOT NULL,
  CERTIFICATE BLOB NOT NULL,
  REMOVED SMALLINT NOT NULL DEFAULT 0,
  TIER_NAME VARCHAR (512),
  FOREIGN KEY (API_ID) REFERENCES AM_API (API_ID) ON DELETE CASCADE,
  PRIMARY KEY (ALIAS, TENANT_ID, REMOVED)
)
/

ALTER TABLE AM_POLICY_SUBSCRIPTION 
  ADD MONETIZATION_PLAN VARCHAR(25) DEFAULT NULL
  ADD FIXED_RATE VARCHAR(15) DEFAULT NULL
  ADD BILLING_CYCLE VARCHAR(15) DEFAULT NULL 
  ADD PRICE_PER_REQUEST VARCHAR(15) DEFAULT NULL 
  ADD CURRENCY VARCHAR(15) DEFAULT NULL
/
CREATE TABLE AM_MONETIZATION_USAGE_PUBLISHER (
	ID VARCHAR(100) NOT NULL,
	STATE VARCHAR(50) NOT NULL,
	STATUS VARCHAR(50) NOT NULL,
	STARTED_TIME VARCHAR(50) NOT NULL,
	PUBLISHED_TIME VARCHAR(50) NOT NULL,
	PRIMARY KEY(ID)
)/

ALTER TABLE AM_API_COMMENTS
    ALTER COLUMN COMMENT_ID
    SET DATA TYPE VARCHAR(255)
/

ALTER TABLE AM_API_RATINGS
    ALTER COLUMN RATING_ID
    SET DATA TYPE VARCHAR(255) NOT NULL
/

CREATE TABLE IF NOT EXISTS AM_NOTIFICATION_SUBSCRIBER (
    UUID VARCHAR(255) NOT NULL,
    CATEGORY VARCHAR(255) NOT NULL,
    NOTIFICATION_METHOD VARCHAR(255) NOT NULL,
    SUBSCRIBER_ADDRESS VARCHAR(255) NOT NULL,
    PRIMARY KEY(UUID, SUBSCRIBER_ADDRESS)
) /