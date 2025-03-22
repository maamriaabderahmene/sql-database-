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

CREATE TABLE ClientOrders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    ClientID INT,
    OrderType ENUM('Stocking', 'Destocking') NOT NULL,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'Validated', 'Completed') DEFAULT 'Pending',
    DestinationAddress VARCHAR(255), -- For destocking orders
    BuyerInfo VARCHAR(255),          -- For destocking orders
    LimitDate DATE,                  -- Deadline for destocking orders
    Notes TEXT,                      -- Additional notes or instructions
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);

CREATE TABLE StockingOrders (
    StockingOrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    MerchandiseID INT,
    ZoneID INT,
    Quantity INT,
    StockDate TIMESTAMP,
    AssignedDriverID INT,              -- Driver assigned for stocking
    AssignedControllerID INT,          -- Controller assigned for inspection
    Status ENUM('Pending', 'In Progress', 'Completed') DEFAULT 'Pending',
    Notes TEXT,                        -- Additional notes or instructions
    FOREIGN KEY (OrderID) REFERENCES ClientOrders(OrderID),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID),
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID),
    FOREIGN KEY (AssignedDriverID) REFERENCES Drivers(DriverID),
    FOREIGN KEY (AssignedControllerID) REFERENCES Controllers(ControllerID)
);

CREATE TABLE DestockingOrders (
    DestockingOrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    MerchandiseID INT,
    DestinationAddressID INT,
    BuyerInfoID INT,
    Quantity INT,                      -- Quantity of merchandise to destock
    DestockingDate TIMESTAMP,         -- Date when destocking operation is performed
    AssignedDriverID INT,             -- Driver assigned for destocking
    AssignedControllerID INT,         -- Controller assigned for inspection
    Status ENUM('Not Distributed', 'In Transit', 'Delivered') DEFAULT 'Not Distributed',
    Notes TEXT,                       -- Additional notes or instructions
    FOREIGN KEY (OrderID) REFERENCES ClientOrders(OrderID),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID),
    FOREIGN KEY (DestinationAddressID) REFERENCES DestinationAddresses(AddressID),
    FOREIGN KEY (BuyerInfoID) REFERENCES BuyerInformation(BuyerID),
    FOREIGN KEY (AssignedDriverID) REFERENCES Drivers(DriverID),
    FOREIGN KEY (AssignedControllerID) REFERENCES Controllers(ControllerID)
);

CREATE TABLE Drivers (
    DriverID INT PRIMARY KEY AUTO_INCREMENT,
    DriverName VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    Email VARCHAR(255),                -- Driver's email for communication
    LicenseNumber VARCHAR(50),         -- Driver's license number
    VehicleInfo VARCHAR(255),         -- Information about the driver's vehicle
    Availability ENUM('Available', 'Busy') DEFAULT 'Available',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of driver creation
    Notes TEXT                         -- Additional notes or instructions
);

CREATE TABLE DriverTasks (
    TaskID INT PRIMARY KEY AUTO_INCREMENT,
    DriverID INT,
    OrderID INT,
    TaskType ENUM('Stocking', 'Destocking') NOT NULL,
    TaskStatus ENUM('Pending', 'In Progress', 'Completed') DEFAULT 'Pending',
    StartTime TIMESTAMP,               -- Time when the task is started
    EndTime TIMESTAMP,                 -- Time when the task is completed
    ZoneID INT,                        -- Zone where the task is performed
    MerchandiseID INT,                 -- Merchandise involved in the task
    Notes TEXT,                        -- Additional notes or instructions
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID),
    FOREIGN KEY (OrderID) REFERENCES ClientOrders(OrderID),
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID)
);

CREATE TABLE Controllers (
    ControllerID INT PRIMARY KEY AUTO_INCREMENT,
    ControllerName VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    Email VARCHAR(255),                -- Controller's email for communication
    Availability ENUM('Available', 'Busy') DEFAULT 'Available', -- Controller's availability status
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of controller creation
    Notes TEXT                         -- Additional notes or instructions
);

CREATE TABLE Inspections (
    InspectionID INT PRIMARY KEY AUTO_INCREMENT,
    ControllerID INT,
    TaskID INT,
    InspectionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    InspectionStatus ENUM('Pass', 'Fail') NOT NULL,
    Notes TEXT,                        -- Additional notes or observations from the inspection
    ZoneID INT,                        -- Zone where the inspection was performed
    MerchandiseID INT,                 -- Merchandise involved in the inspection
    FOREIGN KEY (ControllerID) REFERENCES Controllers(ControllerID),
    FOREIGN KEY (TaskID) REFERENCES DriverTasks(TaskID),
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID)
);

CREATE TABLE Moderators (
    ModeratorID INT PRIMARY KEY AUTO_INCREMENT,
    ModeratorName VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    Email VARCHAR(255),                -- Moderator's email for communication
    DateOfBirth DATE,                  -- Moderator's date of birth
    RecruitmentDate DATE,              -- Date when the moderator was recruited
    Role ENUM('Admin', 'Moderator') DEFAULT 'Moderator', -- Role of the moderator
    Availability ENUM('Available', 'Busy') DEFAULT 'Available', -- Moderator's availability status
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of moderator creation
    Notes TEXT                         -- Additional notes or instructions
);

CREATE TABLE ModeratorAssignments (
    AssignmentID INT PRIMARY KEY AUTO_INCREMENT,
    ModeratorID INT,
    OrderID INT,
    AssignmentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'In Progress', 'Completed') DEFAULT 'Pending', -- Status of the assignment
    TaskType ENUM('Stocking', 'Destocking'), -- Type of task (stocking or destocking)
    ZoneID INT,                        -- Zone involved in the assignment
    MerchandiseID INT,                 -- Merchandise involved in the assignment
    Notes TEXT,                        -- Additional notes or instructions
    FOREIGN KEY (ModeratorID) REFERENCES Moderators(ModeratorID),
    FOREIGN KEY (OrderID) REFERENCES ClientOrders(OrderID),
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID)
);

CREATE TABLE PerformanceMetrics (
    MetricID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,               -- ID of the user (Moderator, Driver, or Controller)
    UserRole ENUM('Moderator', 'Driver', 'Controller') NOT NULL, -- Role of the user
    MetricType ENUM('Daily', 'Monthly', 'Yearly') NOT NULL, -- Type of metric (daily, monthly, yearly)
    MetricValue DECIMAL(10, 2),       -- Value of the performance metric
    MetricDate DATE,                  -- Date of the performance metric
    TaskType ENUM('Stocking', 'Destocking'), -- Type of task (stocking or destocking)
    ZoneID INT,                       -- Zone involved in the performance metric
    MerchandiseID INT,                -- Merchandise involved in the performance metric
    Notes TEXT,                       -- Additional notes or comments
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of when the metric was recorded
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID)
);

CREATE TABLE PerformanceHistory (
    HistoryID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,               -- ID of the user (Moderator, Driver, or Controller)
    UserRole ENUM('Moderator', 'Driver', 'Controller') NOT NULL, -- Role of the user
    MetricType ENUM('Daily', 'Monthly', 'Yearly') NOT NULL, -- Type of metric (daily, monthly, yearly)
    MetricValue DECIMAL(10, 2),       -- Value of the performance metric
    MetricDate DATE,                  -- Date of the performance metric
    TaskType ENUM('Stocking', 'Destocking'), -- Type of task (stocking or destocking)
    ZoneID INT,                       -- Zone involved in the performance metric
    MerchandiseID INT,                -- Merchandise involved in the performance metric
    Notes TEXT,                       -- Additional notes or comments
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of when the metric was recorded
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID)
);

