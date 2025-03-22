-- Zones table to store information about storage zones
CREATE TABLE Zones (
    ZoneID INT PRIMARY KEY AUTO_INCREMENT,
    ZoneName VARCHAR(255) NOT NULL,
    ZoneType ENUM('Rack Storage', 'Bulk Storage') NOT NULL,
    Matricule VARCHAR(50) UNIQUE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ZoneCategories table to categorize zones based on storage type
CREATE TABLE ZoneCategories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(255) NOT NULL,
    ZoneID INT,
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID)
);

-- ZoneConstraints table to define constraints for each zone
CREATE TABLE ZoneConstraints (
    ConstraintID INT PRIMARY KEY AUTO_INCREMENT,
    ZoneID INT,
    TemperatureMin DECIMAL(5, 2),
    TemperatureMax DECIMAL(5, 2),
    HumidityMin DECIMAL(5, 2),
    HumidityMax DECIMAL(5, 2),
    WeightCapacity DECIMAL(10, 2),
    Dimensions VARCHAR(255),
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID)
);

-- Merchandise table to store information about merchandise
CREATE TABLE Merchandise (
    MerchandiseID INT PRIMARY KEY AUTO_INCREMENT,
    MerchandiseName VARCHAR(255) NOT NULL,
    CategoryID INT,
    Quantity INT,
    Weight DECIMAL(10, 2),
    Dimensions VARCHAR(255),
    StorageTemperature DECIMAL(5, 2),
    StorageHumidity DECIMAL(5, 2),
    FOREIGN KEY (CategoryID) REFERENCES MerchandiseCategories(CategoryID)
);

-- MerchandiseCategories table to categorize merchandise
CREATE TABLE MerchandiseCategories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(255) NOT NULL
);

-- Clients table to store information about clients
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY AUTO_INCREMENT,
    ClientName VARCHAR(255) NOT NULL,
    ClientType ENUM('Company', 'Individual') NOT NULL,
    ContactInfo VARCHAR(255)
);

-- ClientOrders table to store client orders
CREATE TABLE ClientOrders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    ClientID INT,
    OrderType ENUM('Stocking', 'Destocking') NOT NULL,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'Validated', 'Completed') DEFAULT 'Pending',
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);

-- StockingOrders table to store details of stocking orders
CREATE TABLE StockingOrders (
    StockingOrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    MerchandiseID INT,
    ZoneID INT,
    Quantity INT,
    StockDate TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES ClientOrders(OrderID),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID),
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID)
);

-- DestockingOrders table to store details of destocking orders
CREATE TABLE DestockingOrders (
    DestockingOrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    MerchandiseID INT,
    DestinationAddressID INT,
    BuyerInfoID INT,
    LimitDate DATE,
    Status ENUM('Not Distributed', 'In Transit', 'Delivered') DEFAULT 'Not Distributed',
    FOREIGN KEY (OrderID) REFERENCES ClientOrders(OrderID),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID),
    FOREIGN KEY (DestinationAddressID) REFERENCES DestinationAddresses(AddressID),
    FOREIGN KEY (BuyerInfoID) REFERENCES BuyerInformation(BuyerID)
);

-- Drivers table to store information about drivers
CREATE TABLE Drivers (
    DriverID INT PRIMARY KEY AUTO_INCREMENT,
    DriverName VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    Availability ENUM('Available', 'Busy') DEFAULT 'Available'
);

-- DriverTasks table to store tasks assigned to drivers
CREATE TABLE DriverTasks (
    TaskID INT PRIMARY KEY AUTO_INCREMENT,
    DriverID INT,
    OrderID INT,
    TaskType ENUM('Stocking', 'Destocking') NOT NULL,
    TaskStatus ENUM('Pending', 'In Progress', 'Completed') DEFAULT 'Pending',
    StartTime TIMESTAMP,
    EndTime TIMESTAMP,
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID),
    FOREIGN KEY (OrderID) REFERENCES ClientOrders(OrderID)
);

-- Controllers table to store information about controllers
CREATE TABLE Controllers (
    ControllerID INT PRIMARY KEY AUTO_INCREMENT,
    ControllerName VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255)
);

-- Inspections table to store inspection details
CREATE TABLE Inspections (
    InspectionID INT PRIMARY KEY AUTO_INCREMENT,
    ControllerID INT,
    TaskID INT,
    InspectionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    InspectionStatus ENUM('Pass', 'Fail') NOT NULL,
    FOREIGN KEY (ControllerID) REFERENCES Controllers(ControllerID),
    FOREIGN KEY (TaskID) REFERENCES DriverTasks(TaskID)
);

-- Moderators table to store information about moderators
CREATE TABLE Moderators (
    ModeratorID INT PRIMARY KEY AUTO_INCREMENT,
    ModeratorName VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255)
);

-- ModeratorAssignments table to store moderator assignments
CREATE TABLE ModeratorAssignments (
    AssignmentID INT PRIMARY KEY AUTO_INCREMENT,
    ModeratorID INT,
    OrderID INT,
    AssignmentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ModeratorID) REFERENCES Moderators(ModeratorID),
    FOREIGN KEY (OrderID) REFERENCES ClientOrders(OrderID)
);

-- PerformanceMetrics table to store performance metrics
CREATE TABLE PerformanceMetrics (
    MetricID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    UserRole ENUM('Moderator', 'Driver', 'Controller') NOT NULL,
    MetricType ENUM('Daily', 'Monthly', 'Yearly') NOT NULL,
    MetricValue DECIMAL(10, 2),
    MetricDate DATE,
    FOREIGN KEY (UserID) REFERENCES Moderators(ModeratorID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Drivers(DriverID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Controllers(ControllerID) ON DELETE CASCADE
);

-- PerformanceHistory table to store historical performance data
CREATE TABLE PerformanceHistory (
    HistoryID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    UserRole ENUM('Moderator', 'Driver', 'Controller') NOT NULL,
    MetricType ENUM('Daily', 'Monthly', 'Yearly') NOT NULL,
    MetricValue DECIMAL(10, 2),
    MetricDate DATE,
    FOREIGN KEY (UserID) REFERENCES Moderators(ModeratorID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Drivers(DriverID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Controllers(ControllerID) ON DELETE CASCADE
);

-- ClarkCodes table to store unique identifiers for tasks
CREATE TABLE ClarkCodes (
    ClarkCodeID INT PRIMARY KEY AUTO_INCREMENT,
    TaskID INT,
    ClarkCode VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (TaskID) REFERENCES DriverTasks(TaskID)
);

-- ZoneMatricules table to store zone matricules
CREATE TABLE ZoneMatricules (
    MatriculeID INT PRIMARY KEY AUTO_INCREMENT,
    ZoneID INT,
    Matricule VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID)
);

-- MerchandiseDetails table to store detailed information about merchandise
CREATE TABLE MerchandiseDetails (
    DetailID INT PRIMARY KEY AUTO_INCREMENT,
    MerchandiseID INT,
    DetailName VARCHAR(255),
    DetailValue TEXT,
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID)
);

-- StorageConditions table to store storage conditions for merchandise
CREATE TABLE StorageConditions (
    ConditionID INT PRIMARY KEY AUTO_INCREMENT,
    MerchandiseID INT,
    Temperature DECIMAL(5, 2),
    Humidity DECIMAL(5, 2),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID)
);

-- TaskStatus table to store task statuses
CREATE TABLE TaskStatus (
    StatusID INT PRIMARY KEY AUTO_INCREMENT,
    TaskID INT,
    Status ENUM('Pending', 'In Progress', 'Completed') NOT NULL,
    StatusDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TaskID) REFERENCES DriverTasks(TaskID)
);

-- OrderStatus table to store order statuses
CREATE TABLE OrderStatus (
    OrderStatusID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    Status ENUM('Pending', 'Validated', 'Completed') NOT NULL,
    StatusDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES ClientOrders(OrderID)
);

-- BuyerInformation table to store buyer information
CREATE TABLE BuyerInformation (
    BuyerID INT PRIMARY KEY AUTO_INCREMENT,
    BuyerName VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    AddressID INT,
    FOREIGN KEY (AddressID) REFERENCES DestinationAddresses(AddressID)
);

-- DestinationAddresses table to store destination addresses
CREATE TABLE DestinationAddresses (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    AddressLine1 VARCHAR(255) NOT NULL,
    AddressLine2 VARCHAR(255),
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255),
    PostalCode VARCHAR(50),
    Country VARCHAR(255) NOT NULL
);

-- RealTimeUpdates table to store real-time updates
CREATE TABLE RealTimeUpdates (
    UpdateID INT PRIMARY KEY AUTO_INCREMENT,
    TaskID INT,
    UpdateType ENUM('Stocking', 'Destocking') NOT NULL,
    UpdateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdateStatus ENUM('Pending', 'In Progress', 'Completed') NOT NULL,
    FOREIGN KEY (TaskID) REFERENCES DriverTasks(TaskID)
);

-- Reports table to store system reports
CREATE TABLE Reports (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,
    ReportType ENUM('Performance', 'Inventory', 'Order') NOT NULL,
    GeneratedBy INT,
    GeneratedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ReportData TEXT,
    FOREIGN KEY (GeneratedBy) REFERENCES Moderators(ModeratorID)
);

-- Feedback table to store feedback from users
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    UserRole ENUM('Moderator', 'Driver', 'Controller') NOT NULL,
    FeedbackText TEXT,
    FeedbackDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Moderators(ModeratorID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Drivers(DriverID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Controllers(ControllerID) ON DELETE CASCADE
);

-- Permissions table to store user permissions
CREATE TABLE Permissions (
    PermissionID INT PRIMARY KEY AUTO_INCREMENT,
    UserRole ENUM('Administrator', 'Moderator', 'Driver', 'Controller') NOT NULL,
    PermissionType ENUM('Read', 'Write', 'Read/Write') NOT NULL,
    ResourceType ENUM('Orders', 'Zones', 'Merchandise', 'Reports') NOT NULL
);

-- AccessLevels table to store access levels for users
CREATE TABLE AccessLevels (
    AccessLevelID INT PRIMARY KEY AUTO_INCREMENT,
    UserRole ENUM('Administrator', 'Moderator', 'Driver', 'Controller') NOT NULL,
    AccessType ENUM('Read', 'Write', 'Read/Write') NOT NULL,
    ResourceType ENUM('Orders', 'Zones', 'Merchandise', 'Reports') NOT NULL
);

-- UserRoles table to define user roles
CREATE TABLE UserRoles (
    RoleID INT PRIMARY KEY AUTO_INCREMENT,
    RoleName ENUM('Administrator', 'Moderator', 'Driver', 'Controller') NOT NULL
);

-- Notifications table to store system notifications
CREATE TABLE Notifications (
    NotificationID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    UserRole ENUM('Moderator', 'Driver', 'Controller') NOT NULL,
    NotificationType ENUM('Task Assigned', 'Task Completed', 'Inspection Required') NOT NULL,
    NotificationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Moderators(ModeratorID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Drivers(DriverID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Controllers(ControllerID) ON DELETE CASCADE
);

-- TaskAssignments table to store task assignments
CREATE TABLE TaskAssignments (
    AssignmentID INT PRIMARY KEY AUTO_INCREMENT,
    TaskID INT,
    AssignedTo INT,
    AssignedBy INT,
    AssignmentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TaskID) REFERENCES DriverTasks(TaskID),
    FOREIGN KEY (AssignedTo) REFERENCES Drivers(DriverID),
    FOREIGN KEY (AssignedBy) REFERENCES Moderators(ModeratorID)
);

-- MerchandiseInspectionLogs table to store inspection logs for merchandise
CREATE TABLE MerchandiseInspectionLogs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    InspectionID INT,
    MerchandiseID INT,
    LogDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LogDetails TEXT,
    FOREIGN KEY (InspectionID) REFERENCES Inspections(InspectionID),
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID)
);

-- DriverPerformanceLogs table to store driver performance logs
CREATE TABLE DriverPerformanceLogs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    DriverID INT,
    MetricType ENUM('Daily', 'Monthly', 'Yearly') NOT NULL,
    MetricValue DECIMAL(10, 2),
    LogDate DATE,
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

-- ControllerPerformanceLogs table to store controller performance logs
CREATE TABLE ControllerPerformanceLogs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    ControllerID INT,
    MetricType ENUM('Daily', 'Monthly', 'Yearly') NOT NULL,
    MetricValue DECIMAL(10, 2),
    LogDate DATE,
    FOREIGN KEY (ControllerID) REFERENCES Controllers(ControllerID)
);

-- ModeratorPerformanceLogs table to store moderator performance logs
CREATE TABLE ModeratorPerformanceLogs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    ModeratorID INT,
    MetricType ENUM('Daily', 'Monthly', 'Yearly') NOT NULL,
    MetricValue DECIMAL(10, 2),
    LogDate DATE,
    FOREIGN KEY (ModeratorID) REFERENCES Moderators(ModeratorID)
);

-- ZoneSaturationLevels table to store zone saturation levels
CREATE TABLE ZoneSaturationLevels (
    SaturationID INT PRIMARY KEY AUTO_INCREMENT,
    ZoneID INT,
    SaturationLevel DECIMAL(5, 2),
    SaturationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ZoneID) REFERENCES Zones(ZoneID)
);

-- HistoricalData table to store historical data
CREATE TABLE HistoricalData (
    HistoricalID INT PRIMARY KEY AUTO_INCREMENT,
    DataType ENUM('Orders', 'Tasks', 'Inspections') NOT NULL,
    DataID INT,
    DataDetails TEXT,
    RecordedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SupplementaryInformation table to store supplementary information
CREATE TABLE SupplementaryInformation (
    SupplementaryID INT PRIMARY KEY AUTO_INCREMENT,
    MerchandiseID INT,
    InfoType VARCHAR(255),
    InfoValue TEXT,
    FOREIGN KEY (MerchandiseID) REFERENCES Merchandise(MerchandiseID)
);

CREATE TABLE Permissions (
    PermissionID INT PRIMARY KEY AUTO_INCREMENT,
    UserRole ENUM('Administrator', 'Moderator', 'Driver', 'Controller') NOT NULL,
    PermissionType ENUM('Read', 'Write', 'Read/Write') NOT NULL,
    ResourceType ENUM('Orders', 'Zones', 'Merchandise', 'Reports', 'Tasks', 'Inspections', 'Feedback', 'Clients', 'Drivers', 'Controllers', 'Moderators') NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,      -- Indicates if the permission is active
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of permission creation
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Timestamp of last update
    Notes TEXT                          -- Additional notes or instructions
);

