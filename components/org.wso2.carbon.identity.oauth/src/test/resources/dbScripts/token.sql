CREATE TABLE IF NOT EXISTS IDN_OAUTH_CONSUMER_APPS (
            ID INTEGER NOT NULL AUTO_INCREMENT,
            CONSUMER_KEY VARCHAR (255),
            CONSUMER_SECRET VARCHAR (512),
            USERNAME VARCHAR (255),
            TENANT_ID INTEGER DEFAULT 0,
            USER_DOMAIN VARCHAR(50),
            APP_NAME VARCHAR (255),
            OAUTH_VERSION VARCHAR (128),
            CALLBACK_URL VARCHAR (1024),
            GRANT_TYPES VARCHAR (1024),
            PKCE_MANDATORY CHAR(1) DEFAULT '0',
            PKCE_SUPPORT_PLAIN CHAR(1) DEFAULT '0',
            APP_STATE VARCHAR (25) DEFAULT 'ACTIVE',
            USER_ACCESS_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600000,
            APP_ACCESS_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600000,
            REFRESH_TOKEN_EXPIRE_TIME BIGINT DEFAULT 84600000,
            ID_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600000,
            BACKCHANNELLOGOUT_URL VARCHAR (1024),
            CONSTRAINT CONSUMER_KEY_CONSTRAINT UNIQUE (CONSUMER_KEY, TENANT_ID),
            PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_SCOPE_VALIDATORS (
	APP_ID INTEGER NOT NULL,
	SCOPE_VALIDATOR VARCHAR (128) NOT NULL,
	PRIMARY KEY (APP_ID,SCOPE_VALIDATOR),
	FOREIGN KEY (APP_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_ACCESS_TOKEN (
            TOKEN_ID VARCHAR (255),
            ACCESS_TOKEN VARCHAR (255),
            REFRESH_TOKEN VARCHAR (255),
            CONSUMER_KEY_ID INTEGER,
            AUTHZ_USER VARCHAR (100),
            TENANT_ID INTEGER,
            USER_DOMAIN VARCHAR(50),
            USER_TYPE VARCHAR (25),
            GRANT_TYPE VARCHAR (50),
            TIME_CREATED TIMESTAMP DEFAULT 0,
            REFRESH_TOKEN_TIME_CREATED TIMESTAMP DEFAULT 0,
            VALIDITY_PERIOD BIGINT,
            REFRESH_TOKEN_VALIDITY_PERIOD BIGINT,
            TOKEN_SCOPE_HASH VARCHAR (32),
            TOKEN_STATE VARCHAR (25) DEFAULT 'ACTIVE',
            TOKEN_STATE_ID VARCHAR (128) DEFAULT 'NONE',
            SUBJECT_IDENTIFIER VARCHAR(255),
            ACCESS_TOKEN_HASH VARCHAR (255),
            REFRESH_TOKEN_HASH VARCHAR (255),
            IDP_ID INTEGER,
            TOKEN_BINDING_REF VARCHAR (32) DEFAULT 'NONE',
            PRIMARY KEY (TOKEN_ID),
            CONSTRAINT CON_APP_KEY UNIQUE (CONSUMER_KEY_ID,AUTHZ_USER,TENANT_ID,USER_DOMAIN,USER_TYPE,TOKEN_SCOPE_HASH,
                                           TOKEN_STATE,TOKEN_STATE_ID,IDP_ID,TOKEN_BINDING_REF)
);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_TOKEN_BINDING (
            TOKEN_ID VARCHAR (255),
            TOKEN_BINDING_TYPE VARCHAR (32),
            TOKEN_BINDING_REF VARCHAR (32),
            TOKEN_BINDING_VALUE VARCHAR (1024),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (TOKEN_ID),
            FOREIGN KEY (TOKEN_ID) REFERENCES IDN_OAUTH2_ACCESS_TOKEN(TOKEN_ID) ON DELETE CASCADE
);

CREATE INDEX IDX_AT_CK_AU ON IDN_OAUTH2_ACCESS_TOKEN(CONSUMER_KEY_ID, AUTHZ_USER, TOKEN_STATE, USER_TYPE);

CREATE INDEX IDX_TC ON IDN_OAUTH2_ACCESS_TOKEN(TIME_CREATED);

CREATE INDEX IDX_AT ON IDN_OAUTH2_ACCESS_TOKEN(ACCESS_TOKEN);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_AUTHORIZATION_CODE (
            CODE_ID VARCHAR (255),
            AUTHORIZATION_CODE VARCHAR (512),
            CONSUMER_KEY_ID INTEGER,
            CALLBACK_URL VARCHAR (1024),
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR (100),
            TENANT_ID INTEGER,
            USER_DOMAIN VARCHAR(50),
            TIME_CREATED TIMESTAMP,
            VALIDITY_PERIOD BIGINT,
            STATE VARCHAR (25) DEFAULT 'ACTIVE',
            TOKEN_ID VARCHAR(255),
            SUBJECT_IDENTIFIER VARCHAR(255),
            PKCE_CODE_CHALLENGE VARCHAR (255),
            PKCE_CODE_CHALLENGE_METHOD VARCHAR(128),
            AUTHORIZATION_CODE_HASH VARCHAR (512),
            IDP_ID INTEGER,
            PRIMARY KEY (CODE_ID),
            FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
);

CREATE INDEX IDX_AUTHORIZATION_CODE ON IDN_OAUTH2_AUTHORIZATION_CODE (AUTHORIZATION_CODE,CONSUMER_KEY_ID);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_AUTHZ_CODE_SCOPE(
           CODE_ID   VARCHAR(255),
           SCOPE     VARCHAR(60),
           TENANT_ID INTEGER DEFAULT -1,
           PRIMARY KEY (CODE_ID, SCOPE)
);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_ACCESS_TOKEN_SCOPE (
            TOKEN_ID VARCHAR (255),
            TOKEN_SCOPE VARCHAR (60),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (TOKEN_ID, TOKEN_SCOPE)
);

CREATE TABLE IF NOT EXISTS  IDN_OIDC_PROPERTY (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  TENANT_ID  INTEGER,
  CONSUMER_KEY  VARCHAR(255) ,
  PROPERTY_KEY  VARCHAR(255) NOT NULL,
  PROPERTY_VALUE  VARCHAR(2047) ,
  PRIMARY KEY (ID),
  FOREIGN KEY (CONSUMER_KEY, TENANT_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY, TENANT_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS IDP (
			ID INTEGER AUTO_INCREMENT,
			TENANT_ID INTEGER,
			NAME VARCHAR(254) NOT NULL,
			IS_ENABLED CHAR(1) NOT NULL DEFAULT '1',
			IS_PRIMARY CHAR(1) NOT NULL DEFAULT '0',
			HOME_REALM_ID VARCHAR(254),
			IMAGE MEDIUMBLOB,
			CERTIFICATE BLOB,
			ALIAS VARCHAR(254),
			INBOUND_PROV_ENABLED CHAR (1) NOT NULL DEFAULT '0',
			INBOUND_PROV_USER_STORE_ID VARCHAR(254),
 			USER_CLAIM_URI VARCHAR(254),
 			ROLE_CLAIM_URI VARCHAR(254),
 			DESCRIPTION VARCHAR (1024),
 			DEFAULT_AUTHENTICATOR_NAME VARCHAR(254),
 			DEFAULT_PRO_CONNECTOR_NAME VARCHAR(254),
 			PROVISIONING_ROLE VARCHAR(128),
 			IS_FEDERATION_HUB CHAR(1) NOT NULL DEFAULT '0',
 			IS_LOCAL_CLAIM_DIALECT CHAR(1) NOT NULL DEFAULT '0',
 			DISPLAY_NAME VARCHAR(255),
			IMAGE_URL VARCHAR(255),
            		UUID VARCHAR(255) NOT NULL,
            		PRIMARY KEY (ID),
            		UNIQUE (TENANT_ID, NAME),
            		UNIQUE (UUID));

INSERT INTO IDP (TENANT_ID, NAME, UUID) VALUES (1234, 'LOCAL', 5678);
