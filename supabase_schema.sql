-- ============ SCHEMA ============

CREATE TABLE drivers (
  id SERIAL PRIMARY KEY,
  name TEXT,
  plate TEXT,
  "rateNote" TEXT,
  vehicle TEXT,
  phone TEXT,
  "driverId" BIGINT
);

CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  "hostName" TEXT,
  uid TEXT,
  "costCentre" TEXT,
  company TEXT,
  code TEXT
);

CREATE TABLE job_types (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE rates (
  id SERIAL PRIMARY KEY,
  "jobType" TEXT,
  "unitPrice" TEXT,
  "billingUnit" TEXT
);

CREATE TABLE jobs (
  id SERIAL PRIMARY KEY,
  date DATE,
  invoice TEXT,
  driver TEXT,
  "jobType" TEXT,
  details TEXT,
  "startTime" TEXT,
  "endTime" TEXT,
  duration TEXT,
  qty INTEGER,
  "unitCost" NUMERIC,
  cost NUMERIC,
  "driverPayout" NUMERIC,
  "coyFund" NUMERIC,
  remarks TEXT,
  "paymentStatus" TEXT,
  "hostName" TEXT,
  company TEXT,
  uid TEXT,
  "costCentre" TEXT,
  vehicle TEXT
);

-- RLS policies (allow public access via anon key)
ALTER TABLE drivers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "drivers_public" ON drivers FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
CREATE POLICY "clients_public" ON clients FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE job_types ENABLE ROW LEVEL SECURITY;
CREATE POLICY "job_types_public" ON job_types FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE rates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "rates_public" ON rates FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jobs_public" ON jobs FOR ALL USING (true) WITH CHECK (true);

-- ============ SEED DATA ============

-- Drivers
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ALAN YONG', 'SCM79U', '0.9', 'TOYOTA ALPHARD HS WHITE', '91140140', 1220879697);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('SEAN SEAH', 'SNK7862J', '0.9', 'TOYOTA ALPHARD HS BLACK', '91266281', 1221115470);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ELVIN SAI', 'SPC2260Y', '0.9', 'TOYOTA ALPHARD AH40 BLACK', NULL, 1221098428);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ALAN TOH', 'SNK2131T', '0.9', 'TOYOTA ALPHARD HS BLACK', '96982627', 1221208150);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('SEAH BOON HENG', 'SNW3810Z', '0.9', 'TOYOTA NOAH BLACK', '91392594', 1224729442);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('KENNY LAW', 'SLP7571C', '120, 40/HR', 'TOYOTA PRIUS SILVER', '96867568', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ALEX TAY', 'SKX3712C', '45/HR', 'TOYOTA VOXY WHITE', '88076863', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('JONATHAN TAN', 'SNS9508C', NULL, 'TOYOTA NOAH BLACK', NULL, NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('PERION LIM', 'SNN2004L', NULL, 'TOYOTA VOXY WHITE', '92293992', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('JJ', 'PD7767P', NULL, 'TOYOTA HIACE (COMBI)', '97942250', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('SKY ONG', 'SNK1445U', NULL, 'TOYOTA ALPHARD HS BLACK', '87722278', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ROY', 'PD9959P', NULL, 'TOYOTA HIACE (COMBI)', '88088896', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ERON CHUA', 'SNR1856E', NULL, 'TOYOTA VOXY WHITE', '83182381', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ALAN', 'PC2632H', NULL, 'TOYOTA COASTER 23 SEATER', '98400324', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('LOW', 'PC9884B', NULL, 'TOYOTA COASTER 23 SEATER', '88855259', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('GOH', 'PA9649A', NULL, 'TOYOTA COASTER 23 SEATER', '97299313', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('CHRIS ', 'PC7821X', NULL, 'TOYOTA COASTER 23 SEATER', '81327979', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ZULKEFLEE', 'SNK9249S', NULL, 'NISSAN SERENA BLACK', '88172876', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('RIGGS', 'PD7757P', NULL, 'TOYOTA HIACE (COMBI)', '86686046', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ISHAM', 'SNF5492H', NULL, 'TOYOTA NOAH BLACK', '87851413', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('CHAY YU SIANG', 'SNF1866P', NULL, 'BYD E6', '91709595', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ABDUL HAKAM', 'SMH5383R', NULL, 'HONDA FREED (SILVER)', '90859002', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('REDZUAN', 'SMP1699P', NULL, 'NOAH WHITE HYBRID', '90897188', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('MOHAMMAAD ALI', 'SNS4872H', NULL, 'TOYOTA NOAH BLACK', '94608545', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('EDDIE NG', 'PC6041L', NULL, 'TOYOTA HIACE (COMBI)', '98445593', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('JASON YEO', 'SMX9099X', NULL, 'TOYOTA ALPHARD BLACK AH40', '97211798', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('SOH KAH LEONG', 'PD2130J', NULL, 'TOYOTA HIACE (COMBI)', '90069379', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ZAI', 'PD9789M', NULL, 'TOYOTA HIACE (COMBI)', '87553774', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ALEX', 'PC7649L', NULL, 'TOYOTA COASTER 23 SEATER', '85884494', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('PJ', 'PD2316R', NULL, 'TOYOTA HIACE (COMBI)', '98844834', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('FRAN WILLIAM', 'SNN6535U', NULL, 'TOYOTA ALPHARD HS BLACK', '82229965', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ZEKE LEE ', 'SNV6939X', NULL, 'TOYOTA ALPHARD BLACK AH40', '84845582', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('FRANCIS FOO', 'SNL5308B', NULL, 'TOYOTA ALPHARD HS BLACK', NULL, NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ANDIE', 'PC2087G', NULL, 'TOYOTA HIACE (COMBI)', '91384399', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('MAX NG', 'SNM8990E', NULL, 'TOYOTA ALPHARD HS WHITE', '97608990', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('SHERRY', 'PA9231X', NULL, 'TOYOTA COASTER 23 SEATER', '87139944', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('XIAO XIONG', 'PD4688D', NULL, '45 SEATER', '88224885', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('CRIST WONG', 'SJN5885M', NULL, 'TOYOTA ALPHARD BLACK AH40', '82583868', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ANDREW', 'PC5186J', NULL, 'TOYOTA HIACE (COMBI)', '94690153', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('JAMESON NG', 'SNK3698T', NULL, 'TOYOTA ALPHARD HS BLACK', '92716511', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('AZMAN SANIYA', 'SNL2064Z', NULL, 'TOYOTA NOAH BLACK', '87791513', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('CHUA WEE ZHONG', 'SJH2812A', NULL, 'TOYOTA CAMRY', '98500019', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('MUHAMMAD RASUL', 'PD1166M', NULL, 'TOYOTA HIACE (COMBI)', '87523448', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('JOEVINES OH', 'SNK4045X', NULL, 'TOYOTA ALPHARD HS BLACK', NULL, NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('BEN', 'PD1536D', NULL, 'TOYOTA HIACE (COMBI)', '90187511', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('WILSON', 'PD3169S', NULL, 'TOYOTA HIACE (COMBI)', '83648892', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('JING WEI', 'PD7767P', NULL, 'TOYOTA HIACE (COMBI)', '97942260', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('MR TAN ', 'PD8864K', NULL, '45 SEATER', '92309631', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('MELVIN LIM', 'PA1234R', NULL, 'TOYOTA COASTER 23 SEATER', '94762431', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('WANG LIN', 'PD2473U', NULL, 'YUTONG 49 SEATER', '96995041', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('FABIAN TAN', 'SNZ9938H', NULL, 'TOYOTA ALPHARD HS BLACK', '87821805', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('KENT CHAN', 'PD5655S', NULL, 'TOYOTA HIACE (COMBI)', '87728331', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('WONG NGEE YEW', 'SNL1880R', NULL, 'TOYOTA ALPHARD HS BLACK', '80101880', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ADRAIN HING', 'SPE751A ', NULL, 'TOYOTA ALPHARD BLACK AH40', '92366272', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('BEE ', 'PC3927B', NULL, 'TOYOTA HIACE (COMBI)', '96264288', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('KHAIRUL', 'PD6677Y', NULL, 'TOYOTA HIACE (COMBI)', '85087426', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('ALAN', 'PC2632H', NULL, 'TOYOTA COASTER 23 SEATER', '98400314', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('MR TAN ', 'PC501R', NULL, 'TOYOTA COASTER 23 SEATER', '82235793', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('KIKI', NULL, NULL, 'TOUR GUIDE', '90629087', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('NICHOLAS WONG', 'SPB5548D', NULL, 'TOYOTA VELLFIRE', '84338870', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('TERENCE THAM', 'SNU7720H', NULL, 'TOYOTA ALPHARD WHITE AH40', '81608080', NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('A', NULL, NULL, NULL, NULL, NULL);
INSERT INTO drivers (name, plate, "rateNote", vehicle, phone, "driverId") VALUES ('MAX WEE', NULL, NULL, NULL, NULL, NULL);

-- Clients
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('AMINA IDER', 'AID023', 'SG53CGMEH9', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'AMINA');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('AMZAR SUAPRDI', 'MAS366', 'SG5IMLOP6A', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('KATHERINA KLAESER', 'KKL064', 'SG51CGMEI0', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('KENNETH TAN', 'KTA122', 'SG51CGMEH9', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('LI JIE HUI', 'JLI351', '850', 'APM TERMINALS MANAGEMENT (SINGAPORE) PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('PAN WANJING', 'WPA059', 'SG517GMEM6', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('SHERYL SILVA', 'SSI465', '110', 'APM TERMINALS SINGAPORE PTE LTD', 'SHERYL');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('TRILLE NIELSEN', 'TNI057', 'NA', 'MAERSK LOGISTICS & SERVICES USA INC.', 'SHIRLYN');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MAX TENG', 'MTE101', '110', 'APM TERMINALS MANAGEMENT (SINGAPORE) PTE LTD', 'SHIRLYN');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('LISHAN KHOO', 'LKH041', 'SG51BGLEC8', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('JAY ZHANG', 'JJZ104', 'SG53DGMEH7', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ILDIKO VARGA ', 'IVA040', '510', 'APM TERMINALS MANGEMENT B.V', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ABDUL AZEES, JAMALDEEN', 'AAJ028', 'SG51NTHA00', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('CHARLES DE GUZMAN', 'CDG009', 'SG51NTHA00', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('EUGENE NAI', 'ENA047', 'SG51MLLG01', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ANGELINE KOH', 'AKO337', 'SG53CGME10', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('WILYER RODIL ', 'WAR009', 'SG51MLTM07 ', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ASHISH MEDIRATTA', 'AME067', 'SG017TH344', 'A.P. MOLLER SINGAPORE', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('SAMAPORN KANDET ', 'SKA722', 'SG51MLLSW1 ', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('WENDALINE WOO ', 'WWO026', 'SG516GMED6', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('SARINDAR PAL KAUR ', 'SPK046 ', 'SG51GGMEA6', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('STEVEN CHEUNG', 'RAN185', 'SG51CTHEJ9 ', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('JEZ MCQUEEN', 'JCM159', 'SG51CTHEJ9 ', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MARGARET ONG', 'MON008', 'SG51GGMEA6', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('FELIX BADER', 'FBA072', 'SG51XTH641', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('YVONNE HERRERA', 'YAH009', 'SG517TH643', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('CHRISTINE TEO', 'CTE043', 'SG51BGLEC8', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ELAINE LOW', 'EAD044', 'SG517GMEB3', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('KELVIN LIN', 'YKL017', '517', 'APM TERMINALS MANAGEMENT (SINGAPORE) PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('SONG MING QIANG', 'MMS031', 'SG517TH639', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('YONG XIN NI ELYSSA', 'EYO013', 'SG51UGM114', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MAE HONA', 'MCH162', 'SG51GGMEA6', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('LILIAN WONG ', 'LLW009', 'SG51XTHA00', 'MAERSK SINGAPORE PTE LTD', 'LILIAN');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('EUGENE KOH ', 'EKO094', 'SG74LLSIC0 ', 'MB PROJECTS PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('DANIEL BERRY', 'DBE007', '202', 'APM TERMINALS SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('BRAM DE JONG', 'IDBDE074 ', NULL, NULL, 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('LORRAINE WONG ', 'LWO028', 'SG517GMEM6', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('LUCAS LUO', 'XLU004', 'SG51KTH013', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MICHELLE LIM', 'MYU045', 'SG51LGLC75', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('EUNICE YAP ', 'EWY007', 'SG51BGLEC8', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('JACINTHA POH', 'JKH068', 'SG516GMD02', 'MB PROJECTS PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MELVIN HENG', 'MHE314', NULL, 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('FIONA TAN ', 'AFT003', 'SG51ATHB00', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ALAN YONG', 'ELITE', 'SCM79U', 'ELITE SKYLINE LIMOUSINE', 'ELITE');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('DICKSON LIEW', 'DYL023 ', 'SG51MT2EJ0', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('CLAUDETTE RETAMAL', 'CRE132 ', 'SG537FR552', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('AHMED EL AMRANI ', 'AEA044', '410', 'APM TERMINALS SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('SANJAY KUMAR ', 'PSK074', ' SG51CTHEJ9 ', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('WENNY TANGO', 'WNT003', 'SG51BGLEC8', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('SEAN SEAH', 'ELITE', 'SNK7862J', 'ELITE SKYLINE LIMOUSINE', 'ELITE');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('YUMIKO ONOUE ', 'YON004', 'SG53CGMEH6 ', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ANNIE CHIA ', 'SKC010', 'SG01MLFN01', 'AP MOLLER SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MAY WONG', 'YMW002', 'SG51GGMEA6 ', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ROBERT TOLENTINO', 'RJT018', 'NA', 'MAERSK L&S INTERNATIONAL B.V. & MAERSK LINE UK', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ABDUL HALIM ABDUL AZIZ ', 'AAZ064', 'NA', 'MAERSK LOGISTIC & SERVICES [MALAYSIA] SDN BHD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('RIZKI YUSA PUTERA ', 'RYP004', 'SG53HGMEA8', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('DENNIS TAN KHOON YAU ', 'KT012', 'MY04KFIER4', 'AMAZON SINGAPORE', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('VINCENT OW', 'VBO072', 'SG516GMD02', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('EUNICE LENG ', 'QWL002', 'SG51LGLEK6', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('BRYANT LAI', 'CHL065', 'SG51MLSL10', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MELINDA TAY', 'MTA220', 'SG513GMA00 ', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('CASSANDRA NG', 'MFS', 'NA', 'MFS TECHNOLOGY (S) PTE LTD', 'ELITE');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ALEX TENG ', 'ATK017', ' SG53XGLA80  ', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('GOI POH LING', 'PLG001', '110', 'APM TERMINALS SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('JULIA WU', 'HOME DEPOT', 'NA', 'HOME DEPOT', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('KAUNG MYAT', 'KMY014', 'SG51NTHA02', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('JIEHUI LIAW', 'JLI448', 'SG017TH344', 'AP MOLLER SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ROGER NG', 'RNG019', 'SG51CTHEJ9', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MICHELLE KHWEE', 'EQUINIX', 'NA', 'EQUINIX SINGAPORE PTE LTD', 'ELITE');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('AJMEER KHAN ', 'MAA383', 'SG51MLOP6A  ', 'MAERSK OIL TRADING SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('KOH LING DI', '2049102', 'SG51UGM114', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('DIANA WONG', 'DWO053', 'SG51CGMEI1', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('QU XINTIAN', 'XQU003', 'SG01TH407', 'AP MOLLER SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ALAN TOH', 'ELITE', 'SNK2131T', 'ELITE SKYLINE LIMOUSINE', 'ELITE');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('STEPHANIE BOOI', NULL, NULL, 'LF LOGISTICS SERVICES PTE LTD ', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('GENTA AOKI', 'AOKI', 'NA', 'EASTOOL INDUSTRIES SDN BHD', 'ELITE');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('JEAN HOONG', 'JHO016', 'SG53BT3SET4', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MATTHEW BANNON', 'MBA579', 'SG53LLSDAO  ', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('GWEN GUI', 'GGU123', ' SG53DGMEH7 ', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('HISAHITO TAKENAKA', 'TAKENAKA', 'NA', NULL, 'ELITE');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('DAMIEN NG', 'DNG017', '850', 'APM TERMINALS SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('RACHEL LOO', 'JYL012', 'SG53BMRB22', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ERIC NG', 'SXN002', 'SG51CGMEI1', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MARC GRISSENBERGER', 'MGR248', 'NA', 'ASML', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('LAU ZHIHUI', 'ZLA014', 'NA', 'AP MOLLER SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('SHARON', 'ELITE', 'NA', 'NA', 'ELITE');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ANDREW RAMSDALE', 'ARA645', 'GB63F150', 'MAERSK BRITAIN ', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('CHENG CHIN LEE ', 'CCH455', 'SG516GMED6', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('OLIVIA KHOO', 'EQUINIX', 'NA', 'EQUINIX AUSTRILIA PTE LTD', 'ELITE');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('DELPHINE CHIN ', 'DCH385', 'SG517GMA00  ', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('MICHELLE YIP', 'MY017', 'NA', 'GOVTECH SINGAPORE', 'ELITE');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('STEVE CHEUNG', 'KHC005', 'SG51BMPEE2', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('PATRICK LOI', 'PWL006', ' SG51CGMEI1', 'MAERSK SINGAPORE PTE LTD', 'SINADM');
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('A', NULL, NULL, NULL, NULL);
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('B', NULL, NULL, NULL, NULL);
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('C', NULL, NULL, NULL, NULL);
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('D', NULL, NULL, NULL, NULL);
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('E', NULL, NULL, NULL, NULL);
INSERT INTO clients ("hostName", uid, "costCentre", company, code) VALUES ('ALICE SPAGNOLI', NULL, NULL, NULL, NULL);

-- Job Types
INSERT INTO job_types (name) VALUES ('ADDITIONAL CHARGE');
INSERT INTO job_types (name) VALUES ('ADDITIONAL STOP (LOCAL)');
INSERT INTO job_types (name) VALUES ('ADDITIONAL STOP (MALAYSIA)');
INSERT INTO job_types (name) VALUES ('ADDITIONAL STOP (WITHIN 3KM)(23/45 SEATER)');
INSERT INTO job_types (name) VALUES ('ADDITIONAL STOP (WITHIN 3KM)(SALOON/MPV/COMBI)');
INSERT INTO job_types (name) VALUES ('ARRIVAL (DRIVE WAY PICK UP)');
INSERT INTO job_types (name) VALUES ('ARRIVAL (MEET & GREET)');
INSERT INTO job_types (name) VALUES ('CANCELLATION (100%)');
INSERT INTO job_types (name) VALUES ('CANCELLATION (25%)');
INSERT INTO job_types (name) VALUES ('CANCELLATION (50%)');
INSERT INTO job_types (name) VALUES ('DEPARTURE');
INSERT INTO job_types (name) VALUES ('DISPOSAL');
INSERT INTO job_types (name) VALUES ('HOURLY (LOCAL)');
INSERT INTO job_types (name) VALUES ('HOURLY (MALAYSIA)');
INSERT INTO job_types (name) VALUES ('MIDNIGHT SURCHARGE (LOCAL) ');
INSERT INTO job_types (name) VALUES ('MIDNIGHT SURCHARGE (MALAYSIA) ');
INSERT INTO job_types (name) VALUES ('MISCELLANEOUS');
INSERT INTO job_types (name) VALUES ('TOUR GUIDE (MIN 2)');
INSERT INTO job_types (name) VALUES ('TRANSFER (CROSS BORDER)(MINI VAN)');
INSERT INTO job_types (name) VALUES ('TRANSFER (CROSS BORDER)(MPV)');
INSERT INTO job_types (name) VALUES ('TRANSFER (CROSS BORDER)(SALOON)');
INSERT INTO job_types (name) VALUES ('TRANSFER (LOCAL)');
INSERT INTO job_types (name) VALUES ('TRANSFER (TUAS)');
INSERT INTO job_types (name) VALUES ('WAITING CHARGE (15 MINS/BLOCK) ');
INSERT INTO job_types (name) VALUES ('WAITING CHARGE (15 MINS/BLOCK) (MALAYSIA)');

-- Rates
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('ADDITIONAL STOP (BEYOND 3KM) - LOCAL', '30', 'per stop');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('ADDITIONAL STOP (WITHIN 3KM) - BUS', '30', 'per stop');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('ADDITIONAL STOP (WITHIN 3KM) - CAR/VAN', '15', 'per stop');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('ADDITIONAL STOP - MALAYSIA', '30', 'per stop');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('AIRPORT (CHANGI TO TPP) - MINI VAN', '240', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('AIRPORT (CHANGI TO TPP) - MPV/ALPHARD', '250', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('AIRPORT (CHANGI TO TPP) - SALOON', '210', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('AIRPORT ARRIVAL (MEET & GREET) - MINI VAN', '90', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('AIRPORT ARRIVAL (MEET & GREET) - MPV/ALPHARD', '90', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('AIRPORT ARRIVAL (MEET & GREET) - SALOON', '70', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('AIRPORT DEPARTURE - MINI VAN', '80', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('AIRPORT DEPARTURE - MPV/ALPHARD', '80', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('AIRPORT DEPARTURE - SALOON', '60', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('CANCELLATION FEE (100%)', '140', 'flat');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('CANCELLATION FEE (50%)', '70', 'flat');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('FRASER PLACE PUTERI HARBOUR - MINI VAN', '200', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('FRASER PLACE PUTERI HARBOUR - MPV/ALPHARD', '210', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('FRASER PLACE PUTERI HARBOUR - SALOON', '190', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('HOURLY DISPOSAL (LOCAL) - LARGE BUS', '100', 'per hour (min 4 hrs)');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('HOURLY DISPOSAL (LOCAL) - MINI BUS', '90', 'per hour (min 4 hrs)');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('HOURLY DISPOSAL (LOCAL) - MINI VAN', '70', 'per hour (min 4 hrs)');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('HOURLY DISPOSAL (LOCAL) - MPV/ALPHARD', '70', 'per hour (min 4 hrs)');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('HOURLY DISPOSAL (LOCAL) - SALOON', '60', 'per hour (min 4 hrs)');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('HOURLY DISPOSAL (MALAYSIA) - MINI VAN', '80', 'per hour (min 6 hrs)');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', '90', 'per hour (min 6 hrs)');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('HOURLY DISPOSAL (MALAYSIA) - SALOON', '70', 'per hour (min 6 hrs)');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('LAST MINUTE ACTIVATION (CB) - MINI VAN', '240', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('LAST MINUTE ACTIVATION (CB) - MPV/ALPHARD', '250', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('LAST MINUTE ACTIVATION (CB) - SALOON', '230', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('MIDNIGHT SURCHARGE - LOCAL', '15', 'per hour');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('MIDNIGHT SURCHARGE - MALAYSIA', '20', 'per hour');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TOUR GUIDE', '50', 'per hour');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (CBD/TOWN) - MINI BUS', '110', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (CBD/TOWN) - MINI VAN', '60', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (CBD/TOWN) - MPV/ALPHARD', '60', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (CBD/TOWN) - SALOON', '45', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (CROSS BORDER) - MINI VAN', '160', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (CROSS BORDER) - MPV/ALPHARD', '170', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (CROSS BORDER) - SALOON', '150', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (LOCAL) - LARGE BUS', '160', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (LOCAL) - MINI BUS', '130', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (LOCAL) - MINI VAN', '70', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (LOCAL) - MPV/ALPHARD', '70', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (LOCAL) - SALOON', '55', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (TUAS/WEST DC) - LARGE BUS', '185', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (TUAS/WEST DC) - MINI BUS', '150', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (TUAS/WEST DC) - MINI VAN', '90', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (TUAS/WEST DC) - MPV/ALPHARD', '90', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('TRANSFER (TUAS/WEST DC) - SALOON', '80', 'per trip');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('WAITING TIME - LOCAL', '20', 'per 15-min block');
INSERT INTO rates ("jobType", "unitPrice", "billingUnit") VALUES ('WAITING TIME - MALAYSIA', '25', 'per 15-min block');

-- Jobs
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (1, '2026-01-22', 'MINV2026010001', 'KENNY LAW', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: JEAN HOONG
UID: JHO016
COST CENTRE: SG53BT3SET4
PLQ  - SENAI AIRPORT
PAX: 1 PAX
DRIVER: KENNY LAW (SMW8620H)', '07:30', '08:57', '1h 27m', 1, 220, 220, 160, 60, NULL, NULL, 'JEAN HOONG', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'JHO016', 'SG53BT3SET4', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (2, '2026-01-22', 'MINV2026010001', 'KENNY LAW', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: JEAN HOONG
UID: JHO016
COST CENTRE: SG53BT3SET4
DYSON MANUFACTURING SDN BHD(GLOBAL DEVELOPMENT CAMPUS-GDC) PLO 208, JALAN CYBER 14, SENAI IND EST IV,81400 SENAI, JOHOR BAHRU,JOHOR. - PLQ
PAX: 1 PAX
DRIVER: KENNY LAW (SMW8620H)', '12:30', '14:30', '2h 0m', 1, 220, 220, 160, 60, NULL, NULL, 'JEAN HOONG', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'JHO016', 'SG53BT3SET4', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (3, '2026-01-22', 'MINV2026010001', 'KENNY LAW', 'WAITING CHARGE (15 MINS/BLOCK) (MALAYSIA)', 'HOST BOARDED THE CAR AT 1313HR WHEN THE PICK UP TIME IS 1230HR', '12:45', '13:13', '0h 28m', 2, 25, 50, NULL, 50, NULL, NULL, 'JEAN HOONG', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'JHO016', 'SG53BT3SET4', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (4, '2026-01-27', 'MINV2026010002', 'KENNY LAW', 'HOURLY (MALAYSIA)', 'REQUESTOR: MATTHEW BANNON
UID: MBA579
COST CENTRE: SG53LLSDAO  
PLQ  - ARKEMA COATING RESINS MALAYSIA SDN. BHD. GATE C - PLQ
PAX: 2 PAX
DRIVER: KENNY LAW (SMW8620H)
TIME:1030 - 1702', '10:30', '17:02', '6h 32m', 7, 70, 490, 240, 250, NULL, NULL, 'MATTHEW BANNON', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'MBA579', 'SG53LLSDAO  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (5, '2026-01-27', 'MINV2026010003', 'ALAN TOH', 'HOURLY (MALAYSIA)', 'REQUESTOR: VINCENT OW
UID: VBO072
COST CENTRE: SG516GMD02   
PLQ - D37 MAERSK WAREHOUSE - MAERSK LOGISTICS & SERVICES MALAYSIA SDN. BHD. (PASIR GUDANG) - PLQ
PAX: 3 PAX
DRIVER: ALAN TOH (SNK2131T)
TIME:0800 - 1848', '08:00', '18:48', '10h 48m', 11, 90, 990, 880, 110, NULL, NULL, 'VINCENT OW', 'MAERSK SINGAPORE PTE LTD', 'VBO072', 'SG516GMD02', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (6, '2026-02-05', 'MINV2026020002', 'ELVIN SAI', 'HOURLY (MALAYSIA)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
PLQ - BMW ASIA TECHNOLOGY CENTRE SDN BHD - SENAI AIRPORT - MERCEDES-BENZ PARTS LOGISTICS ASIA PACIFIC SDN.BHD. - PLQ
PAX: 4 PAX
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0730 - 1718', '07:30', '17:18', '9h 48m', 10, 90, 900, 800, 100, NULL, NULL, 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (7, '2026-02-09', 'MINV2026020001', 'ALAN YONG', 'HOURLY (MALAYSIA)', 'REQUESTOR: JAY ZHANG 
UID: JJZ104
COST CENTRE: SG53DGMEH7 
405 SERANGOON AVE 1 (S) 550405 - 11A BELMONT ROAD (S) 269858 - D37 MAERSK WAREHOUSE - PLQ
PAX: 2 PAX
DRIVER: ALAN YONG (SCM79U)
TIME: 0726 - 1207', '07:26', '12:07', '4h 41m', 5, 90, 450, 480, -30, NULL, NULL, 'JAY ZHANG', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'JJZ104', 'SG53DGMEH7', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (8, '2026-02-23', 'MINV2026020002', 'ALAN YONG', 'HOURLY (MALAYSIA)', 'REQUESTOR: JEZ MCQUEEN
UID: JCM159
COST CENTRE: SG51CTHEJ9
MERCURE SINGAPORE BUGIS - D37 MAERSK WAREHOUSE - MERCURE SINGAPORE BUGIS - PLQ
PAX: 4 PAX
DRIVER: ALAN YONG (SCM79U)
TIME: 0715 - 1503', '07:15', '15:03', '7h 48m', 8, 90, 720, 640, 80, '[Date auto-parsed from original garbled entry ''23/0202026'' - please verify]', NULL, 'JEZ MCQUEEN', 'MAERSK SINGAPORE PTE LTD', 'JCM159', 'SG51CTHEJ9 ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (9, '2026-02-23', 'MINV2026020002', 'ELVIN SAI', 'HOURLY (MALAYSIA)', 'REQUESTOR: JEZ MCQUEEN
UID: JCM159
COST CENTRE: SG51CTHEJ9
HOTEL RAMADA BY WYNDHAM MERIDIN JOHORE BAHRU - D37 MAERSK WAREHOUSE -CEVA MALAYSIA - MERCURE SINGAPORE BUGIS
PAX: 4 PAX
DRIVER: ELVIN TING (SPC2260Y)
TIME: 0815 - 1328', '08:15', '13:28', '5h 13m', 6, 90, 540, 480, 60, '[Date auto-parsed from original garbled entry ''23/0202027'' - please verify]', NULL, 'JEZ MCQUEEN', 'MAERSK SINGAPORE PTE LTD', 'JCM159', 'SG51CTHEJ9 ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (10, '2026-02-05', NULL, 'ELVIN SAI', 'HOURLY (MALAYSIA)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
PLQ - BMW ASIA TECHNOLOGY CENTRE SDN BHD - SENAI AIRPORT - MERCEDES-BENZ PARTS LOGISTICS ASIA PACIFIC SDN.BHD. - PLQ
PAX: 4 PAX
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0730 - 1718', '07:30', '17:18', '9h 48m', 10, 90, 900, 800, 100, NULL, NULL, 'AMINA IDER', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'AID023', 'SG53CGMEH9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (11, '2026-03-04', 'MINV2026030001', 'ALAN TOH', 'HOURLY (MALAYSIA)', 'REQUESTOR: ANGELINE KOH	
UID: AKO337
COST CENTRE: SG53CGME10
PAX: 4 PAX
952 DUNEARN ROAD - D37 MAERSK WAREHOUSE - YOTEL SINGAPORE 
DRIVER: ALAN TOH (SNK2131T)
TIME: 1130 - 1755', '11:30', '17:55', '6h 25m', 7, 90, 630, NULL, 630, NULL, NULL, 'ANGELINE KOH', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'AKO337', 'SG53CGME10', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (12, '2026-03-09', 'MINV2026030003', 'ELVIN SAI', 'HOURLY (MALAYSIA)', 'REQUESTOR: VINCENT OW
UID: VBO072
COST CENTRE: SG516GMD02
PAX: 4 PAX
PLQ 1 - MAPLETREE WAREHOUSE - D37 MAERSK - AEON BUKIT IDAH - JOO KOON MRT - PLQ 1 
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0800 - 1617', '08:00', '16:17', '8h 17m', 8, 90, 720, 640, 80, NULL, NULL, 'VINCENT OW', 'MAERSK SINGAPORE PTE LTD', 'VBO072', 'SG516GMD02', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (13, '2026-03-11', 'MINV2026030002', 'ELVIN SAI', 'HOURLY (MALAYSIA)', 'REQUESTOR: JAY ZHANG
UID: JJZ104
COST CENTRE: SG53DGMEH7
405 SERANGOON AVE 1 (S) 550405 - 150 TUAS SOUTH AVE 5 (S) 637363 - D37 MAERSK WAREHOUSE - NYONYA TREATS SUNWAY ISKANDAR - 150 TUAS SOUTH AVE 5 (S) 637363 - 405 SERANGOON AVE 1 (S) 550405
PAX: 4 PAX
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0744 - 1351', '07:44', '13:51', '6h 7m', 6, 90, 540, 480, 60, NULL, NULL, 'JAY ZHANG', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'JJZ104', 'SG53DGMEH7', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (14, '2026-03-12', 'MINV2026030003', 'ALAN YONG', 'HOURLY (MALAYSIA)', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG51BGLEC8
AXIS @ SIGLAP, 59 EAST COAST TERRACE SINGAPORE 458950 - D37 MAERSK WAREHOUSE - AXIS @ SIGLAP, 59 EAST COAST TERRACE SINGAPORE 458950
PAX: 1 PAX
DRIVER: ALAN YONG (SCM79U)
TIME: 1045 - 1632', '10:45', '16:32', '5h 47m', 6, 90, 540, 480, 60, NULL, NULL, 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (15, '2026-03-12', 'MINV2026030002', 'ALAN TOH', 'HOURLY (MALAYSIA)', 'REQUESTOR: GWEN GUI
UID: GGU123
COST CENTRE: SG53DGMEH7
ALOFT NOVENA SINGAPORE - D37 MAERSK WAREHOUSE - ALOFT NOVENA SINGAPORE - HOLIDAY INN EXPRESS ORCHARD - FOUR POINT HOTEL - MODRAIN DUXTON - W HOTEL SENTOSA COVE
PAX: 5 PAX
DRIVER: ALAN TOH (SNK2131T)
TIME: 1045 - 1810', '10:45', '18:10', '7h 25m', 8, 90, 720, 640, 80, NULL, NULL, 'GWEN GUI', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'GGU123', ' SG53DGMEH7 ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (16, '2026-03-17', 'MINV2026030003', 'ALAN YONG', 'HOURLY (LOCAL)', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG517GMEB3
SINGAPORE CHANGI AIRPORT TERMINAL  (SQ351) - FAIRMONT SINGAPORE - PLQ 1
PAX: 1 PAX (VINCENT CLERC)
DRIVER: ALAN YONG (SCM79U)
TIME: 0652 - 0922', '06:52', '09:12', '2h 20m', 4, 70, 280, 240, 40, NULL, NULL, 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (17, '2026-03-17', 'MINV2026030003', 'ALAN YONG', 'TRANSFER (LOCAL)', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG517GMEB3
PLQ 1 - CARLTON HOTEL
PAX: 1 PAX (VINCENT CLERC)
DRIVER: ALAN YONG (SCM79U)', '18:05', '18:32', '0h 27m', 1, 70, 70, 60, 10, NULL, NULL, 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (18, '2026-03-18', 'MINV2026030003', 'ALAN YONG', 'TRANSFER (TUAS)', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG517GMEB3
FAIRMONT SINGAPORE - 15 BENOI SECTOR
PAX: 2 PAX (VINCENT CLERC, ELAINE LOW)
DRIVER: ALAN YONG (SCM79U)', '08:00', '08:38', '0h 38m', 1, 90, 90, 80, 10, NULL, NULL, 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (19, '2026-03-18', 'MINV2026030003', 'ALAN YONG', 'TRANSFER (TUAS)', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG517GMEB3
15 BENOI SECTOR - FAIRMONT SINGAPORE
PAX: 2 PAX (JEZ MCQUEEN, ELAINE LOW)
DRIVER: ALAN YONG (SCM79U)', '14:15', '14:48', '0h 33m', 1, 90, 90, 80, 10, NULL, NULL, 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (20, '2026-03-18', 'MINV2026030003', 'ALAN YONG', 'HOURLY (LOCAL)', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG517GMEB3
PLQ 1 - FAIRMONT SINGAPORE
PAX: 2 PAX (VINCENT CLERC, ELAINE LOW)
DRIVER: ALAN YONG (SCM79U)
TIME: 1700 - 1750', '17:00', '17:50', '0h 50m', 2, 70, 140, 120, 20, NULL, NULL, 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (21, '2026-03-18', 'MINV2026030003', 'ELVIN SAI', 'TRANSFER (TUAS)', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG513GMA00
BAKER & COOK - CHIN BEE GARDENS, 44 JALAN MERAH SAGA -  15 BENOI SECTOR
PAX: 1 PAX (SCOTT ANDREW ELLIOTT)
DRIVER: ELVIN SAI (SPC2260Y)', '08:45', '09:17', '0h 32m', 1, 90, 90, 80, 10, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (22, '2026-03-18', 'MINV2026030003', 'ELVIN SAI', 'HOURLY (LOCAL)', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG513GMA00
15 BENOI SECTOR - 1 TAMAN WARNA, HOLLAND RESIDENCES -  PLQ 1
PAX: 1 PAX (SCOTT ANDREW ELLIOTT)
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 1355 - 1446', '13:55', '14:46', '0h 51m', 2, 70, 140, 120, 20, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (23, '2026-03-18', 'MINV2026030003', 'ELVIN SAI', 'HOURLY (LOCAL)', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG513GMA00
PLQ 1 - RAFFLES HOTEL - 1 TAMAN WARNA, HOLLAND RESIDENCES
PAX: 1 PAX (SCOTT ANDREW ELLIOTT)
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 1800 - 2223', '18:00', '22:23', '4h 23m', 5, 70, 350, 52, 298, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (24, '2026-03-19', 'MINV2026030003', 'ALAN YONG', 'DEPARTURE', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG517GMEB3
FAIRMONT SINGAPORE - SINGAPORE CHANGI AIRPORT TERMINAL 3 (SQ802)
PAX: 1 PAX (VINCENT CLERC)
DRIVER: ALAN YONG (SCM79U)', '06:00', '06:25', '0h 25m', 1, 80, 80, 70, 10, NULL, NULL, 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (25, '2026-03-19', 'MINV2026030003', 'ALAN YONG', 'MIDNIGHT SURCHARGE (LOCAL) ', 'APPLICABLE FROM 2300 - 0700', '06:00', '06:26', '0h 26m', 1, 15, 15, 15, NULL, NULL, NULL, 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (26, '2026-03-25', 'MINV2026030003', 'MAX WEE', 'TRANSFER (LOCAL)', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG517GMA00
PLQ 1 - SHERTON TOWER
PAX: 2 PAX 
DRIVER: MAX WEE (SNN4468T)', '18:00', '18:30', '0h 30m', 1, 70, 70, 55, 15, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (27, '2026-03-25', 'MINV2026030004/SRM2026030001', 'KENNY LAW', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: ALICE SPAGNOLI 
UID: ASP118
COST CENTRE: NA
SWISSÔTEL THE STAMFORD SINGAPORE - ZONE B, MAPLETREE HUB, A7 TO A9, LEVEL 2,DP40 & D44, JALAN DPB/8, PELABUHAN TANJUNG PELEPAS, 81560 GELANG PATAH, JOHOR, MALAYSIA
PAX: 1 PAX
DRIVER: KENNY LAW (SLP6571C)', '07:00', '07:57', '0h 57m', 1, 150, 150, 120, 30, 'PAYMENT BY CREDIT CARD', NULL, 'ALICE SPAGNOLI ', NULL, NULL, NULL, NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (28, '2026-03-25', 'MINV2026030004/SRM2026030001', 'KENNY LAW', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: ALICE SPAGNOLI 
UID: ASP118
COST CENTRE: NA
ZONE B, MAPLETREE HUB, A7 TO A9, LEVEL 2,DP40 & D44, JALAN DPB/8, PELABUHAN TANJUNG PELEPAS, 81560 GELANG PATAH, JOHOR, MALAYSIA - SWISSÔTEL THE STAMFORD SINGAPORE
PAX: 1 PAX
DRIVER: KENNY LAW (SLP6571C)', '16:00', '16:43', '0h 43m', 1, 150, 150, 120, 30, 'PAYMENT BY CREDIT CARD', NULL, 'ALICE SPAGNOLI ', NULL, NULL, NULL, NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (29, '2026-03-26', 'MINV2026030004/SRM2026030001', 'KENNY LAW', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: ALICE SPAGNOLI 
UID: ASP118
COST CENTRE: NA
SWISSÔTEL THE STAMFORD SINGAPORE - ZONE B, MAPLETREE HUB, A7 TO A9, LEVEL 2,DP40 & D44, JALAN DPB/8, PELABUHAN TANJUNG PELEPAS, 81560 GELANG PATAH, JOHOR, MALAYSIA
PAX: 1 PAX
DRIVER: KENNY LAW (SLP6571C)', '06:48', '07:53', '1h 5m', 1, 150, 150, 120, 30, 'PAYMENT BY CREDIT CARD', NULL, 'ALICE SPAGNOLI ', NULL, NULL, NULL, NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (30, '2026-03-26', 'MINV2026030004/SRM2026030001', 'KENNY LAW', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: ALICE SPAGNOLI 
UID: ASP118
COST CENTRE: NA
ZONE B, MAPLETREE HUB, A7 TO A9, LEVEL 2,DP40 & D44, JALAN DPB/8, PELABUHAN TANJUNG PELEPAS, 81560 GELANG PATAH, JOHOR, MALAYSIA - SWISSÔTEL THE STAMFORD SINGAPORE
PAX: 1 PAX
DRIVER: ALAN TOH (SNK2137T)', '16:00', '16:55', '0h 55m', 1, 150, 150, 170, -20, 'PAYMENT BY CREDIT CARD. 634.09 AFTER HITPAY DEDUCTION
634.09 - 360 - 170 = 104.09 INTO COMPANY FUND', NULL, 'ALICE SPAGNOLI ', NULL, NULL, NULL, NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (31, '2026-03-26', NULL, 'ALAN YONG', 'HOURLY (LOCAL)', 'REQUESTOR: SHERYL SILVA
UID: SSI465
COST CENTRE: 110
FULLERTON HOTEL - PLQ 1 - DEMPSEY - FULLERTON HOTEL
PAX: 3 PAX
DRIVER: ALAN YONG (SCM79U)
TIME: 1430 - 1857', '14:30', '18:56', '4h 26m', 5, 70, 350, 300, 50, NULL, NULL, 'SHERYL SILVA', 'APM TERMINALS SINGAPORE PTE LTD', 'SSI465', '110', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (32, '2026-03-26', 'MINV2026030003', 'BEE', 'TRANSFER (LOCAL)', 'REQUESTOR: MICHELLE LIM 
UID: MYU045
COST CENTRE: SG51BGLB20
PLQ 1 - PAN PACIFIC SUITE ORCHARD
PAX: 10 PAX
DRIVER: BEE (PC3927B)', '18:00', '18:28', '0h 28m', 1, 70, 70, 55, 15, NULL, NULL, 'MICHELLE LIM', 'MAERSK SINGAPORE PTE LTD', 'MYU045', 'SG51LGLC75', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (33, '2026-03-26', 'MINV2026030003', 'TERENCE THAM', 'TRANSFER (LOCAL)', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG517GMA00
PLQ 1 - TANGLIN TRUST SCHOOL 
PAX: 1 PAX 
DRIVER: TERENCE THAM (SDU770H)', '16:00', '16:25', '0h 25m', 1, 70, 70, 60, 10, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (34, '2026-04-09', 'MINV2026040001', 'ALAN YONG', 'HOURLY (MALAYSIA)', 'REQUESTOR: JAY ZHANG 
UID: JJZ104
COST CENTRE: SG53DGMEH7 
405 SERANGOON AVE 1 (S) 550405 - 9 SARKIES ROAD - D37 MAERSK WAREHOUSE - PLQ
PAX: 2 PAX
DRIVER: ALAN YONG (SCM79U)
TIME: 0720 - 1315', '07:20', '13:15', '5h 55m', 6, 90, 540, 480, 60, NULL, NULL, 'JAY ZHANG', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'JJZ104', 'SG53DGMEH7', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (35, '2026-04-10', 'MINV2026040004', 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER)(MPV)', 'REQUESTOR: MARGARET ONG
UID: MON008
COST CENTRE: SG51GGMEA6
30 SEMBAWANG DRIVE, SUN PLAZA -  DECATHLON LOGISTICS MALAYSIA SDN.
PAX: 6 PAX
DRIVER: SEAH BOON HENG (SNW3810Z)', '07:15', '09:35', '2h 20m', 1, 170, 170, 160, 10, NULL, NULL, 'MARGARET ONG', 'MAERSK SINGAPORE PTE LTD', 'MON008', 'SG51GGMEA6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (36, '2026-04-10', 'MINV2026040004', 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: MARGARET ONG
UID: MON008
COST CENTRE: SG51GGMEA6
DECATHLON LOGISTICS MALAYSIA SDN - 30 SEMBAWANG DRIVE, SUN PLAZA
PAX: 4 PAX
DRIVER: SEAH BOON HENG (SNW3810Z)', '16:45', '18:33', '1h 48m', 1, 150, 150, 140, 10, NULL, NULL, 'MARGARET ONG', 'MAERSK SINGAPORE PTE LTD', 'MON008', 'SG51GGMEA6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (37, '2026-04-15', 'MINV2026040004', 'KENNY LAW', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: KOH LING DI 
UID: 2049102
COST CENTRE: SG51UGM114
707 JURONG WEST ST 71 SINGAPORE 640707 - WISMA A
PAX: 1 PAX
DRIVER: KENNY LAW (SLP7571C)', '07:30', '08:07', '0h 37m', 1, 150, 150, 120, 30, NULL, NULL, 'KOH LING DI', 'MAERSK SINGAPORE PTE LTD', '2049102', 'SG51UGM114', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (38, '2026-04-15', 'MINV2026040004', 'KENNY LAW', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: KOH LING DI 
UID: 2049102
COST CENTRE: SG51UGM114
WISMA A - 707 JURONG WEST ST 71 SINGAPORE 640707
PAX: 1 PAX
DRIVER: KENNY LAW (SLP7571C)', '17:30', '18:30', '1h 0m', 1, 150, 150, 120, 30, NULL, NULL, 'KOH LING DI', 'MAERSK SINGAPORE PTE LTD', '2049102', 'SG51UGM114', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (39, '2026-04-20', 'MINV2026040002', 'CHAY YU SIANG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: DAMIEN NG
UID: DNG017
COST CENTRE: 850
36 ST PATRICK''S RD, TIERRA VUE, SINGAPORE 424160 - 45 AMBER ROAD, SINGAPORE 439886 - HOC
PAX: 2 PAX
DRIVER: CHAY YU SIANG (SNF1866P)', '07:00', '08:42', '1h 42m', 1, 150, 150, 120, 30, NULL, NULL, 'DAMIEN NG', 'APM TERMINALS SINGAPORE PTE LTD', 'DNG017', '850', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (40, '2026-04-20', 'MINV2026040002', 'CHAY YU SIANG', 'ADDITIONAL STOP (LOCAL)', 'REQUESTOR: DAMIEN NG
UID: DNG017
COST CENTRE: 850
36 ST PATRICK''S RD, TIERRA VUE, SINGAPORE 424160 - 45 AMBER ROAD, SINGAPORE 439886 - HOC
PAX: 2 PAX
DRIVER: CHAY YU SIANG (SNF1866P)', '07:00', '07:17', '0h 17m', NULL, 30, 30, 30, NULL, NULL, NULL, 'DAMIEN NG', 'APM TERMINALS SINGAPORE PTE LTD', 'DNG017', '850', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (41, '2026-04-20', 'MINV2026040002', 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: DAMIEN NG
UID: DNG017
COST CENTRE: 850
WISMA A - PLQ 1
PAX: 1 PAX
DRIVER: SEAH BOON HENG (SNW3810Z)', '13:00', '13:44', '0h 44m', 1, 150, 150, 120, 30, NULL, NULL, 'DAMIEN NG', 'APM TERMINALS SINGAPORE PTE LTD', 'DNG017', '850', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (42, '2026-04-20', 'MINV2026040002', 'CHAY YU SIANG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: DAMIEN NG
UID: DNG017
COST CENTRE: 850
WISMA SUNWAY BIG BOX - 36 ST PATRICK''S RD, TIERRA VUE, SINGAPORE 424160
PAX: 1 PAX
DRIVER: CHAY YU SIANG (SNF1866P)', '17:00', '18:40', '1h 40m', 1, 150, 150, 130, 20, NULL, NULL, 'DAMIEN NG', 'APM TERMINALS SINGAPORE PTE LTD', 'DNG017', '850', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (43, '2026-04-27', 'MINV2026040005', 'ELVIN SAI', 'TRANSFER (CROSS BORDER)(MPV)', 'REQUESTOR: RACHEL LOO
UID: JYL012
COST CENTRE: SG53BMRB22
PAX: 4 PAX
SINGAPORE MARRIOTT TANG PLAZA HOTEL - D37 MAERSK WAREHOUSE
DRIVER: ELVIN SAI (SPC2260Y)', '07:30', '08:51', '1h 21m', 1, 170, 170, 160, 10, NULL, NULL, 'RACHEL LOO', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'JYL012', 'SG53BMRB22', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (44, '2026-04-27', 'MINV2026040005', 'ELVIN SAI', 'TRANSFER (CROSS BORDER)(MPV)', 'REQUESTOR: RACHEL LOO
UID: JYL012
COST CENTRE: SG53BMRB22
PAX: 4 PAX
 D37 MAERSK WAREHOUSE - 27 GREENWICH DRIVE
DRIVER: ELVIN SAI (SPC2260Y)', '11:22', '12:39', '1h 17m', 1, 170, 170, 160, 10, NULL, NULL, 'RACHEL LOO', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'JYL012', 'SG53BMRB22', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (45, '2026-04-28', 'MINV2026040003', 'CHAY YU SIANG', 'HOURLY (MALAYSIA)', 'REQUESTOR: ANGELINE KOH	
UID: AKO337
COST CENTRE: SG53CGME10
PAX: 1 PAX
952 DUNEARN ROAD - 7, JALAN PERSIARAN TEKNOLOGI ,TAMAN TEKNOLOGI JOHOR, 81400 SENAI, JOHOR. - 952 DUNEARN ROAD
CHAY YU SIANG (SNF1866P)
TIME: 0900 - 1343', '09:00', '13:43', '4h 43m', 6, 70, 420, 240, 180, NULL, NULL, 'ANGELINE KOH', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'AKO337', 'SG53CGME10', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (46, '2026-04-29', 'MINV2026040004', 'JJ', 'HOURLY (LOCAL)', 'REQUESTOR: ERIC NG
UID: SXN002
COST CENTRE: SG51CGMEI1
PLQ 1 - PSA HORIZON - SINGPOST - EAST COAST JUMBO
PAX: 10 PAX
DRIVER: JJ (PD7767P)
TIME: 1345 - 1740', '13:45', '17:40', '3h 55m', 4, 70, 280, 180, 100, '45/HR', NULL, 'ERIC NG', 'MAERSK SINGAPORE PTE LTD', 'SXN002', 'SG51CGMEI1', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (47, '2026-04-30', 'MINV2026040004', 'JJ', 'HOURLY (MALAYSIA)', 'REQUESTOR: ERIC NG
UID: SXN002
COST CENTRE: SG51CGMEI1
PLQ 1 - TIAN LAI SEAFOOD - ECO BOTANIC - WISMA A - JURONG EAST MRT - MBS TOWER 1
PAX: 8 PAX
DRIVER: JJ (PD7767P)
TIME: 1000 - 1900', '10:00', '19:00', '9h 0m', 9, 80, 720, 495, 225, '55/HR', NULL, 'ERIC NG', 'MAERSK SINGAPORE PTE LTD', 'SXN002', 'SG51CGMEI1', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (48, '2026-05-04', 'MINV2026050001', 'ALAN YONG', 'HOURLY (MALAYSIA)', 'REQUESTOR: JAY ZHANG 
UID: JJZ104
COST CENTRE: SG53DGMEH7 
PLQ 1 - PAN PACIFIC SINGAPORE - FOUR POINTS BY SHERATON - D37 MAERSK WAREHOUSE - 15 BENOI SECTOR - FOUR POINTS BY SHERATON - PAN PACIFIC SINGAPORE - PLQ 1
PAX: 6 PAX
DRIVER: ALAN YONG (SCM79U)
TIME: 0830 - 1650', '08:30', '16:50', '8h 20m', 9, 90, 810, 720, 90, NULL, NULL, 'JAY ZHANG', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'JJZ104', 'SG53DGMEH7', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (49, '2026-05-12', 'MINV2026050002/ MSR2026050001', 'MUHAMMAD RASUL', 'TRANSFER (CROSS BORDER)(MINI VAN)', 'REQUESTOR: MARC GRISSENBERGER 
UID: MGR248
COST CENTRE: NA
SWISSOTEL THE STAMFORD - ZONE B, MAPLETREE HUB, A7 TO A9, LEVEL 2,DP40 & D44, JALAN DPB/8, PELABUHAN TANJUNG PELEPAS, 81560 GELANG PATAH, JOHOR, MALAYSIA
PAX: 8 PAX
DRIVER: MUHAMMAD RASUL (PD1166M)', '07:30', '09:15', '1h 45m', 1, 160, 160, 160, NULL, 'PAYMENT BY CREDIT CARD
NET PAYEMNT AFTER HITPAY DEDUCTION 337.95', NULL, 'MARC GRISSENBERGER', 'ASML', 'MGR248', 'NA', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (50, '2026-05-12', 'MINV2026050002/ MSR2026050001', 'MUHAMMAD RASUL', 'TRANSFER (CROSS BORDER)(MINI VAN)', 'REQUESTOR: MARC GRISSENBERGER 
UID: MGR248
COST CENTRE: NA
D37 MAERSK WAREHOUSE - SWISSOTEL THE STAMFORD 
PAX: 8 PAX
DRIVER: MUHAMMAD RASUL (PD1166M)', '15:30', '16:45', '1h 15m', 1, 160, 160, 160, NULL, 'PAYMENT BY CREDIT CARD', NULL, 'MARC GRISSENBERGER', 'ASML', 'MGR248', 'NA', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (51, '2026-05-15', 'MINV2026050005', 'ELVIN SAI', 'HOURLY (LOCAL)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
PLQ - WISMA A - FRASER PLACE PUTERI HARBOUR -  PLQ
PAX: 4 PAX
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0700 - 1206', '07:00', '12:06', '5h 6m', 6, 90, 540, 480, 60, NULL, NULL, 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (52, '2026-05-18', 'MINV2026050005', 'ALAN YONG', 'HOURLY (MALAYSIA)', 'REQUESTOR: KATHARINA KLAESER
UID: KKL064
COST CENTRE: SG51CGMEI0
PAX: 3 PAX
PLQ 1 - QUINCY HOTEL - D37 - PLQ 1
DRIVER: ALAN YONG (SCM79U)
TIME: 0650 - 1328', '06:50', '13:28', '6h 38m', 7, 90, 630, 560, 70, NULL, NULL, 'KATHERINA KLAESER', 'MAERSK SINGAPORE PTE LTD', 'KKL064', 'SG51CGMEI0', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (53, '2026-05-18', 'MINV2026050005', 'ELVIN SAI', 'HOURLY (MALAYSIA)', 'REQUESTOR: KATHARINA KLAESER
UID: KKL064
COST CENTRE: SG51CGMEI0
PAX: 4 PAX
QUINCY HOTEL - D37 - PLQ 1
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0730 - 1328', '07:30', '13:28', '5h 58m', 6, 90, 540, 480, 60, NULL, NULL, 'KATHERINA KLAESER', 'MAERSK SINGAPORE PTE LTD', 'KKL064', 'SG51CGMEI0', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (54, '2026-05-18', 'MINV2026050005', 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
90 TANGLIN HALT ROAD - BMW ASIA TECHNOLOGY CENTRE SDN BHD
PAX: 1 PAX
DRIVER: SEAH BOON HENG (SNW3810Z)', '09:00', '10:00', '1h 0m', 1, 220, 220, 180, 40, NULL, NULL, 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (55, '2026-05-18', 'MINV2026050005', 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
BMW ASIA TECHNOLOGY CENTRE SDN BHD - JEM
PAX: 1 PAX
DRIVER: SEAH BOON HENG (SNW3810Z)', '12:00', '13:17', '1h 17m', 1, 220, 220, 180, 40, NULL, NULL, 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (56, '2026-05-18', 'MINV2026050005', 'SEAH BOON HENG', 'WAITING CHARGE (15 MINS/BLOCK) ', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
BMW ASIA TECHNOLOGY CENTRE SDN BHD - JEM
PAX: 1 PAX
DRIVER: SEAH BOON HENG (SNW3810Z)', '12:15', '12:26', '0h 11m', 1, 25, 25, 10, 15, NULL, NULL, 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (57, '2026-05-19', 'MINV2026050005', 'ALAN YONG', 'HOURLY (MALAYSIA)', 'REQUESTOR: WENDALINE WOO
UID: WWO026
COST CENTRE: SG516GMED6 
PAX: 2 PAX
PLQ 1 - D37 MAERSK WAREHOUSE - MAPLETREE WAREHOUSE - AEON BUKIT INDAH - MAERSK LOGISTICS AND SERVICES MALAYSIA SDN BHD - PLQ 1
DRIVER: ALAN YONG (SCM79U)
TIME: 0800 - 1733', '08:00', '17:33', '9h 33m', 10, 90, 900, 800, 100, NULL, NULL, 'WENDALINE WOO ', 'MAERSK SINGAPORE PTE LTD', 'WWO026', 'SG516GMED6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (58, '2026-05-20', 'MINV2026050004', 'ALAN YONG', 'ARRIVAL (MEET & GREET)', 'REQUESTOR: KELVIN LIN
UID: YKL017
COST CENTRE: 517
PAX: 3 PAX
AIRPORT T1 (BR215) - JW MARRIOTT HOTEL SINGAPORE SOUTH BEACH
DRIVER: ALAN YONG (SCM79U)', '13:55', '14:30', '0h 35m', 1, 90, 90, 80, 10, NULL, NULL, 'KELVIN LIN', 'APM TERMINALS MANAGEMENT (SINGAPORE) PTE LTD', 'YKL017', '517', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (59, '2026-05-21', 'MINV2026050005', 'MELVIN LIM', 'TRANSFER (LOCAL)', 'REQUESTOR: MICHELLE LIM
UID: MYU045
COST CENTRE: SG51LGLC75
PAX: 13 PAX
PLQ 1 - 54 PALAWAN BEACH WALK, THE PALAWAN @SENTOSA 
DRIVER: MELVIN LIM (PA1234R)', '17:30', '18:12', '0h 42m', 1, 130, 130, 170, -40, 'DUE TO MISCOMMUNICATION. 80 FOR CANCELLATION OF 45 SEATER', NULL, 'MICHELLE LIM', 'MAERSK SINGAPORE PTE LTD', 'MYU045', 'SG51LGLC75', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (60, '2026-05-22', 'MINV2026050004', 'ALAN YONG', 'HOURLY (MALAYSIA)', 'REQUESTOR: KELVIN LIN
UID: YKL017
COST CENTRE: 517
PAX: 1 PAX
JW MARRIOTT HOTEL SINGAPORE SOUTH BEACH - WISMA A - JW MARRIOTT HOTEL SINGAPORE SOUTH BEACH
DRIVER: ALAN YONG (SCM79U)
TIME: 0900 - 1553', '09:00', '15:53', '6h 53m', 7, 90, 630, 540, 90, NULL, NULL, 'KELVIN LIN', 'APM TERMINALS MANAGEMENT (SINGAPORE) PTE LTD', 'YKL017', '517', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (61, '2026-05-22', 'MINV2026050003/ MSR2026050002', 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: ANDREW RAMSDALE
UID: ARA645
COST CENTRE: GB63F150 
AIRPORT T1 (BA11) - FRASER PLACE PUTERI HARBOUR 
PAX: 2 PAX
DRIVER: SEAH BOON HENG (SNW3810Z)', '16:18', '18:57', '2h 39m', 1, 220, 220, 200, 20, 'CREDIT CARD PAYMENT NET RECEIVED 234.26', NULL, 'ANDREW RAMSDALE', 'MAERSK BRITAIN ', 'ARA645', 'GB63F150', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (62, '2026-05-26', 'MINV2026050005', 'WANG LIN', 'TRANSFER (LOCAL)', 'REQUESTOR: MELINDA TAY
UID: MTA220
COST CENTRE: SG513GMA00
PAX: 30 PAX
PLQ 1 - 15 BENOI SECTOR
DRIVER: WANG LIN (PD2473U)', '09:15', NULL, '-', 1, 185, 185, 120, 65, NULL, NULL, 'MELINDA TAY', 'MAERSK SINGAPORE PTE LTD', 'MTA220', 'SG513GMA00 ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (63, '2026-05-26', 'MINV2026050005', 'WANG LIN', 'TRANSFER (LOCAL)', 'REQUESTOR: MELINDA TAY
UID: MTA220
COST CENTRE: SG513GMA00
PAX: 30 PAX
15 BENOI SECTOR - PLQ 1
DRIVER: WANG LIN (PD2473U)', '11:45', NULL, '-', 1, 185, 185, 120, 65, NULL, NULL, 'MELINDA TAY', 'MAERSK SINGAPORE PTE LTD', 'MTA220', 'SG513GMA00 ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (64, '2026-06-10', 'MINV2026060001', 'ELVIN SAI', 'HOURLY (MALAYSIA)', 'REQUESTOR: CHENG CHIN LEE
UID: CCH455
COST CENTRE: SG516GMED6
PLQ 1 - WISMA A - HOC - TPP GATE B - HOC -  BUKIT INDAH AEON - PLQ 1
PAX: 3 PAX
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0800 - 1556', '08:00', '15:56', '7h 56m', 8, 90, 720, 640, 80, NULL, NULL, 'CHENG CHIN LEE ', 'MAERSK SINGAPORE PTE LTD', 'CCH455', 'SG516GMED6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (65, '2026-06-11', 'MINV2026060001', 'KENT CHAN', 'TRANSFER (LOCAL)', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG517GMA00
PLQ 1 - VIOLET OON SINGAPORE @ DEMPSEY
PAX: 9 PAX 
DRIVER: KENT CHAN (PD5655S)', '17:30', '18:03', '0h 33m', 1, 70, 70, 55, 15, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (66, '2026-06-15', 'MINV2026060001', 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER)(MPV)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
PLQ 1 - BMW ASIA TECHNOLOGY CENTRE SDN BHD
PAX: 4 PAX
DRIVER: SEAH BOON HENG (SNW3810Z)', '07:30', '09:14', '1h 44m', 1, 220, 220, 200, 20, 'DUE TO MISQUOTE, HAD TO PAY DRIVER  20 ( 2 BLOCKS)', NULL, 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (67, '2026-06-15', 'MINV2026060001', 'SEAH BOON HENG', 'HOURLY (MALAYSIA)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
BMW ASIA TECHNOLOGY CENTRE SDN BHD - PLQ 1
PAX: 1 PAX
DRIVER: SEAH BOON
TIME: 1215 - 1415', '12:15', '14:15', '2h 0m', 3, 70, 210, 210, NULL, 'DUE TO MISQUOTE, HAD TO PAY DRIVER 30 (ADDITIONAL STOP) ', NULL, 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (68, '2026-06-16', 'MINV2026060004', 'ALAN YONG', 'HOURLY (LOCAL)', 'REQUESTOR: SHERYL SILVA
UID: SSI465
COST CENTRE: 110
PLQ 1 - THE SHOPPES AT MBS - GRAND MERCURE ROXY HOTEL -  SWISSOTEL THE STAMFORD - GRAND MERCURE ROXY HOTEL - 36 PURVIS STREET - GRAND MERCURE ROXY HOTEL -  SWISSOTEL THE STAMFORD 
PAX: 4 PAX
DRIVER: ALAN YONG (SCM79U)
TIME:1200-2230', '12:00', '22:30', '10h 30m', 11, 70, 770, 770, NULL, NULL, NULL, 'SHERYL SILVA', 'APM TERMINALS SINGAPORE PTE LTD', 'SSI465', '110', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (69, '2026-06-18', 'MINV2026060001', 'CHAY YU SIANG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: MARGARET ONG
UID: MON008
COST CENTRE: SG51GGMEA6
5 SEMBAWANG CRESCENT SKYPARK RESIDENCE SINGAPORE 757095 -  DECATHLON LOGISTICS MALAYSIA SDN.
PAX: 1 PAX
DRIVER: CHAY YU SIANG (SNF1866P)', '08:00', '09:45', '1h 45m', 1, 150, 150, 120, 30, NULL, NULL, 'MARGARET ONG', 'MAERSK SINGAPORE PTE LTD', 'MON008', 'SG51GGMEA6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (70, '2026-06-18', 'MINV2026060001', 'CHAY YU SIANG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: MARGARET ONG
UID: MON008
COST CENTRE: SG51GGMEA6
DECATHLON LOGISTICS MALAYSIA SDN - 5 SEMBAWANG CRESCENT SKYPARK RESIDENCE SINGAPORE 757095
PAX: 1 PAX
DRIVER: CHAY YU SIANG (SNF1866P)', '16:30', '17:25', '0h 55m', 1, 150, 150, 120, 30, NULL, NULL, 'MARGARET ONG', 'MAERSK SINGAPORE PTE LTD', 'MON008', 'SG51GGMEA6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (71, '2026-06-22', 'MINV2026060001', 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: SARINDAR PAL KAUR 
UID: SPK046
COST CENTRE: SG51GGMEA6
2 PRIMROSE AVENUE, SINGAPORE 467236 - D37 MAERSK WAREHOUSE
PAX: 1 PAX
DRIVER: SEAH BOON HENG (SNW3810Z)', '07:00', '08:36', '1h 36m', 1, 150, 150, 120, 30, NULL, NULL, 'SARINDAR PAL KAUR ', 'MAERSK SINGAPORE PTE LTD', 'SPK046 ', 'SG51GGMEA6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (72, '2026-06-23', 'MINV2026060001', 'ELVIN SAI', 'HOURLY (MALAYSIA)', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG51GGMEA6
CHANGI AIRPORT TERMINAL 2 - TRINIDAD SUITES JOHOR - D37 MAERSK WAREHOUSE
PAX: JACOB ZACHARIAH, SURESH KUMAR RAJENDRAN 
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0610 - 1156', '06:10', '11:56', '5h 46m', 6, 90, 540, 480, 60, NULL, NULL, 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (73, '2026-06-23', 'MINV2026060005', 'ADRAIN HING', 'HOURLY (LOCAL)', 'REQUESTOR: MELINDA TAY
UID: MTA220
COST CENTRE: SG51MLFN01
PAX: DAN OSTERBERG, LISA MOK, ELVA ZHOU AND MELINDA TAY
FAIRMONT SINGAPORE - 15 BENOI SECTOR - 10 BULIM AVENUE - PLQ 1
DRIVER: ADRAIN HING (SPE751A)
TIME: 0850 - 1227', '08:50', '12:27', '3h 37m', 4, 70, 280, 200, 80, NULL, NULL, 'MELINDA TAY', 'MAERSK SINGAPORE PTE LTD', 'MTA220', 'SG513GMA00 ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (74, '2026-06-24', 'MINV2026060001', 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: SARINDAR PAL KAUR FROST
UID: SPK046
COST CENTRE: SG51GGMEA6
PAX: 1 PAX
D37 MAERSK WAREHOUSE - 2 PRIMROSE AVENUE, SINGAPORE 467236
DRIVER: SEAN BOON HENG (SNW3801Z)', '15:00', '16:18', '1h 18m', 1, 150, 150, 120, 30, NULL, NULL, 'SARINDAR PAL KAUR ', 'MAERSK SINGAPORE PTE LTD', 'SPK046 ', 'SG51GGMEA6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (75, '2026-06-24', 'MINV2026060003', 'ELVIN SAI', 'ARRIVAL (MEET & GREET)', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG517GMA00 
PAX: MARC ENGEL
CHANGI AIRPORT TERMINAL 2 (SQ193) - FAIRMONT SINGAPORE 
DRIVER: ELVIN SAI (SPC2260Y)', '23:00', '23:56', '0h 56m', 1, 90, 90, 80, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (76, '2026-06-24', 'MINV2026060003', 'ELVIN SAI', 'MIDNIGHT SURCHARGE (LOCAL) ', 'APPLIES FROM 2300 - 0700', '23:00', '23:56', '0h 56m', 1, 15, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (77, '2026-06-24', 'MINV2026060005', 'CRIST WONG', 'ARRIVAL (MEET & GREET)', 'REQUESTOR: MELINDA TAY
UID: MTA 220
COST CENTRE: SG51MLFN01
PAX: ROBERT ERNI & SUSANA ELVIRA
CHANGI AIRPORT TERMINAL 2 (SQ193) - FAIRMONT SINGAPORE 
DRIVER: CRIST WONG (SJN5885M)', '23:00', '23:56', '0h 56m', 1, 90, 90, 70, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (78, '2026-06-24', 'MINV2026060005', 'CRIST WONG', 'MIDNIGHT SURCHARGE (LOCAL) ', 'APPLIES FROM 2300 - 0700', '23:00', '23:56', '0h 56m', 1, 15, 15, NULL, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (79, '2026-06-24', 'MINV2026060002', 'ALAN YONG', 'ARRIVAL (MEET & GREET)', 'REQUESTOR: ANNIE CHIA 
UID: SKC010
COST CENTRE: SG01MLFN01
PAX: 1 PAX
CHANGI AIRPORT TERMINAL 3 (SQ193) - SHANGRI-LA SINGAPORE
DRIVER: ALAN YONG (SCM79U)', '23:00', NULL, '-', 1, 90, 90, 80, 10, NULL, NULL, 'ANNIE CHIA ', 'AP MOLLER SINGAPORE PTE LTD', 'SKC010', 'SG01MLFN01', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (80, '2026-06-24', 'MINV2026060002', 'ALAN YONG', 'MIDNIGHT SURCHARGE (LOCAL) ', 'APPLIES FROM 2300 - 0700', '23:00', '00:12', '1h 12m', 1, 15, 15, 15, NULL, NULL, NULL, 'ANNIE CHIA ', 'AP MOLLER SINGAPORE PTE LTD', 'SKC010', 'SG01MLFN01', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (81, '2026-06-25', 'MINV2026060002', 'ALAN YONG', 'HOURLY (LOCAL)', 'REQUESTOR: ANNIE CHIA 
UID: SKC010
COST CENTRE: SG01MLFN01
PAX: 2 PAX
SHANGRI-LA SINGAPORE - ISTANA - SHANGRI-LA SINGAPORE - PSA HORIZON - SHANGRI-LA SINGAPORE - 6 TAI SENG LINK - SHANGRI-LA SINGAPORE - CHANGI AIRPORT TERMINAL 3
DRIVER: ALAN YONG (SCM79U)
TIME:1005 - 2223', '10:05', '22:23', '12h 18m', 13, 70, 910, 780, 130, NULL, NULL, 'ANNIE CHIA ', 'AP MOLLER SINGAPORE PTE LTD', 'SKC010', 'SG01MLFN01', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (82, '2026-06-25', 'MINV2026060003', 'ELVIN SAI', 'TRANSFER (LOCAL)', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG517GMA00 
PAX: MARC ENGEL & SCOTT
FAIRMONT SINGAPORE - PLQ 1
DRIVER: ELVIN SAI (SPC2260Y)', '09:30', '09:48', '0h 18m', 1, 70, 70, 60, 10, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (83, '2026-06-25', 'MINV2026060003', 'ELVIN SAI', 'TRANSFER (LOCAL)', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG517GMA00 
PAX: MARC ENGEL
PLQ 1 - ACT SINGAPORE
DRIVER: ELVIN SAI (SPC2260Y)', '15:17', '16:15', '0h 58m', 1, 70, 70, 60, 10, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (84, '2026-06-25', 'MINV2026060005', 'CRIST WONG', 'TRANSFER (LOCAL)', 'REQUESTOR: MELINDA TAY
UID: MTA 220
COST CENTRE: SG51MLFN01
PAX: ROBERT ERNI & DAN OSTERBERG
FAIRMONT SINGAPORE - PLQ 1
DRIVER: CRIST WONG (SJN5885M)', '09:30', '09:48', '0h 18m', 1, 70, 70, 50, 20, NULL, NULL, 'MELINDA TAY', 'MAERSK SINGAPORE PTE LTD', 'MTA220', 'SG513GMA00 ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (85, '2026-06-25', 'MINV2026060005', 'CRIST WONG', 'TRANSFER (LOCAL)', 'REQUESTOR: MELINDA TAY
UID: MTA 220
COST CENTRE: SG51MLFN01
PAX: ROBERT ERNI
PLQ 1 - SHANGRI-LA SINGAPORE
DRIVER: CRIST WONG (SJN5885M)', '19:30', '19:56', '0h 26m', 1, 70, 70, 50, 20, NULL, NULL, 'MELINDA TAY', 'MAERSK SINGAPORE PTE LTD', 'MTA220', 'SG513GMA00 ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (86, '2026-06-25', 'MINV2026060005', 'CRIST WONG', 'HOURLY (LOCAL)', 'REQUESTOR: MELINDA TAY
UID: MTA 220
COST CENTRE: SG51MLFN01
PAX: ROBERT ERNI
SHANGRI-LA SINGAPORE - FARIMONT SINGAPORE
DRIVER: CRIST WONG (SJN5885M)
TIME: 2100 - 2210', '21:00', '22:10', '1h 10m', 2, 70, 140, 100, 40, NULL, NULL, 'MELINDA TAY', 'MAERSK SINGAPORE PTE LTD', 'MTA220', 'SG513GMA00 ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (87, '2026-06-25', 'MINV2026060006', 'ZEKE LEE ', 'HOURLY (LOCAL)', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: SUSANA ELVIRA
FAIRMONT SINGAPORE - WG ll - PLQ 1
DRIVER: ZEKE LEE (SNV6939X)
TIME: 0945 - 1305', '09:45', '13:05', '3h 20m', 4, 70, 280, 50, 230, NULL, NULL, 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (88, '2026-06-25', 'MINV2026060006', 'ZEKE LEE ', 'DEPARTURE', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: SUSANA ELVIRA
PLQ 1 - CHANGI AIRPORT TERMINAL 3 (SQ388)
DRIVER: ZEKE LEE (SNV6939X)', '20:10', '20:27', '0h 17m', 1, 80, 80, 60, 20, NULL, NULL, 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (89, '2026-06-26', 'MINV2026060003', 'ELVIN SAI', 'HOURLY (LOCAL)', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG517GMA00 
PAX: MARC ENGEL & SCOTT
HOLLAND RESIDENCE - FAIRMONT SINGAPORE - WG l
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0830 - 0930', '08:30', '09:30', '1h 0m', 2, 70, 140, 120, 20, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (90, '2026-06-26', 'MINV2026060003', 'ELVIN SAI', 'DEPARTURE', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG517GMA00 
PAX: MARC ENGEL
FAIRMONT SINGAPORE - CHANGI AIRPORT TERMINAL 1 (BA12)
DRIVER: ELVIN SAI (SPC2260Y)', '20:45', '21:13', '0h 28m', 1, 80, 80, 70, 10, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (91, '2026-06-26', 'MINV2026060003', 'ELVIN SAI', 'WAITING CHARGE (15 MINS/BLOCK) ', 'REQUESTOR: DELPHINE CHIN 
UID: DCH385
COST CENTRE: SG517GMA00 
PAX: MARC ENGEL
FAIRMONT SINGAPORE - CHANGI AIRPORT TERMINAL 1 (BA12)
DRIVER: ELVIN SAI (SPC2260Y)', '20:45', '21:13', '0h 28m', 1, 15, 15, 15, NULL, NULL, NULL, 'DELPHINE CHIN ', 'MAERSK SINGAPORE PTE LTD', 'DCH385', 'SG517GMA00  ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (92, '2026-06-26', 'MINV2026060005', 'CRIST WONG', 'HOURLY (LOCAL)', 'REQUESTOR: MELINDA TAY
UID: MTA 220
COST CENTRE: SG51MLFN01
PAX: ROBERT ERNI
FAIRMONT SINGAPORE - WG l - PLQ 1 - CAPITAL SPRING - FAIRMONT SINGAPORE - CHANGI AIRPORT TERMINAL 2 (LX177)
DRIVER: CRIST WONG (SJN5885M)
TIME: 0900 - 2119', '09:00', '21:19', '12h 19m', 13, 70, 910, 650, 260, NULL, NULL, 'MELINDA TAY', 'MAERSK SINGAPORE PTE LTD', 'MTA220', 'SG513GMA00 ', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (93, '2026-06-26', 'MINV2026060001', 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: EUNICE LENG 
UID: QWL002
COST CENTRE: SG51LGLEK6
PAX: 1 PAX
206 SERANGOON CENTRAL S550206 - TPP GATE B 
DRIVER: SEAH BOON HENG (SNW3810Z)', '07:00', '08:15', '1h 15m', 1, 150, 150, 120, 30, NULL, NULL, 'EUNICE LENG ', 'MAERSK SINGAPORE PTE LTD', 'QWL002', 'SG51LGLEK6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (94, '2026-07-01', NULL, 'ALAN YONG', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: SARINDAR PAL KAUR FROST
UID: SPK046
COST CENTRE: SG51GGMEA6
PAX: 3 PAX
33 SIMEI STREET 4, TROPICAL SPRING CONDO - 38 SALAM WALK SINGAPORE 467179 - 2 PRIMROSE AVENUE, SINGAPORE 467236 - D37 MAERSK WAREHOUSE - 2 PRIMROSE AVENUE, SINGAPORE 467236 - 38 SALAM WALK SINGAPORE 467179 - 33 SIMEI STREET 4, TROPICAL SPRING CONDO 
DRIVER: ALAN YONG (SCM79U)
TIME: 0710 - 1641 ', '07:10', '16:41', '9h 31m', 10, 90, 900, 800, 100, NULL, 'PAID', 'SARINDAR PAL KAUR ', 'MAERSK SINGAPORE PTE LTD', 'SPK046 ', 'SG51GGMEA6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (95, '2026-07-03', NULL, 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER) - SALOON', 'REQUESTOR: EUNICE LENG 
UID: QWL002
COST CENTRE: SG51LGLEK6
PAX: 1 PAX
 D37 MAERSK WAREHOUSE - 206 SERANGOON CENTRAL S550206 
DRIVER: SEAH BOON HENG (SNW3810Z)', '16:00', '17:29', '1h 29m', 1, 150, 150, 120, 30, NULL, 'PAID', 'EUNICE LENG ', 'MAERSK SINGAPORE PTE LTD', 'QWL002', 'SG51LGLEK6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (96, '2026-07-03', NULL, 'SEAH BOON HENG', 'WAITING TIME - MALAYSIA', 'REQUESTOR: EUNICE LENG 
UID: QWL002
COST CENTRE: SG51LGLEK6
PAX: 1 PAX
 D37 MAERSK WAREHOUSE - 206 SERANGOON CENTRAL S550206 
DRIVER: SEAH BOON HENG (SNW3810Z)', '16:00', '16:16', '0h 16m', NULL, 25, 25, 10, 15, NULL, 'PAID', 'EUNICE LENG ', 'MAERSK SINGAPORE PTE LTD', 'QWL002', 'SG51LGLEK6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (97, '2026-07-06', NULL, 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER) - SALOON', 'REQUESTOR: EUNICE LENG 
UID: QWL002
COST CENTRE: SG51LGLEK6
PAX: 1 PAX
206 SERANGOON CENTRAL S550206 - D37 MAERSK WAREHOUSE
DRIVER: SEAH BOON HENG (SNW3810Z)', '07:00', NULL, '-', 1, 150, 150, 120, 30, NULL, 'PAID', 'EUNICE LENG ', 'MAERSK SINGAPORE PTE LTD', 'QWL002', 'SG51LGLEK6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (98, '2026-07-07', NULL, 'BEE ', 'TRANSFER (LOCAL) - MINI VAN', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: 9
SWISSÔTEL THE STAMFORD SINGAPORE - PLQ 1
DRIVER: BEE (PC3927B)', '08:15', '08:46', '0h 31m', 1, 70, 70, 60, 10, NULL, 'PAID', 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (99, '2026-07-07', NULL, 'ALAN', 'TRANSFER (LOCAL) - MINI BUS', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: 16
PLQ 1 - FAIRMONT SINGAPORE
DRIVER: ALAN (PC2632H)', '18:30', '18:57', '0h 27m', 1, 130, 130, 90, 40, NULL, 'PAID', 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (100, '2026-07-08', NULL, 'BEE ', 'TRANSFER (LOCAL) - MINI VAN', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: 9
SWISSÔTEL THE STAMFORD SINGAPORE - PLQ 1
DRIVER: BEE (PC3927B)', '08:45', '09:05', '0h 20m', 1, 70, 70, 50, 20, NULL, 'PAID', 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (101, '2026-07-08', NULL, 'ALAN', 'TRANSFER (LOCAL) - MINI BUS', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: 16
PLQ 1 - 692 GEYLANG ROAD (JIAK DURAIN MAI)
DRIVER: ALAN (PC2632H)', '18:15', '18:50', '0h 35m', 1, 130, 130, 90, 40, NULL, 'PAID', 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (102, '2026-07-08', NULL, 'ALAN', 'WAITING TIME - LOCAL', 'GUESTS BOARDED THE BUS AT 1836', '18:16', '18:36', '0h 20m', NULL, 20, 20, NULL, 20, NULL, NULL, 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (103, '2026-07-09', NULL, 'ELVIN SAI', 'TRANSFER (LOCAL)', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: 4
PLQ 1 - WORLD GATEWAY l (GATE 1), 10 BULIM AVENUE
DRIVER: ELVIN SAI (SPC2260Y)', '08:50', '09:27', '0h 37m', 1, 90, 90, 60, 30, NULL, 'PAID', 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (104, '2026-07-09', NULL, 'KHAIRUL', 'TRANSFER (LOCAL)', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: 9
SWISSÔTEL THE STAMFORD SINGAPORE - WORLD GATEWAY l (GATE 1), 10 BULIM AVENUE
DRIVER: KHAIRUL (PD6677Y)', '08:50', '09:26', '0h 36m', 1, 90, 90, 60, 30, NULL, 'PAID', 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (105, '2026-07-09', NULL, 'MR TAN ', 'TRANSFER (LOCAL) - MINI BUS', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: 16
WORLD GATEWAY l (GATE 1), 10 BULIM AVENUE - WORLD GATEWAY ll (GATE 2), 15 BENOI SECTOR
DRIVER: TAN (PC501R)', '14:30', '15:30', '1h 0m', 1, 130, 130, 90, 40, NULL, 'PAID', 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (106, '2026-07-09', NULL, 'MR TAN ', 'WAITING TIME - LOCAL', 'GUESTS BOARDED THE BUS AT 1458', '14:46', '14:58', '0h 12m', 1, 20, 20, NULL, 20, NULL, 'PAID', 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (107, '2026-07-09', NULL, 'MR TAN ', 'HOURLY DISPOSAL (LOCAL) - MINI BUS', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: 16
WORLD GATEWAY ll (GATE 2), 15 BENOI SECTOR - PLQ 1 
DRIVER: TAN (PC501R)
TIME: 1630 - 1750
(CONVERTED TO CHARTERED AS 30 MINS OF WAITING TIME)', '16:30', '17:50', '1h 20m', 2, 90, 180, 220, -40, '23 SEATER MORE THAN 30 MINS CHARGE ADDITIONAL 1 WAY ', 'PAID', 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (108, '2026-07-09', NULL, 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER) - SALOON', 'REQUESTOR: EUNICE LENG 
UID: QWL002
COST CENTRE: SG51LGLEK6
PAX: 1 PAX
D37 MAERSK WAREHOUSE - 206 SERANGOON CENTRAL S550206
DRIVER: SEAH BOON HENG (SNW3810Z)', '16:00', '17:14', '1h 14m', 1, 150, 150, 120, 30, NULL, 'PAID', 'EUNICE LENG ', 'MAERSK SINGAPORE PTE LTD', 'QWL002', 'SG51LGLEK6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (109, '2026-07-09', NULL, 'SEAH BOON HENG', 'CANCELLATION FEE (100%)', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG51LGLC75
FRASER PLACE PUTERI HARBOUR -  PLQ
PAX: SALLY JEAN BYRNE
DRIVER: SEAH BOON HENG (SNW3810Z)', NULL, NULL, '-', NULL, 170, 170, 140, 30, NULL, 'PAID', 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (110, '2026-07-09', NULL, 'ELVIN SAI', 'CANCELLATION FEE (50%)', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG51LGLC75
PLQ - FRASER PLACE PUTERI HARBOUR
PAX: SALLY JEAN BYRNE
DRIVER: ELVIN SAI (SPC2260Y)', NULL, NULL, '-', NULL, 85, 85, 90, -5, 'ELVIN 90', 'PAID', 'LISHAN KHOO', 'MAERSK SINGAPORE PTE LTD', 'LKH041', 'SG51BGLEC8', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (111, '2026-07-10', NULL, 'ELVIN SAI', 'TRANSFER (LOCAL) - MPV/ALPHARD', 'REQUESTOR: LORRAINE WONG
UID: LWO028
COST CENTRE: SG51YGMA64
PAX: 5 PAX
SWISSÔTEL THE STAMFORD SINGAPORE - PLQ 1
DRIVER: ELVIN SAI (SPC2260Y)', '08:15', '08:37', '0h 22m', 1, 70, 70, 60, 10, NULL, 'PAID', 'LORRAINE WONG ', 'MAERSK SINGAPORE PTE LTD', 'LWO028', 'SG517GMEM6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (112, '2026-07-13', NULL, 'CHAY YU SIANG', 'CANCELLATION FEE (50%)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
90 TANGLIN HALT ROAD - MAPLETREE WAREHOUSE
PAX: 1 PAX
DRIVER: CHAY YU SIANG (SNF1866P)', NULL, NULL, '-', NULL, 75, 75, NULL, 75, NULL, NULL, 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (113, '2026-07-13', NULL, 'CHAY YU SIANG', 'CANCELLATION FEE (50%)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
MAPLETREE WAREHOUSE - PLQ 1
PAX: 1 PAX
DRIVER: CHAY YU SIANG (SNF1866P)', NULL, NULL, '-', NULL, 75, 75, 50, 25, 'TRIP WAS CANCELLED $50 TO DRIVER OUT OF GOODWILL', 'PAID', 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (114, '2026-07-13', NULL, 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER) - SALOON', 'REQUESTOR: EUNICE LENG 
UID: QWL002
COST CENTRE: SG51LGLEK6
PAX: 1 PAX
206 SERANGOON CENTRAL S550206 - D37 MAERSK WAREHOUSE
DRIVER: SEAH BOON HENG (SNW3810Z)', '07:00', '08:07', '1h 7m', 1, 150, 150, 120, 30, NULL, 'PAID', 'EUNICE LENG ', 'MAERSK SINGAPORE PTE LTD', 'QWL002', 'SG51LGLEK6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (115, '2026-07-13', NULL, 'ALAN YONG', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: STEVE CHEUNG
UID: KHC005
COST CENTRE: SG51BMPEE2
PAX: 5 PAX
HOLIDAY INN EXPRESS CLARKE QUAY - D37 MAERSK WAREHOUSE - HOLIDAY INN EXPRESS CLARKE QUAY
DRIVER: ALAN YONG (SCM79U)
TIME: 0800 - 1541 ', '08:00', '15:41', '7h 41m', 8, 90, 720, 640, 80, NULL, NULL, 'STEVE CHEUNG', 'MAERSK SINGAPORE PTE LTD', 'KHC005', 'SG51BMPEE2', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (116, '2026-07-13', NULL, 'ELVIN SAI', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: STEVE CHEUNG
UID: KHC005
COST CENTRE: SG51BMPEE2
PAX: 4 PAX
HOLIDAY INN EXPRESS CLARKE QUAY - D37 MAERSK WAREHOUSE - HOLIDAY INN EXPRESS CLARKE QUAY
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0800 - 1541 ', '08:00', '15:41', '7h 41m', 8, 90, 720, 640, 80, NULL, 'PAID', 'STEVE CHEUNG', 'MAERSK SINGAPORE PTE LTD', 'KHC005', 'SG51BMPEE2', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (117, '2026-07-14', NULL, 'ALAN YONG', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: STEVE CHEUNG
UID: KHC005
COST CENTRE: SG51BMPEE2
PAX: 4 PAX
HOLIDAY INN EXPRESS CLARKE QUAY - D37 MAERSK WAREHOUSE - HOLIDAY INN EXPRESS CLARKE QUAY
DRIVER: ALAN YONG (SCM79U)
TIME: 0800 - 1724', '08:00', '17:24', '9h 24m', 10, 90, 900, 800, 100, NULL, NULL, 'STEVE CHEUNG', 'MAERSK SINGAPORE PTE LTD', 'KHC005', 'SG51BMPEE2', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (118, '2026-07-14', NULL, 'WONG NGEE YEW', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: STEVE CHEUNG
UID: KHC005
COST CENTRE: SG51BMPEE2
PAX: 4 PAX
HOLIDAY INN EXPRESS CLARKE QUAY - D37 MAERSK WAREHOUSE - HOLIDAY INN EXPRESS CLARKE QUAY
DRIVER: WONG NGEE YEW (SNL1880R)
TIME: 0800 - 1724', '08:00', '17:24', '9h 24m', 10, 90, 900, 550, 350, '55 MIN 8', 'PAID', 'STEVE CHEUNG', 'MAERSK SINGAPORE PTE LTD', 'KHC005', 'SG51BMPEE2', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (119, '2026-07-14', NULL, 'NICHOLAS WONG', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG517GMEB3
PAX: ELAINE WONG, FLORA PINTUSOONTORN
PLQ 1 - D37 MAERSK WAREHOUSE 
DRIVER: NICHOLAS WONG (SPB5548D)
TIME: 0745 - 1600', '07:45', '16:00', '8h 15m', 8, 90, 720, 440, 280, '55 MIN 8', 'PAID', 'ELAINE LOW', 'MAERSK SINGAPORE PTE LTD', 'EAD044', 'SG517GMEB3', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (120, '2026-07-14', 'MINV2026070001', 'ELVIN SAI', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: JAY ZHANG 
UID: JJZ104
COST CENTRE: SG53DGMEH7 
PLQ - 6 TAI SENG LINK (C&K) - YOUKEEXO NUSAJAYA EKO BOTANI - OMO PASTRY - 17 JLN PERDAGANGAN - 682C WOODLANMDS DRIVE 73 SINGAPORE - 405 SERANGOON AVENUE 1 SINGAPORE 550405 - 6 TAI SENG LINK
PAX: 3 PAX
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 1130 - 1737', '10:51', '17:37', '6h 46m', 7, 90, 630, 560, 70, NULL, 'PAID', 'JAY ZHANG', 'MAERSK LOGISTICS & SERVICES SINGAPORE PTE LTD', 'JJZ104', 'SG53DGMEH7', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (121, '2026-07-15', NULL, 'ALAN YONG', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: STEVE CHEUNG
UID: KHC005
COST CENTRE: SG51BMPEE2
PAX: 4 PAX
HOLIDAY INN EXPRESS CLARKE QUAY - D37 MAERSK WAREHOUSE - HOLIDAY INN EXPRESS CLARKE QUAY - OASIA HOTEL - CHANGI AIRPORT TERMINAL 3
DRIVER: ALAN YONG (SCM79U)
TIME: 0745 - 1655', '07:45', '16:55', '9h 10m', 9, 90, 810, 720, 90, NULL, NULL, 'STEVE CHEUNG', 'MAERSK SINGAPORE PTE LTD', 'KHC005', 'SG51BMPEE2', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (122, '2026-07-15', NULL, 'WONG NGEE YEW', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: STEVE CHEUNG
UID: KHC005
COST CENTRE: SG51BMPEE2
PAX: 4 PAX
HOLIDAY INN EXPRESS CLARKE QUAY - PLQ 1 - US EMBASSY - PLQ 1 - HOLIDAY INN EXPRESS CLARKE QUAY - CHANGI AIRPORT TERMINAL 3
DRIVER: WONG NGEE YEW (SNL1880R)
TIME: 0745 - 1650', '07:45', '16:56', '9h 11m', 9, 90, 810, 495, 315, '55 MIN 8', 'PAID', 'STEVE CHEUNG', 'MAERSK SINGAPORE PTE LTD', 'KHC005', 'SG51BMPEE2', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (123, '2026-07-15', NULL, 'ELVIN SAI', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: LISHAN KHOO
UID: LKH041
COST CENTRE: SG517GMEB3
PAX: ELAINE WONG, FLORA PINTUSOONTORN
33 SEMEI STREET 4 SINGAPORE 529878 - 38 SALAM WALK SINGAORE 467179  - D37 MAERSK WAREHOUSE - 38 SALAM WALK SINGAORE 467179 
DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0745 - 1339 ', '07:45', '13:39', '5h 54m', 6, 90, 540, 480, 60, NULL, 'PAID', 'STEVE CHEUNG', 'MAERSK SINGAPORE PTE LTD', 'KHC005', 'SG51BMPEE2', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (124, '2026-07-16', NULL, 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER) - SALOON', 'REQUESTOR: EUNICE LENG 
UID: QWL002
COST CENTRE: SG51LGLEK6
PAX: 1 PAX
 D37 MAERSK WAREHOUSE - 206 SERANGOON CENTRAL S550206 
DRIVER: SEAH BOON HENG (SNW3810Z)', '16:00', '17:12', '1h 12m', 1, 150, 150, 120, 30, NULL, NULL, 'EUNICE LENG ', 'MAERSK SINGAPORE PTE LTD', 'QWL002', 'SG51LGLEK6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (125, '2026-07-21', NULL, 'ALAN YONG', 'HOURLY DISPOSAL (LOCAL) - MPV/ALPHARD', 'REQUESTOR: MICHELLE LIM 
UID: MYU045
COST CENTRE: SG51ZGMES7
DELL GLOBAL B.V - PLQ - PANASONIC SINGAPORE - APPLIED MATERIAL (SOC) - PLQ - GARIBALDI ITALIAN RESTAURANT
PAX: 4 PAX
DRIVER: ALAN YONG (SCM79U)
TIME: 0815 - 2012 ', '08:15', '20:12', '11h 57m', 12, 70, 840, 840, NULL, NULL, NULL, 'MICHELLE LIM', 'MAERSK SINGAPORE PTE LTD', 'MYU045', 'SG51LGLC75', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (126, '2026-07-22', NULL, 'ALAN YONG', 'TRANSFER (LOCAL)', 'REQUESTOR: MICHELLE LIM 
UID: MYU045
COST CENTRE: SG51ZGMES7
PLQ - SIEMENS CENTRE
PAX: 3 PAX
DRIVER: ALAN YONG (SCM79U)', '14:15', '14:56', '0h 41m', 1, 70, 70, 70, NULL, NULL, NULL, 'MICHELLE LIM', 'MAERSK SINGAPORE PTE LTD', 'MYU045', 'SG51LGLC75', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (127, '2026-07-22', NULL, 'ALAN YONG', 'TRANSFER (LOCAL)', 'REQUESTOR: MICHELLE LIM 
UID: MYU045
COST CENTRE: SG51ZGMES7
SIEMENS CENTRE - JW MARRIOTT HOTTEL 
PAX: 3 PAX
DRIVER: ALAN YONG (SCM79U)', '15:45', '16:04', '0h 19m', 1, 70, 70, 70, NULL, NULL, NULL, 'MICHELLE LIM', 'MAERSK SINGAPORE PTE LTD', 'MYU045', 'SG51LGLC75', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (128, '2026-07-22', NULL, 'CHAY YU SIANG', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
90 TANGLIN HALT ROAD - MAPLETREE WAREHOUSE
PAX: 1 PAX
DRIVER: CHAY YU SIANG (SNF1866P)', '11:30', '13:23', '1h 53m', 1, 230, 230, 150, 80, 'LAST MIN ACTIVATION', NULL, 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (129, '2026-07-22', NULL, 'ELVIN SAI', 'TRANSFER (CROSS BORDER)(SALOON)', 'REQUESTOR: ROGER NG 
UID: RNG019
COST CENTRE: SG51CTHEJ9 
MAPLETREE WAREHOUSE - 90 TANGLIN HALT ROAD
PAX: 1 PAX
DRIVER: ELVIN SAI (SPC2260Y)', '16:30', '17:25', '0h 55m', 1, 230, 230, 220, 10, 'LAST MIN ACTIVATION', NULL, 'ROGER NG', 'MAERSK SINGAPORE PTE LTD', 'RNG019', 'SG51CTHEJ9', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (130, '2026-07-22', NULL, 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER) - SALOON', 'REQUESTOR: EUNICE LENG 
UID: QWL002
COST CENTRE: SG51LGLEK6
PAX: 2 PAX
 PLQ 1 - D37 MAERSK WAREHOUSE 
DRIVER: SEAH BOON HENG (SNW3810Z)', '07:15', '09:13', '1h 58m', 1, 150, 150, 120, 30, NULL, NULL, 'EUNICE LENG ', 'MAERSK SINGAPORE PTE LTD', 'QWL002', 'SG51LGLEK6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (131, '2026-07-23', NULL, 'ALAN YONG', 'HOURLY DISPOSAL (MALAYSIA) - MPV/ALPHARD', 'REQUESTOR: MICHELLE LIM 
UID: MYU045
COST CENTRE: SG51ZGMES7
JW MARRIOTT HOTEL - BMW SENAI  - WISMA A - D37 MAERSK WAREHOUSE - JW MARRIOT
PAX: 5 PAX
DRIVER: ALAN YONG (SCM79U)
TIME: 0830 - 1820', '08:30', '18:20', '9h 50m', 10, 90, 900, 900, NULL, NULL, NULL, 'MICHELLE LIM', 'MAERSK SINGAPORE PTE LTD', 'MYU045', 'SG51LGLC75', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (132, '2026-07-24', NULL, 'SEAH BOON HENG', 'TRANSFER (CROSS BORDER) - SALOON', 'REQUESTOR: EUNICE LENG 
UID: QWL002
COST CENTRE: SG51LGLEK6
PAX: 2 PAX
 D37 MAERSK WAREHOUSE - PLQ 1 
DRIVER: SEAH BOON HENG (SNW3810Z)', '16:00', NULL, '-', 1, 150, 150, 120, 30, NULL, NULL, 'EUNICE LENG ', 'MAERSK SINGAPORE PTE LTD', 'QWL002', 'SG51LGLEK6', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (133, '2026-07-24', NULL, 'ELVIN SAI', 'CANCELLATION FEE (50%)', 'REQUESTOR: MICHELLE LIM 
UID: MYU045
COST CENTRE: SG51ZGMES7
JW MARRIOTT HOTEL - DOF SUBSEA - BBC CHARTERING - PLQ  - CONRAD SINGAPORE ORCHARD - CHANGI  AIRPORT TERMINAL 2 (LH769)
PAX: 3 PAX
DRIVER: DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0945 - 21', '09:45', '13:45', '4h 0m', 2, 70, 140, 120, 20, NULL, NULL, 'MICHELLE LIM', 'MAERSK SINGAPORE PTE LTD', 'MYU045', 'SG51LGLC75', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (134, '2026-07-24', NULL, 'ELVIN SAI', 'HOURLY (LOCAL)', 'REQUESTOR: MICHELLE LIM 
UID: MYU045
COST CENTRE: SG51ZGMES7
JW MARRIOTT HOTEL - PARAGON - PLQ 1 - PARAGON - PLQ 1 - JW MARRIOT HOTE)
PAX: 1 PAX
DRIVER: DRIVER: ELVIN SAI (SPC2260Y)
TIME: 0945 - 22', '12:35', NULL, '-', NULL, 70, NULL, NULL, NULL, NULL, NULL, 'MICHELLE LIM', 'MAERSK SINGAPORE PTE LTD', 'MYU045', 'SG51LGLC75', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (135, '2026-07-24', NULL, 'ELVIN SAI', 'DEPARTURE', 'REQUESTOR: MICHELLE LIM 
UID: MYU045
COST CENTRE: SG51ZGMES7
  CONRAD SINGAPORE ORCHARD - CHANGI TERMINAL 2 (LH769)
PAX: 1 PAX
DRIVER: DRIVER: ELVIN SAI (SPC2260Y)', '20:30', NULL, '-', NULL, 80, 80, 70, 10, NULL, NULL, 'MICHELLE LIM', 'MAERSK SINGAPORE PTE LTD', 'MYU045', 'SG51LGLC75', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (136, '2026-08-11', NULL, NULL, 'TRANSFER (CROSS BORDER)(MPV)', 'REQUESTOR: PATRICK LOI
UID: PWL006
COST CENTRE: SG51CGMEI1
PARKROYAL COLLECTION MARINA BAY - WISMA A
PAX: 6 PAX
DRIVER:  ()', '08:00', NULL, '-', 1, 170, 170, 160, 10, NULL, NULL, 'PATRICK LOI', 'MAERSK SINGAPORE PTE LTD', 'PWL006', ' SG51CGMEI1', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (137, '2026-08-11', NULL, NULL, 'TRANSFER (CROSS BORDER)(MPV)', 'REQUESTOR: PATRICK LOI
UID: PWL006
COST CENTRE: SG51CGMEI1
PARKROYAL COLLECTION MARINA BAY - WISMA A
PAX: 6 PAX
DRIVER:  ()', '08:00', NULL, '-', 1, 170, 170, 160, 10, NULL, NULL, 'PATRICK LOI', 'MAERSK SINGAPORE PTE LTD', 'PWL006', ' SG51CGMEI1', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (138, '2026-08-11', NULL, NULL, 'TRANSFER (CROSS BORDER)(MPV)', 'REQUESTOR: PATRICK LOI
UID: PWL006
COST CENTRE: SG51CGMEI1
WISMA A - PARKROYAL COLLECTION MARINA BAY 
PAX: 6 PAX
DRIVER:  ()', '08:00', NULL, '-', 1, 170, 170, 160, 10, NULL, NULL, 'PATRICK LOI', 'MAERSK SINGAPORE PTE LTD', 'PWL006', ' SG51CGMEI1', NULL);
INSERT INTO jobs (id, date, invoice, driver, "jobType", details, "startTime", "endTime", duration, qty, "unitCost", cost, "driverPayout", "coyFund", remarks, "paymentStatus", "hostName", company, uid, "costCentre", vehicle) VALUES (139, '2026-08-11', NULL, NULL, 'TRANSFER (CROSS BORDER)(MPV)', 'REQUESTOR: PATRICK LOI
UID: PWL006
COST CENTRE: SG51CGMEI1
WISMA A - PARKROYAL COLLECTION MARINA BAY 
PAX: 6 PAX
DRIVER:  ()', '08:00', NULL, '-', 1, 170, 170, 160, 10, NULL, NULL, 'PATRICK LOI', 'MAERSK SINGAPORE PTE LTD', 'PWL006', ' SG51CGMEI1', NULL);

SELECT setval('jobs_id_seq', (SELECT COALESCE(MAX(id), 0) FROM jobs));
