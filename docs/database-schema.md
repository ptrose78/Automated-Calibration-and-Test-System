# Database Schema

## Overview

The Automated Calibration & Test System uses SQLite to store configuration data and structured calibration results. Raw acquisition waveforms are stored separately in TDMS files.

The database supports:

- sensor definitions
- sensor model test configurations
- controller configurations
- operator records
- calibration sessions
- test runs
- test-run channel assignments
- calibration-point results

## Core Data Model

The calibration data flow is centered on `TestRuns`, `TestRunChannels`, and `CalibrationPoints`

```text
 
                  CalibrationSessions
Operators                │                
   │                     ▼                            
   └──────────────►   TestRuns 
Sensors                  │
   │                     ▼
   └──────────────► TestRunChannels       
                         │
                         ▼
                 CalibrationPoints
                     
```

## Sensors

The `Sensors` table stores registered physical sensors.

```sql
CREATE TABLE IF NOT EXISTS Sensors (
    SensorID INTEGER PRIMARY KEY AUTOINCREMENT,
    ModelNumber TEXT NOT NULL,
    SerialNumber TEXT NOT NULL,
    Min REAL,
    Max REAL,
    Units TEXT,
    OutputSignal TEXT
);
```

### Fields

| Field | Description |
| :--- | :--- |
| `SensorID` | Unique identifier for the registered sensor. |
| `ModelNumber` | Sensor model number. |
| `SerialNumber` | Sensor serial number. |
| `Min` | Minimum measurement range. |
| `Max` | Maximum measurement range. |
| `Units` | Engineering units. |
| `OutputSignal` | Sensor output signal type. |

## Controllers

```sql
CREATE TABLE IF NOT EXISTS Controllers (
    ControllerID INTEGER PRIMARY KEY AUTOINCREMENT,
    Manufacturer TEXT,
    ModelNumber TEXT NOT NULL,
    SerialNumber TEXT NOT NULL,
    MinValue REAL NOT NULL,
    MaxValue REAL NOT NULL,
    Units TEXT NOT NULL,
    InputSignalType TEXT NOT NULL,
    InputSignalMin REAL NOT NULL,
    InputSignalMax REAL NOT NULL
);
```
### Fields

| Field | Description |
| :--- | :--- |
| `ControllerID` | Unique identifier for the controller. |
| `Manufacturer` | Manufacturer of the controller. |
| `ModelNumber` | Controller model number. |
| `SerialNumber` | Controller serial number. |
| `MinValue` | Minimum operating value of the controller. |
| `MaxValue` | Maximum operating value of the controller. |
| `Units` | Engineering units associated with the controller's operating range. |
| `InputSignalType` | Type of input signal used to control the controller. |
| `InputSignalMin` | Minimum value of the controller input signal range. |
| `InputSignalMax` | Maximum value of the controller input signal range. |

## Operators

```sql
CREATE TABLE IF NOT EXISTS Operators (
    OperatorID INTEGER PRIMARY KEY AUTOINCREMENT,
    OperatorName TEXT UNIQUE NOT NULL
);
```
### Fields

| Field | Description |
| :--- | :--- |
| `OperatorID` | Unique identifier for an operator. |
| `OperatorName` | Name of operator. |


## TestConfigurations

The `TestConfigurations` table stores model-specific test parameters used by the calibration system.

```sql
CREATE TABLE IF NOT EXISTS TestConfigurations (
    ModelNumber TEXT PRIMARY KEY,
    TargetSampleRateHz REAL,
    SteadyStateDurationSec REAL NOT NULL,
    AllowedTolerancePercentFS REAL NOT NULL,
    MaxSettlingTimeoutSec REAL NOT NULL
);
```

### Fields

| Field | Description |
| :--- | :--- |
| `ModelNumber` | Sensor model associated with the test configuration. |
| `TargetSampleRateHz` | Target acquisition sample rate. |
| `SteadyStateDurationSec` | Required continuous time within tolerance before a calibration point is successful. |
| `AllowedTolerancePercentFS` | Maximum permitted deviation expressed as a percentage of full scale. |
| `MaxSettlingTimeoutSec` | Maximum time allowed after a setpoint change to achieve the required steady-state duration. |

`AllowedTolerancePercentFS` is explicitly expressed as a percentage of full scale.

`MaxSettlingTimeoutSec` is intentionally separate from `SteadyStateDurationSec`. If a sample leaves the allowed tolerance band, the continuous steady-state timer resets while the overall settling timeout continues.

## CalibrationSessions

A calibration session groups the `TestRuns` that belong to one multi-cycle calibration operation.

```sql
CREATE TABLE IF NOT EXISTS CalibrationSessions (
    CalibrationSessionID INTEGER PRIMARY KEY AUTOINCREMENT,
    SessionStartTime TEXT
);
```

### Fields

| Field | Description |
| :--- | :--- |
| `CalibrationSessionID` | Unique identifier for a calibration session. |
| `SessionStartTime` | Start time associated with the calibration session. |

## TestRuns

A `TestRun` represents one complete ascending/descending calibration cycle.

```sql
CREATE TABLE IF NOT EXISTS TestRuns (
    TestRunID INTEGER PRIMARY KEY AUTOINCREMENT,
    RunStartTime TEXT,
    OperatorID INTEGER,
    TestResult TEXT,
    CalibrationSessionID INTEGER
);
```

### Fields

| Field | Description |
| :--- | :--- |
| `TestRunID` | Unique identifier for the test run. |
| `RunStartTime` | Start time of the test run. |
| `OperatorID` | Identifier of the operator associated with the run. |
| `TestResult` | Overall test result stored for the run. |
| `CalibrationSessionID` | Associates the test run with a calibration session. |

Multiple `TestRuns` can belong to the same `CalibrationSessionID`.

## TestRunChannels

`TestRunChannels` records the channels used during a test run.

```sql
CREATE TABLE IF NOT EXISTS TestRunChannels (
    ChannelRecordID INTEGER PRIMARY KEY AUTOINCREMENT,
    TestRunID INTEGER NOT NULL,
    SensorID INTEGER,
    HardwareRow INTEGER,
    PhysicalChannel TEXT,
    FinalStatus BOOLEAN,
    MeasurementRole TEXT,
    FOREIGN KEY(TestRunID) REFERENCES TestRuns(TestRunID),
    FOREIGN KEY(SensorID) REFERENCES Sensors(SensorID)
);
```

### Fields

| Field | Description |
| :--- | :--- |
| `ChannelRecordID` | Unique identifier for the channel record. |
| `TestRunID` | Test run associated with the channel. |
| `SensorID` | Registered sensor associated with the channel. |
| `HardwareRow` | Hardware/configuration row associated with the channel. |
| `PhysicalChannel` | NI-DAQmx physical channel. |
| `FinalStatus` | Final status associated with the channel. |
| `MeasurementRole` | Role of the channel, such as `Controller`, `Reference`, or `UUT`. |

`MeasurementRole` identifies how the channel participates in the test.

## CalibrationPoints

Only UUT measurement channels generate records in `CalibrationPoints`. Controller and Reference channels remain represented in `TestRunChannels`.

```sql
CREATE TABLE IF NOT EXISTS CalibrationPoints (
    PointID INTEGER PRIMARY KEY AUTOINCREMENT,
    TestRunID INTEGER NOT NULL,
    ChannelRecordID INTEGER NOT NULL,
    SensorID INTEGER,
    Setpoint REAL,
    ReferenceValue REAL,
    MeasuredValue REAL,
    AccuracyPercentFS REAL,
    PassFail BOOLEAN,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    CycleNumber INTEGER,
    Direction TEXT,
    FOREIGN KEY(TestRunID) REFERENCES TestRuns(TestRunID),
    FOREIGN KEY(ChannelRecordID) REFERENCES TestRunChannels(ChannelRecordID),
    FOREIGN KEY(SensorID) REFERENCES Sensors(SensorID)
);
```

### Fields

| Field | Description |
| :--- | :--- |
| `PointID` | Unique identifier for the calibration point. |
| `TestRunID` | Test run associated with the calibration point. |
| `ChannelRecordID` | Channel record associated with the calibration point. |
| `SensorID` | Sensor associated with the calibration point. |
| `Setpoint` | Test setpoint for the calibration point. |
| `ReferenceValue` | Reference measurement value. |
| `MeasuredValue` | UUT measured value. |
| `AccuracyPercentFS` | Accuracy error expressed as percent of full scale. |
| `PassFail` | Calibration-point PASS/FAIL result. |
| `Timestamp` | Time associated with the calibration point. |
| `CycleNumber` | Calibration cycle number. |
| `Direction` | Calibration direction, such as ascending or descending. |


## Calibration Session Model

A complete ascending/descending cycle is stored as one `TestRun`.

Multiple `TestRuns` can share a `CalibrationSessionID` so that multiple cycles can be analyzed together for repeatability.

The Analysis Dialog uses the calibration session as the unit of historical selection.

## Session-Level Analysis Query

The Analysis Dialog uses the earliest run time associated with a calibration session when presenting a session for historical selection:

```sql
SELECT
    tr.TestRunID,
    tr.RunStartTime,
    tr.CalibrationSessionID
FROM TestRuns AS tr
JOIN TestRunChannels AS trc
    ON tr.TestRunID = trc.TestRunID
WHERE trc.SensorID = ?
  AND trc.MeasurementRole = 'UUT'
  AND tr.RunStartTime = (
      SELECT MIN(tr2.RunStartTime)
      FROM TestRuns AS tr2
      WHERE tr2.CalibrationSessionID = tr.CalibrationSessionID
  )
ORDER BY tr.RunStartTime DESC;
```

This allows the session to be displayed once while preserving all associated test cycles for downstream analysis.

## Data Storage

The system separates structured results from raw acquisition data:

- **SQLite** stores configuration and structured test/calibration records.
- **TDMS** stores continuous raw acquisition waveforms.

See [System Architecture](architecture.md) and [Calibration Analysis](calibration-analysis.md) for related information.

---

[⬆ Back to README](../README.md)
