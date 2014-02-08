CREATE TABLE "ap_log" (
  "ap_log_id" serial NOT NULL,
  "ap_code" character varying(50) NOT NULL,
  "date_access" timestamp NOT NULL,
  "role" character varying(50) NOT NULL,
  "mac_hash" character varying(50) NOT NULL,
  "type" character varying(50) NOT NULL
); -- 0.008 s

ALTER TABLE "ap_log"
ADD CONSTRAINT "ap_log_ap_log_id" PRIMARY KEY ("ap_log_id"),
ADD CONSTRAINT "ap_log_ap_code_date_access_role_mac_hash_type" UNIQUE ("ap_code", "date_access", "role", "mac_hash", "type"); -- 0.052 s