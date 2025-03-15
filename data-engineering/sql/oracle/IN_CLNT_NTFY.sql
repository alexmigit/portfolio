ALTER TABLE REG34.IN_CLNT_NTFY
 DROP PRIMARY KEY CASCADE;

DROP TABLE REG34.IN_CLNT_NTFY CASCADE CONSTRAINTS;

CREATE TABLE REG34.IN_CLNT_NTFY
(
  CLNT_NTFY_ID         NUMBER(10)               NOT NULL,
  CS_ID                CHAR(7 BYTE),
  NTFY_TYP_CD          CHAR(2 BYTE)             NOT NULL,
  CLNT_NTFY_STS_CD     CHAR(2 BYTE)             NOT NULL,
  SEND_DT              DATE                     NOT NULL,
  TEL_NUM              VARCHAR2(10 BYTE),
  LANG_CD              CHAR(2 BYTE),
  MSG_CD               CHAR(3 BYTE)             NOT NULL,
  EMAIL_ADR            VARCHAR2(75 BYTE),
  FIRST_NM             VARCHAR2(25 BYTE),
  LAST_NM              VARCHAR2(25 BYTE),
  CRT_USR_ID           VARCHAR2(15 BYTE)        NOT NULL,
  CRT_DTM              DATE                     NOT NULL,
  UPD_USR_ID           VARCHAR2(15 BYTE)        NOT NULL,
  UPD_DTM              DATE                     NOT NULL,
  MSG_PARM             VARCHAR2(500 BYTE),
  NTFY_CMT             VARCHAR2(75 BYTE),
  PRRTY                NUMBER(1),
  SEND_AFT_DTM         DATE,
  DO_NOT_SEND_AFT_DTM  DATE,
  BYPASS_CNSNT_CD      CHAR(1 BYTE),
  MBL_VRF_CD           CHAR(1 BYTE)
)
TABLESPACE DATA01
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;

COMMENT ON TABLE REG34.IN_CLNT_NTFY IS 'The purpose of this table is to store client notifications that need to be sent or have been sent in the form of Email, Text, or Phone Calls. The table also stores client notifications that were excluded from the outbound notification process.
';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.CLNT_NTFY_ID IS 'This column is a system generated number to represent a unique request for a client notification record.
';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.CS_ID IS 'This column identifies the case id.
';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.NTFY_TYP_CD IS 'This column identifies the form in which the notification is to be sent out, phone, text, email, etc.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.CLNT_NTFY_STS_CD IS 'This column identifies the status of the client notification record.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.SEND_DT IS 'This column identifies the date the notification is to be sent.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.TEL_NUM IS 'This column identifies the phone number of the notification.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.LANG_CD IS 'This column identifies the language the notification that is to be sent.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.MSG_CD IS 'This column identifies the actual notification that is to be sent.
';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.EMAIL_ADR IS 'This column identifies the email address of the notification
';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.FIRST_NM IS 'This column identifies the first name of the person that the notification is sent to.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.LAST_NM IS 'This column identifies the last name of the person that the notification is sent to.
';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.CRT_USR_ID IS 'The identification for the authorized CalWIN user who created an instance of the entity.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.CRT_DTM IS 'The date and time this instance of this entity was created.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.UPD_USR_ID IS 'The identification for the authorized CalWIN user who updated an instance of the entity.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.UPD_DTM IS 'The date and time this instance of this entity was updated.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.MSG_PARM IS 'Parameters used to customize the text of a Standard Notification.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.NTFY_CMT IS 'Additional county-determined text for the case comment to be inserted for Standard Notifications.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.PRRTY IS 'This column identifies the priority that the notification is to be processed in.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.SEND_AFT_DTM IS 'This column is being added for the Future Send Capability.  If there is a DATE in this field, the message will not be sent until the send after date time is reached.  If NULL, then send the message immediately.';

COMMENT ON COLUMN REG34.IN_CLNT_NTFY.DO_NOT_SEND_AFT_DTM IS 'This column is being added for the Future Send Capability.  If there is a DATE in this field, then the message will not be sent if the current date time is greater or after the specified date time in this field.  This is intended primarily for Outbound Calls. If NULL, then the message should be sent no matter how late it is.';



CREATE INDEX REG34.XIE1_IN_CLNT_NTFY ON REG34.IN_CLNT_NTFY
(NTFY_TYP_CD)
LOGGING
TABLESPACE DATA01
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT );


CREATE INDEX REG34.XIF1_IN_CLNT_NTFY ON REG34.IN_CLNT_NTFY
(CS_ID)
LOGGING
TABLESPACE DATA01
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT );


CREATE UNIQUE INDEX REG34.XPK_IN_CLNT_NTFY ON REG34.IN_CLNT_NTFY
(CLNT_NTFY_ID)
LOGGING
TABLESPACE DATA01
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT );


DROP SYNONYM REGD34.IN_CLNT_NTFY;

CREATE OR REPLACE SYNONYM REGD34.IN_CLNT_NTFY FOR REG34.IN_CLNT_NTFY;


DROP SYNONYM REGU34.IN_CLNT_NTFY;

CREATE OR REPLACE SYNONYM REGU34.IN_CLNT_NTFY FOR REG34.IN_CLNT_NTFY;


DROP SYNONYM REGR34.IN_CLNT_NTFY;

CREATE OR REPLACE SYNONYM REGR34.IN_CLNT_NTFY FOR REG34.IN_CLNT_NTFY;


DROP SYNONYM SIMU34.IN_CLNT_NTFY;

CREATE OR REPLACE SYNONYM SIMU34.IN_CLNT_NTFY FOR REG34.IN_CLNT_NTFY;


ALTER TABLE REG34.IN_CLNT_NTFY ADD (
  CONSTRAINT XPK_IN_CLNT_NTFY
  PRIMARY KEY
  (CLNT_NTFY_ID)
  USING INDEX REG34.XPK_IN_CLNT_NTFY
  ENABLE VALIDATE);

ALTER TABLE REG34.IN_CLNT_NTFY ADD (
  CONSTRAINT FK_IN_CLNT_NTFY_1 
  FOREIGN KEY (CS_ID) 
  REFERENCES REG34.CS_K (CS_ID)
  DEFERRABLE INITIALLY IMMEDIATE
  ENABLE VALIDATE);

GRANT SELECT ON REG34.IN_CLNT_NTFY TO CW_REGR34_ROLE;

GRANT DELETE, INSERT, SELECT, UPDATE ON REG34.IN_CLNT_NTFY TO CW_REGU34_ROLE;

GRANT SELECT ON REG34.IN_CLNT_NTFY TO CW_SIMU34_ROLE;

GRANT REFERENCES ON REG34.IN_CLNT_NTFY TO SIM34;
