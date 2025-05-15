-- Create the table for formations dataset
CREATE TABLE formations (
    formation VARCHAR PRIMARY KEY,
    series_epoch VARCHAR,
    system_period VARCHAR,
    erathem_era VARCHAR
);

-- Load data from CSV
COPY formations 
FROM 'outputs/formations_clean.csv' 
(header TRUE, delim ',', quote '"', escape '"', strict_mode false, ignore_errors true, null_padding true);


-- Create the table for localities 
CREATE TABLE localities (
    locno VARCHAR PRIMARY KEY,
    name VARCHAR,
    state VARCHAR,
    country VARCHAR,
    latitude1 VARCHAR,  
    longitude1 VARCHAR,
    locality_description VARCHAR,
    formation VARCHAR,  
    FOREIGN KEY (formation) REFERENCES formations(formation)  
);

-- Load data from CSV
COPY localities FROM 'outputs/localities_clean.csv' (header TRUE);

-- Create the table for specimens dataset
CREATE TABLE specimens (
    specno VARCHAR PRIMARY KEY,
    locno VARCHAR,
    field_no VARCHAR,
    taxon_full_name VARCHAR,
    element VARCHAR,
    portion VARCHAR,
    description VARCHAR,
    FOREIGN KEY (locno) REFERENCES localities(locno)
);

-- Load data from CSV
COPY specimens FROM 'outputs/specimens_clean.csv' (header TRUE);

-- Merge the tables
CREATE TABLE dinosaurs_data AS
SELECT 
    s.specno, 
    s.field_no, 
    s.taxon_full_name, 
    s.description,
    l.name AS locality_name, 
    l.state, 
    l.country, 
    f.formation, 
    f.series_epoch, 
    f.system_period, 
    f.erathem_era
FROM specimens s
JOIN localities l ON s.locno = l.locno
JOIN formations f ON l.formation = f.formation;