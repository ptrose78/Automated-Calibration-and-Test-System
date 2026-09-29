<a name="top"></a>

<div align="center">
  <h1>Automated Calibration &amp; Test System</h1>
  <p><strong>Multi-Sensor Instrument Calibration Platform</strong></p>
</div>

An automated, database-driven instrumentation test and calibration system built in **LabVIEW**, with an integrated **SQLite relational database** for configuration, test sequencing, acquisition, processing, calibration analysis, and persistent results storage.

The system is designed to support multi-sensor calibration workflows, coordinated stimulus generation, real-time data acquisition and visualization, steady-state and settling verification, deterministic PASS/FAIL evaluation, relational data logging, and post-test calibration analysis.

---

## 📑 Table of Contents
* [📸 System Overview &amp; Architecture](#-system-overview--architecture)
* [🔑 Key Features](#-key-features)
* [⚡ Quick Start](#-quick-start) 
* [🚀 Getting Started &amp; Execution](#-getting-started--execution)
* [⚙️ Configuration &amp; Operational Modes](#%EF%B8%8F-configuration--operational-modes)
* [📊 Calibration Sequence &amp; Analysis](#-calibration-sequence--analysis)
* [🖥️ User Interface](#%EF%B8%8F-user-interface)
* [🛠 Tech Stack &amp; Dependencies](#-tech-stack--dependencies)
* [🛡️ Error Handling &amp; Fault Management](#️-error-handling--fault-management)
* [📂 Directory Structure](#-directory-structure)
* [🗄️ Data Persistence &amp; Database Schema](#%EF%B8%8F-data-persistence--database-schema)
  * [💾 Data Persistence &amp; File Outputs](#-data-persistence--file-outputs)
  * [🗄️ SQLite Database Schema](#%EF%B8%8F-sqlite-database-schema)

---

## 📸 System Overview &amp; Architecture

The system separates test sequencing, acquisition, processing, user-interface messaging, data display, database persistence, and calibration analysis into cooperating LabVIEW execution loops. This architecture allows the application to coordinate multiple sensors while maintaining deterministic test progression and persistent traceability of calibration results.

```text
┌──────────────────────────────────────────────────────────────────────────────┐
│                          Main Application UI                                 │
│                    Operator controls and test status                         │
└───────────────────────────────────┬──────────────────────────────────────────┘
                                    │
                                    │ UI commands / events
                                    ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                       UI Event Handling Loop                                 │
│        Handles operator commands, messages and data exchanged with           │
│                    loop structures, and window control                       │
└───────────────────────────────────┬──────────────────────────────────────────┘
                                    │
                                    │ Test commands & test settings
                                    ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                            Test Sequencer                                    │
│                                                                              │
│      Controls test progression, setpoints, cycle number, direction,          │
│                           and test state                                     │
└───────────────────────────────────┬──────────────────────────────────────────┘
                                    │
                                    │ Test sequence state & acquisition settings
                                    ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                          Acquisition Loop                                    │
│                                                                              │
│               NI-DAQmx acquisition or waveform simulation                    │
│              handles continuous multi-channel data acquisition               │
└────────────────────────────────────┬─────────────────────────────────────────┘
                                     │
              ┌──────────────────────┼─────────────────────────┐
              │                      │                         │
              │ Waveforms via        │ Waveforms via           │ UUT waveforms via
              │ Queue A              │ Queue B                 │ Data Notifier
              ▼                      ▼                         ▼
┌─────────────────────────┐ ┌───────────────────────┐ ┌──────────────────────┐
│     Processing Loop     │ │    Logging Loop       │ │  Data Display Loop   │
│                         │ │                       │ │                      │
│ Filters and evaluates   │ │ Continuously logs raw │ │ Displays real-time   │
│ measurements, determines│ │ acquisition waveforms │ │ UUT waveforms and    │
│ point PASS/FAIL, and    │ │ for persistent        │ │ dynamically labels   │
│ creates calibration     │ │ TDMS storage          │ │ each waveform using  │
│ point records           │ │                       │ │ its sensor serial    │
│                         │ │                       │ │ number               │
└────────────┬────────────┘ └────────────┬──────────┘ └──────────────────────┘
             │                           │
             │ Calibration point         │ Raw acquisition data
             │ records                   │
             ▼                           ▼
┌──────────────────────────────┐ ┌────────────────────────────────┐
│        Database Loop         │ │      TDMS Data Stream          │   
│                              │ │                                │
│ Maintains SQLite             │ │ Stores continuous raw waveform │
│ configuration and test data, │ │ data independently from        │
│ including sensor definitions,│ │ processed calibration results  │
│ test runs, test-run channels,│ │                                │
│ calibration sessions, and    │ │                                │
│ calibration points           │ │                                │
└──────────────┬───────────────┘ └────────────────────────────────┘
               │
               │ Stored calibration session data
               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                         Calibration Analysis                                 │
│                                                                              │
│ Calculates calibration performance metrics from stored session data,         │
│ including accuracy, linearity, hysteresis, and repeatability                 │
└───────────────────────────────────┬──────────────────────────────────────────┘
                                    │
                                    │ Analysis results
                                    ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                          Analysis & Reporting                                │
│                                                                              │
│ Displays calibration session results, overall PASS/FAIL status, detailed     │
│ performance metrics, and generated calibration reports                       │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Execution Architecture

The application uses a message-driven architecture with dedicated loops for major responsibilities:

* **UI Message Loop:** Handles operator commands, test controls, configuration messages, and application windows.
* **Test Sequencer:** Owns authoritative test progression, including setpoints, cycle number, direction, point transitions, and completion state.
* **Acquisition Loop:** Manages continuous acquisition from NI-DAQmx hardware or the simulation engine.
* **Processing Loop:** Consumes acquisition data, evaluates settling and tolerance criteria, and creates processed calibration points for UUT channels.
* **Data Display Loop:** Displays UUT-only waveforms and dynamically labels plot legends using the associated sensor serial numbers.
* **Database Loop:** Handles SQLite transactions, configuration retrieval, run/channel records, calibration points, and session persistence.
* **Calibration Analysis:** Performs post-test analysis from stored calibration points without modifying the underlying measurement records.

The acquisition path and test-state synchronization are designed so that processing uses the intended test configuration for each calibration point rather than a stale cycle, setpoint, or direction.

---

## 🔑 Key Features

* **Multi-Sensor Calibration:** Supports multiple UUTs in a single test configuration while preserving sensor identity through `SensorID`, serial number, and channel records.
* **Database-Driven Configuration:** Sensor models, sample rates, settling requirements, tolerance limits, and other test parameters are retrieved from SQLite rather than hard-coded into the test sequence.
* **Administrator and Operator Separation:** The system provides a password-protected Administrator interface for managing registered sensors and operators. Administrators can add sensor records and operator accounts, while model-specific test parameters are maintained in the SQLite `TestConfigurations` table. Operators use the Settings interface to select sensors, assign measurement roles, and configure physical acquisition channels.
* **Simulation Mode:** Provides a hardware-independent acquisition path using predefined passing and failing sensor waveforms embedded in the LabVIEW application for repeatable development and verification. Simulation Mode defaults to **False** when the application starts.
* **Hardware / Simulation Acquisition:** Supports NI-DAQmx acquisition and simulated multi-channel waveforms through a common processing architecture.
* **Coordinated Test Sequencing:** Supports ascending and descending calibration profiles with explicit cycle number and direction tracking.
* **Settling and Steady-State Verification:** Separates maximum settling timeout from required continuous steady-state duration. A calibration point must remain within the configured tolerance continuously for the required dwell period before timeout to pass; otherwise, the point fails.
* **Tolerance-Based PASS/FAIL:** Calibration measurements are evaluated against model-specific `%FS` tolerance limits.
* **UUT-Only Visualization:** The real-time graph displays UUT waveforms while Controller and Reference channels remain available to the acquisition and processing architecture as supporting signals.
* **Dynamic Graph Legends:** UUT plots can be labeled with the corresponding sensor serial number rather than generic `Plot 0`, `Plot 1`, etc.
* **Calibration Analytics:** Calculates accuracy, Best Fit Straight Line (BFSL) linearity, hysteresis, and repeatability metrics from stored calibration points.
* **Full-Scale Error Reporting:** Analysis metrics are normalized to sensor full scale so results can be compared consistently across the test profile.
* **Calibration Sessions:** Multiple `TestRuns` can be grouped under a single `CalibrationSessionID`, allowing an entire multi-cycle calibration to be analyzed as one session.
* **Relational Traceability:** Calibration points retain links to the `TestRun` and UUT channel records used to acquire them.
* **Analysis Dialog:** Operators can select Model Number, Serial Number, and calibration session date/time to retrieve and analyze historical calibration results.

[⬆ Back to Top](#top)

---

## ⚡ Quick Start

### 1. Launch the Application

Open the main application VI and run it. On startup, the Database Loop initializes the SQLite database and creates the required tables if they do not already exist.

> **Important:** Simulation Mode defaults to **False**. If physical NI-DAQmx hardware is not connected and you are performing a software-only first run, enable Simulation Mode before starting the test.

▶️ **[Watch the Quick Start video: Launch the Application](https://youtu.be/X1RNhC5maAk)**

### 2. Configure a Sensor Model

Version 1.0 stores model-specific test parameters in the SQLite `TestConfigurations` table. A model must have a configuration before it can be selected for sensor registration and testing.

Each configuration defines:

* `ModelNumber`
* `TargetSampleRateHz`
* `SteadyStateDurationSec`
* `AllowedTolerancePercentFS`
* `MaxSettlingTimeoutSec`

For Version 1.0, new model configurations are added or modified directly in the SQLite `TestConfigurations` table using SQL.

▶️ **[Watch the Quick Start video: Configure a Sensor Model](https://www.youtube.com/watch?v=iytZI9MwTIs)**

### 3. Configure Administrator Password

Before accessing password-protected functions, configure the administrator password in `SystemConfig.ini`.

1. Choose an administrator password.
2. Generate the **SHA-256 hash** of the password.
3. Open `SystemConfig.ini` in the project directory.
4. Under **System Settings**, replace `INSERT_SHA256_HASH_HERE` with the generated SHA-256 hash.
5. Save the configuration file.

When a password-protected function is accessed, enter the **original administrator password**. The application calculates the SHA-256 hash of the entered password and compares it with the `AdminHash` value stored in `SystemConfig.ini`.

> **Important:** Do not store or commit your actual administrator password or password hash in the project repository. `SystemConfig.ini` is excluded from source control.

▶️ **[Watch the Quick Start video: Configure Administrator Password](https://www.youtube.com/watch?v=yf01NTaYJQA)**

### 4. Register the Sensor

From the Main VI, select **Manage Serial Numbers**.

1. Select a configured model number.
2. Enter the sensor serial number.
3. Enter the sensor's minimum and maximum range.
4. Enter the engineering units.
5. Enter the sensor output signal.
6. Save the sensor record.

The sensor is stored in the SQLite `Sensors` table. Measurement role and physical acquisition-channel assignment are performed later in the Settings interface.

▶️ **[Watch the Quick Start video: Register the Sensor](https://www.youtube.com/watch?v=BjLVVS2KBrU)**

### 5. Configure the Test

Open **Settings** from the Main VI.

Under **Instrument Configuration**, verify the database-derived configuration values for the selected sensor model.

Under **Measurements (AI)**:

1. Select the registered sensor model.
2. Select the sensor serial number.
3. Assign the measurement role (`Reference` or `UUT`).
4. Assign the NI-DAQmx physical channel.

Configure any required **Stimulus Outputs (AO)** for the test.

### 6. Select the Operating Mode

The application supports two acquisition modes:

* **Simulation Mode** — generates simulated multi-channel waveforms for development and verification without physical NI hardware.
* **Hardware Mode** — uses NI-DAQmx hardware for physical sensor acquisition and stimulus output.

For an initial software-only checkout, use **Simulation Mode** and the predefined simulated sensor responses.

### 7. Run the Calibration

Return to the Main VI and verify that the configured sensors and test status are correct.

Select **Start** to begin the calibration sequence.

During the test, the system:

1. Creates the calibration session and test-run records.
2. Applies the configured stimulus and setpoints.
3. Acquires or simulates multi-channel sensor data.
4. Evaluates settling and steady-state requirements.
5. Processes UUT measurements.
6. Determines calibration-point PASS/FAIL results.
7. Stores test-run, channel, and calibration-point records in SQLite.
8. Continuously logs raw acquisition data to TDMS.

### 8. Review Calibration Results

After the calibration is complete, open the **Analysis Dialog**.

Select:

* **Model Number**
* **Serial Number**
* **Calibration session date/time**

The selected calibration session includes its associated test cycles. The analysis results include:

* **Accuracy %FS**
* **BFSL Linearity %FS**
* **Hysteresis %FS**
* **Repeatability %FS**
* **Overall PASS/FAIL status**

A detailed report can be generated for the selected calibration session and sensor.

[⬆ Back to Top](#top)

---

## 🚀 Getting Started &amp; Execution

### 1. Prerequisites &amp; Dependencies

Before running the Calibration &amp; Test System, ensure the required software and hardware components are installed and configured.

#### Software Requirements

| Component | Requirement |
| :--- | :--- |
| **LabVIEW** | National Instruments LabVIEW |
| **NI-DAQmx** | Required for physical NI data acquisition hardware |
| **Database Tools** | LabVIEW Database Connectivity Toolkit / compatible NI DB API |
| **SQLite** | Local SQLite database engine / compatible driver |
| **Database Viewer** | DB Browser for SQLite (recommended for inspection and maintenance) |
| **ODBC Driver** | SQLite ODBC driver compatible with the LabVIEW architecture when ODBC is used |

### 🔌 Hardware &amp; DAQmx Configuration

When running with physical hardware, the acquisition layer uses NI-DAQmx analog input/output tasks configured from the instrument and channel information stored in the application configuration.

The system has been developed around NI modular DAQ hardware and supports configurations using NI cDAQ chassis and analog input/output modules. Controller, Reference, and UUT channels are treated as distinct measurement roles even when they are physically acquired in the same task.

### 🧪 Simulation Mode

Simulation Mode provides a hardware-independent execution path for validating test sequencing, acquisition, processing, visualization, database logging, and calibration analysis without physical NI hardware.

The simulation uses predefined waveforms embedded in the LabVIEW block diagram, including both **passing** and **failing** sensor responses. These waveforms allow the application to exercise calibration point evaluation, settling and steady-state verification, tolerance-based PASS/FAIL logic, and downstream analysis using repeatable test data.

**Default application behavior:** Simulation Mode initializes to **False**, so the application starts in hardware-oriented operating mode unless Simulation Mode is explicitly enabled.

[⬆ Back to Top](#top)

---

## ⚙️ Configuration &amp; Operational Modes

### Administrator Configuration

The system separates Administrator configuration from the operator's active test setup. A password-protected Administrator interface is available from the Main VI through **Manage Serial Numbers**. The Administrator interface is used to manage registered sensors and operator accounts.

In Version 1.0, model-specific test configurations are maintained directly in the SQLite `TestConfigurations` table using SQL. These configurations define the acquisition and calibration parameters used by the test system for each sensor model.

The Settings interface exposes a read-only **Instrument Configuration** summary for database-derived parameters. These values are not intended to be edited directly by the operator in that view.

The current configuration model includes:

| Parameter | Description |
| :--- | :--- |
| `SensorID` | Unique database identifier for the sensor profile. |
| `TargetSampleRateHz` | Target acquisition sample rate for the configured sensor model. |
| `SteadyStateDurationSec` | Required continuous time within tolerance before a calibration point is successful. |
| `AllowedTolerancePercentFS` | Maximum permitted deviation expressed as a percentage of full scale. |
| `MaxSettlingTimeoutSec` | Maximum total time allowed after a setpoint change to achieve the required steady-state duration. |

`MaxSettlingTimeoutSec` is intentionally separate from `SteadyStateDurationSec`. If a sample leaves the allowed tolerance band, the continuous steady-state timer resets while the overall settling timeout continues.

> **Version 1.0 Note:** New sensor model configurations are currently added or modified directly in the SQLite `TestConfigurations` table using SQL. A dedicated model-configuration interface is planned as a future enhancement.

### Operator Configuration

The operator configures the active measurement and stimulus channels in the Settings dialog.

#### Measurements

**Measurement roles currently include:**

* `Controller`
* `Reference`
* `UUT`

The operator can assign UUT status to any measurement row. The application therefore does not rely on a fixed row number to identify UUTs.

For UUT display, the acquisition layer filters the configured measurement set to UUT channels and passes the associated sensor identity with the waveform data so that the Data Display Loop can label each graph using the correct serial number.

#### Stimulus Outputs

Analog output channels are configured independently from measurement channels. The operator can associate a stimulus role, sensor/model identity, serial number, and DAQmx AO physical channel with the configured output.

### Operational Modes

The application supports two acquisition modes:

| Mode | Description |
| :--- | :--- |
| **Hardware Mode** | Uses NI-DAQmx hardware for physical sensor acquisition and stimulus output. |
| **Simulation Mode** | Generates simulated multi-channel waveforms for development and verification without physical NI hardware. Simulation Mode defaults to **False** when the application starts. |

[⬆ Back to Top](#top)

---

## 📊 Calibration Sequence &amp; Analysis

### Calibration Sequence

A typical static calibration sequence uses an ascending and descending pressure profile. For a 0–100 PSI example:

```text
0 A
25 A
50 A
75 A
100 A
75 D
50 D
25 D
0 D
```

where `A` = Ascending and `D` = Descending.

A complete ascending/descending cycle is stored as one `TestRun`. Multiple TestRuns can belong to the same `CalibrationSessionID` so repeatability can be evaluated across cycles.

### Calibration Point Data

Only **UUT measurement channels** generate records in `CalibrationPoints`. Controller and Reference channels remain available in `TestRunChannels` because they are required to execute and interpret the test, but they do not create independent UUT calibration points.

Each calibration point retains information such as:

```text
PointID
TestRunID
ChannelRecordID
SensorID
Setpoint
ReferenceValue
MeasuredValue
AccuracyPercentFS
PassFail
Timestamp
CycleNumber
Direction
```

### Accuracy

Signed measurement error is calculated as:

```text
Error = MeasuredValue - ReferenceValue
```

Accuracy error expressed as percent of full scale is:

```text
Accuracy %FS = ABS(Error) / FullScale * 100
```

### Linearity / BFSL

Linearity is evaluated using a Best Fit Straight Line (BFSL). For each cycle and direction, reference values are treated as `X` and measured values as `Y`:

```text
Y = Slope * X + Intercept
```

The maximum absolute deviation from the BFSL is normalized to full scale:

```text
Linearity %FS = Maximum Absolute Deviation / FullScale * 100
```

The current Version 1.0 analysis evaluates separate fits for each cycle/direction combination and uses the maximum result as the sensor-level linearity metric.

### Hysteresis

Hysteresis compares ascending and descending measurements at common setpoints:

```text
Hysteresis = ABS(AscendingValue - DescendingValue)
```

Expressed as percent of full scale:

```text
Hysteresis %FS = Hysteresis / FullScale * 100
```

For a 0–100 PSI sequence, the 100 PSI point is used for accuracy but is not treated as a conventional hysteresis comparison point because there is no higher pressure approach for the descending leg.

### Repeatability

Repeatability compares measurements from separate TestRuns at the same:

```text
SensorID + Setpoint + Direction
```

This allows two calibration cycles in one session to be compared without confusing repeatability with hysteresis or channel-record identity.

## 📊 Analysis & Reporting

The **Analysis Dialog** provides access to historical calibration results. Operators select a sensor model, serial number, and calibration session date/time to retrieve previously recorded test results.

The selected calibration session includes all associated test cycles, allowing the system to evaluate the complete calibration using the stored UUT measurement data.

![Analysis Dialog](documentation/Tutorial/AnalyticsFrontPanel.png)

The analysis results include:

* **Accuracy %FS**
* **BFSL Linearity %FS**
* **Hysteresis %FS**
* **Repeatability %FS**
* **Overall PASS/FAIL status**

A detailed report can be generated for the selected calibration session and sensor.

[⬆ Back to Top](#top)

---

## 🖥️ User Interface

### Application Branding

The current application branding is:

**AUTOMATED CALIBRATION &amp; TEST SYSTEM**  
*Multi-Sensor Instrument Calibration Platform*

### Settings Dialog

The Settings dialog is organized into three primary sections:

* **Instrument Configuration** — read-only summary of administrator/database-managed configuration values.
* **Measurements (AI)** — operator assignment of measurement roles, model numbers, serial numbers, and DAQmx AI physical channels.
* **Stimulus Outputs (AO)** — operator assignment of output roles, model numbers, serial numbers, and DAQmx AO physical channels.

The Instrument Configuration indicators use an asterisk to identify values maintained in the database by an Administrator.

### Data Display

The real-time data display currently emphasizes UUT waveforms. Since UUTs may appear in any configured measurement row, UUT filtering is performed before the display data is sent to the Data Notifier.

The display payload associates each UUT waveform with its sensor serial number so the legend can use labels such as:

```text
SN: 456
SN: 457
```

rather than generic plot names.

### Analysis Dialog

The Analysis Dialog provides historical result selection and analysis, including:

* Model Number
* Serial Number
* Calibration session date/time
* Overall PASS/FAIL result
* Maximum error metrics for Accuracy, Linearity, Hysteresis, and Repeatability

The Analysis Dialog can be opened from the main application and closed through its dedicated UI controls.

[⬆ Back to Top](#top)

---

## 🛠 Tech Stack &amp; Dependencies

| Component | Technology / Library | Purpose |
| :--- | :--- | :--- |
| **Core Application** | LabVIEW | UI, message loops, test sequencer, acquisition, processing, and analysis |
| **Data Acquisition** | NI-DAQmx | Physical analog input/output acquisition |
| **Simulation Engine** | LabVIEW Formula Nodes / waveform generation | Hardware-independent test and calibration simulation |
| **Database Engine** | SQLite | Persistent configuration, test execution, channel mapping, and calibration results |
| **Database API** | LabVIEW Database Connectivity / DB Tools | SQL execution, transactions, and data exchange |
| **Raw Data Logging** | TDMS | Continuous acquisition data logging |
| **Version Control** | Git / Git Bash | Source control and traceable development history |

[⬆ Back to Top](#top)

---

## 🛡️ Error Handling &amp; Fault Management

* **Error Cluster Propagation:** LabVIEW error clusters are propagated through major acquisition, processing, and database operations.
* **Relational Integrity:** Calibration points maintain a valid relationship to the associated TestRun and UUT channel records.
* **Database Key Management:** SQLite generates primary keys where appropriate, while foreign keys preserve links between sessions, runs, channels, sensors, and points.
* **Execution Synchronization:** Acquisition and processing are synchronized around test-sequence updates using a newly changed cycle, direction, or setpoint context and ensuring stale waveform data has been flushed.
* **Settling Timeout Protection:** A point cannot remain in the waiting state indefinitely; failure occurs when the configured maximum settling timeout is reached before the required continuous steady-state duration is achieved.
* **Processing Stop Control:** The processing loop uses an explicit stop-state concept to terminate point-level processing after the required calibration point work has completed.
* **UUT Filtering:** Controller and Reference channels are excluded from `CalibrationPoints` so that only UUT measurements are evaluated as calibration results.
* **PASS/FAIL Isolation:** Calibration measurements and PASS/FAIL results are determined in the Processing Loop before results are passed to the Database Loop for persistence. Database write operations store the result without affecting the analytical outcome.

[⬆ Back to Top](#top)

---

## 📂 Directory Structure

*(Details will be added in a later update once the module hierarchy is finalized.)*

[⬆ Back to Top](#top)

---

## 🗄️ Data Persistence &amp; Database Schema

### 💾 Data Persistence &amp; File Outputs

The system uses a local SQLite database to persist configuration and calibration execution data. The database maintains relationships between sensor definitions, calibration sessions, test runs, physical channels, and individual calibration points.

Raw acquisition data is handled separately from structured calibration records. Continuous raw waveform can be maintained in TDMS while processed calibration results are persisted to SQLite.

The Analysis Dialog retrieves historical results from SQLite and derives user-facing summary metrics from the stored calibration points.

### 🗄️ SQLite Database Schema

The principal relational entities are:

```text
Sensors
   │
   ├───────────────┐
   │               │
   ▼               ▼
TestConfigurations   TestRunChannels
                       │
                       ▼
                    TestRuns
                       │
                       ▼
                CalibrationPoints
                       ▲
                       │
              CalibrationSessions
```

The following definitions represent the current core schema used by the application. Additional implementation-specific columns may exist in the working database as the project evolves.

#### Sensors

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

#### TestConfigurations

```sql
CREATE TABLE IF NOT EXISTS TestConfigurations (
    ModelNumber TEXT PRIMARY KEY,
    TargetSampleRateHz REAL,
    SteadyStateDurationSec REAL NOT NULL,
    AllowedTolerancePercentFS REAL NOT NULL,
    MaxSettlingTimeoutSec REAL NOT NULL
);
```

`AllowedTolerancePercentFS` is explicitly expressed as a percentage of full scale.

#### CalibrationSessions

```sql
CREATE TABLE IF NOT EXISTS CalibrationSessions (
    CalibrationSessionID INTEGER PRIMARY KEY AUTOINCREMENT,
    SessionStartTime TEXT
);
```

A calibration session groups the TestRuns that belong to one multi-cycle calibration operation.

#### TestRuns

```sql
CREATE TABLE IF NOT EXISTS TestRuns (
    TestRunID INTEGER PRIMARY KEY AUTOINCREMENT,
    RunStartTime TEXT,
    OperatorID INTEGER,
    TestResult TEXT,
    CalibrationSessionID INTEGER
);
```

A `TestRun` represents one complete ascending/descending cycle. `CalibrationSessionID` associates multiple TestRuns with the same calibration session.

#### TestRunChannels

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

`MeasurementRole` identifies how the channel participates in the test, such as `Controller`, `Reference`, or `UUT`.

#### CalibrationPoints

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

Only UUT channels create `CalibrationPoints` records. Controller and Reference records remain represented through `TestRunChannels`.

### Session-Level Analysis Query Concept

The Analysis Dialog treats a calibration session as the unit of historical selection. To display only the first run time for each session, the query selects the earliest `RunStartTime` associated with each `CalibrationSessionID`:

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

This prevents the second cycle from appearing as a separate calibration date while preserving the full session for downstream analysis.

[⬆ Back to Top](#top)
