-- Assemblies

CREATE TABLE "Assemblies" (
    "Id" SERIAL PRIMARY KEY,                 -- Unique identifier for the assembly
    "name" TEXT NOT NULL,                    -- Assembly name
    "aliases" TEXT[],                        -- Array of aliases
    "sequence_type" TEXT NOT NULL,           -- Corresponds to "sequence.type"
    "sequence_trackId" TEXT NOT NULL,        -- Corresponds to "sequence.trackId"
    "displayName" TEXT,                      -- Display name of the assembly
    "adapterType" TEXT NOT NULL              -- Type of adapter (e.g., IndexedFastaAdapter)
);

-- Tracks

CREATE TABLE "Tracks" (
    "Id" SERIAL PRIMARY KEY,                 -- Unique identifier for the assembly
    "trackId" TEXT NOT NULL,                 -- Corresponds to "trackId"
    "type" TEXT NOT NULL,                    -- Corresponds to "type"
    "name" TEXT NOT NULL,                    -- Corresponds to "name"
    "assemblyNames" TEXT[],                 -- Corresponds to "assemblyNames" (array of text)
    "category" TEXT[],                       -- Corresponds to "category" (array of text)
    "adapterType" TEXT NOT NULL              -- Type of adapter (e.g., Gff3TabixAdapter)
);

-- Adapters

-- Assembly Adapters
-- BgzipFastaAdapter
CREATE TABLE "BgzipFastaAdapter" (
    "Id" SERIAL PRIMARY KEY,                         -- Unique ID for this adapter
    "assemblyId" INT NOT NULL REFERENCES "Assemblies"("Id"), -- Links to the Assemblies table
    "fastaLocation" TEXT NOT NULL,                   -- Corresponds to "fastaLocation.uri"
    "faiLocation" TEXT NOT NULL,                     -- Corresponds to "faiLocation.uri"
    "gziLocation" TEXT NOT NULL,                      -- Corresponds to "gziLocation.uri"
    "metadataLocation" TEXT NOT NULL                      -- Corresponds to "metadataLocation.uri"
);

CREATE TABLE "IndexedFastaAdapter" (
    "Id" SERIAL PRIMARY KEY,                         -- Unique ID for this adapter
    "assemblyId" INT NOT NULL REFERENCES "Assemblies"("Id"), -- Links to the Assemblies table
    "fastaLocation" TEXT NOT NULL,                  -- Corresponds to "fastaLocation.uri"
    "faiLocation" TEXT NOT NULL,                     -- Corresponds to "faiLocation.uri"
    "metadataLocation" TEXT NOT NULL                      -- Corresponds to "metadataLocation.uri"
);

-- Track Adapters
-- Gff3TabixAdapter
CREATE TABLE "Gff3TabixAdapter" (
    "Id" SERIAL PRIMARY KEY,                        -- Unique ID for this adapter
    "trackId" INT NOT NULL REFERENCES "Tracks"("Id"), -- References the Tracks table
    "gffGzLocation" TEXT NOT NULL,                 -- Corresponds to "gffGzLocation.uri"
    "indexLocation" TEXT NOT NULL                  -- Corresponds to "index.location.uri"
);

-- VcfTabixAdapter
CREATE TABLE "VcfTabixAdapter" (
    "Id" SERIAL PRIMARY KEY,                        -- Unique ID for this adapter
    "trackId" INT NOT NULL REFERENCES "Tracks"("Id"), -- References the Tracks table
    "vcfGzLocation" TEXT NOT NULL,                 -- Corresponds to "vcfGzLocation.uri"
    "indexLocation" TEXT NOT NULL                  -- Corresponds to "index.location.uri"
);

-- BamAdapter
CREATE TABLE "BamAdapter" (
    "Id" SERIAL PRIMARY KEY,                        -- Unique ID for this adapter
    "trackId" INT NOT NULL REFERENCES "Tracks"("Id"), -- References the Tracks table
    "bamLocation" TEXT NOT NULL,                   -- Corresponds to "bamLocation.uri"
    "indexLocation" TEXT NOT NULL,                 -- Corresponds to "index.location.uri"
    "sequenceAdapterId" INT NOT NULL,               -- Links to the assembly adapter id
    "sequenceAdapterType" TEXT NOT NULL             -- Links to the assembly adapter type
);

-- CramAdapter
CREATE TABLE "CramAdapter" (
    "Id" SERIAL PRIMARY KEY,                        -- Unique ID for this adapter
    "trackId" INT NOT NULL REFERENCES "Tracks"("Id"), -- References the Tracks table
    "cramLocation" TEXT NOT NULL,                   -- Corresponds to "cramLocation.uri"
    "craiLocation" TEXT NOT NULL,                   -- Location of the CRAI file
    "sequenceAdapterId" INT NOT NULL,               -- Links to the assembly adapter id
    "sequenceAdapterType" TEXT NOT NULL             -- Links to the assembly adapter type
);

-- BedTabixAdapter
CREATE TABLE "BedTabixAdapter" (
    "Id" SERIAL PRIMARY KEY,                        -- Unique ID for this adapter
    "trackId" INT NOT NULL REFERENCES "Tracks"("Id"), -- References the Tracks table
    "bedGzLocation" TEXT NOT NULL,                 -- Corresponds to "bedGzLocation.uri"
    "indexLocation" TEXT NOT NULL                  -- Corresponds to "index.location.uri"
);

-- PAFAdapter
CREATE TABLE "PAFAdapter" (
    "Id" SERIAL PRIMARY KEY,                        -- Unique ID for this adapter
    "trackId" INT NOT NULL REFERENCES "Tracks"("Id"), -- References the Tracks table
    "pafLocation" TEXT NOT NULL,                 -- location of PAF file
    "assemblyNames" TEXT[] NOT NULL                  -- Array of assembly names involved
);

-- DeltaAdapter
CREATE TABLE "DeltaAdapter" (
    "Id" SERIAL PRIMARY KEY,                       -- Unique ID for this adapter
    "trackId" INT NOT NULL REFERENCES "Tracks"("Id"), -- References the Tracks table
    "deltaLocation" TEXT NOT NULL,                -- Location of the Delta file
    "assemblyNames" TEXT[] NOT NULL               -- Array of assembly names involved
);


-- RefNameAlias tables
-- RefNameAlias
CREATE TABLE "RefNameAlias" (
    "Id" SERIAL PRIMARY KEY,                        -- Unique ID for the refnamealias
    "assemblyId" INT NOT NULL REFERENCES "Assemblies"("Id"), -- Links to the Assemblies table
    "adapterType" TEXT,                            -- Type of adapter
    "adapterId" TEXT                             -- corresponds to "adapter.adapterId"
);

-- features
CREATE TABLE "features" (
    "Id" SERIAL PRIMARY KEY,                        -- Unique serial ID for the feature
    "RefNameAliasId" INT NOT NULL REFERENCES "RefNameAlias"("Id"), -- References the RefNameAlias table
    "refName" TEXT,                                -- name of reference assembly
    "uniqueId" TEXT,                               -- Unique ID for the feature
    "aliases" TEXT[]                               -- aliases names for reference
);

-- Displays
CREATE TABLE "Displays" (
    "Id" SERIAL PRIMARY KEY,                       -- Unique serial identifier for the display
    "displayId" TEXT NOT NULL,                    -- Unique identifier for the display
    "parentId" INT NOT NULL,                      -- ID of the parent entity (either assemblyId or trackId)
    "parentType" TEXT NOT NULL CHECK ("parentType" IN ('Assembly', 'Track')), -- Indicates the type of parent
    "type" TEXT NOT NULL                          -- Corresponds to "type"
);

-- Renderer
CREATE TABLE "Renderer" (
    "id" SERIAL PRIMARY KEY,                      -- Unique identifier for the renderer
    "DisplaysId" INT NOT NULL REFERENCES "Displays"("Id"), -- References the Displays table
    "rendererKey" TEXT NOT NULL,                  -- Key in the JSON (e.g., "renderer" or specific type like "LinearManhattanRenderer")
    "type" TEXT NOT NULL,                         -- Type of the renderer (e.g., "SvgFeatureRenderer", "DivSequenceRenderer")
    "rendererDetails" JSONB                       -- JSON details for nested or additional properties (e.g., labels, color1, height)
);


