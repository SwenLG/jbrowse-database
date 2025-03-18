-- Subtable: Adapters
CREATE TABLE adapters (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50),
    fasta_uri VARCHAR(255),
    fai_uri VARCHAR(255),
    metadata_uri VARCHAR(255),
    gzi_uri VARCHAR(255)
);

-- Main Table: Assemblies
CREATE TABLE assemblies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    display_name VARCHAR(255),
    aliases TEXT[],
    sequence_track_id VARCHAR(100) NOT NULL
);

-- Subtable: Sequences
CREATE TABLE sequences (
    id SERIAL PRIMARY KEY,
    assembly_id INT REFERENCES assemblies(id),
    type VARCHAR(50),
    track_id VARCHAR(100),
    adapter_id INT REFERENCES adapters(id)
);

-- Subtable: Displays
CREATE TABLE displays (
    id SERIAL PRIMARY KEY,
    sequence_id INT REFERENCES sequences(id),
    type VARCHAR(50),
    display_id VARCHAR(100),
    renderer JSONB
);

-- Subtable: RefNameAliases
CREATE TABLE ref_name_aliases (
    id SERIAL PRIMARY KEY,
    assembly_id INT REFERENCES assemblies(id),
    ref_name VARCHAR(255),
    unique_id VARCHAR(50),
    aliases TEXT[]
);

-- Subtable: Track Adapters
CREATE TABLE track_adapters (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50),
    uri JSONB  -- Stores all URIs (e.g., gffGzLocation, bedGzLocation, etc.) as a JSON object
);

-- Main Table: Tracks
CREATE TABLE tracks (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50),
    track_id VARCHAR(255),
    name VARCHAR(255),
    assembly_id INT REFERENCES assemblies(id),
    category TEXT[],
    adapter_id INT REFERENCES track_adapters(id)
);

-- Subtable: Track Displays
CREATE TABLE track_displays (
    id SERIAL PRIMARY KEY,
    track_id INT REFERENCES tracks(id),
    type VARCHAR(50),
    display_id VARCHAR(255),
    renderer JSONB  -- Stores renderer details as JSON
);
