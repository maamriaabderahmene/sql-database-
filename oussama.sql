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
CREATE TABLE ZoneCategories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,      -- Unique identifier for each category
    CategoryName VARCHAR(255) NOT NULL,            -- Name of the category (e.g., Electronics, Perishables)
    ZoneID INT,                                    -- Foreign key referencing the Zones table
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID)  -- Establishes a relationship with the Zones table
);

CREATE TABLE ZoneConstraints (
    ConstraintID INT PRIMARY KEY AUTO_INCREMENT,      -- Unique identifier for each constraint
    ZoneID INT,                                      -- Foreign key referencing the Zones table
    TemperatureMin DECIMAL(5, 2),                    -- Minimum temperature requirement for the zone (nullable)
    TemperatureMax DECIMAL(5, 2),                    -- Maximum temperature requirement for the zone (nullable)
    HumidityMin DECIMAL(5, 2),                       -- Minimum humidity requirement for the zone (nullable)
    HumidityMax DECIMAL(5, 2),                       -- Maximum humidity requirement for the zone (nullable)
    WeightCapacity DECIMAL(10, 2) NOT NULL,          -- Maximum weight capacity for the zone
    Dimensions VARCHAR(255),                         -- Dimensions of the zone (e.g., "10x5x3" for LxWxH)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Timestamp of constraint creation
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID)    -- Establishes a relationship with the Zones table
);

CREATE TABLE Merchandise (
    MerchandiseID INT PRIMARY KEY AUTO_INCREMENT,      -- Unique identifier for each merchandise item
    MerchandiseName VARCHAR(255) NOT NULL,            -- Name of the merchandise (e.g., Laptop, Frozen Food)
    CategoryID INT,                                   -- Foreign key referencing the MerchandiseCategories table
    Quantity INT NOT NULL,                            -- Quantity of the merchandise in stock
    Weight DECIMAL(10, 2) NOT NULL,                   -- Weight of the merchandise (in kg or lbs)
    Dimensions VARCHAR(255),                          -- Dimensions of the merchandise (e.g., "0.5x0.3x0.2" for LxWxH)
    StorageTemperature DECIMAL(5, 2),                 -- Required storage temperature for the merchandise (nullable)
    StorageHumidity DECIMAL(5, 2),                    -- Required storage humidity for the merchandise (nullable)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Timestamp of merchandise creation
    FOREIGN KEY (CategoryID) REFERENCES MerchandiseCategories(CategoryID) -- Links to the MerchandiseCategories table
);

CREATE TABLE MerchandiseCategories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,      -- Unique identifier for each category
    CategoryName VARCHAR(255) NOT NULL,            -- Name of the category (e.g., Electronics, Perishables)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of category creation
);

CREATE TABLE Clients (
    ClientID INT PRIMARY KEY AUTO_INCREMENT,
    ClientName VARCHAR(255) NOT NULL,
    ClientType ENUM('Company', 'Individual') NOT NULL,
    ContactInfo VARCHAR(255),
    Email VARCHAR(255),
    Address VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
