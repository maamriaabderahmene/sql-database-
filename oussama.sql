CREATE TABLE Zones (
    ZoneID INT PRIMARY KEY AUTO_INCREMENT,          -- Unique identifier for each zone
    ZoneName VARCHAR(255) NOT NULL,                -- Name of the zone (e.g., Zone A, Zone B)
    ZoneType ENUM('Rack Storage', 'Bulk Storage') NOT NULL, -- Type of storage (Rack or Bulk)
    Matricule VARCHAR(50) UNIQUE NOT NULL,          -- Unique matricule (code) for the zone
    TemperatureMin DECIMAL(5, 2),                  -- Minimum temperature requirement (nullable)
    TemperatureMax DECIMAL(5, 2),                  -- Maximum temperature requirement (nullable)
    HumidityMin DECIMAL(5, 2),                     -- Minimum humidity requirement (nullable)
    HumidityMax DECIMAL(5, 2),                     -- Maximum humidity requirement (nullable)
    WeightCapacity DECIMAL(10, 2) NOT NULL,        -- Maximum weight capacity of the zone
    Length DECIMAL(10, 2) NOT NULL,                -- Length of the zone (in meters or feet)
    Width DECIMAL(10, 2) NOT NULL,                 -- Width of the zone (in meters or feet)
    Height DECIMAL(10, 2) NOT NULL,                -- Height of the zone (in meters or feet)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of zone creation
);

