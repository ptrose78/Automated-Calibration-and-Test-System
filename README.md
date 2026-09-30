<a name="top"></a>

<div align="center">
  <h1>Automated Calibration &amp; Test System</h1>
  <p><strong>Multi-Sensor Instrument Calibration Platform</strong></p>
</div>

An automated, database-driven instrumentation test and calibration system built in **LabVIEW**, with an integrated **SQLite relational database** for configuration, test sequencing, acquisition, processing, calibration analysis, and persistent results storage.

The system is designed to support multi-sensor calibration workflows, coordinated stimulus generation, real-time data acquisition and visualization, steady-state and settling verification, deterministic PASS/FAIL evaluation, relational data logging, and post-test calibration analysis.

---

## 📑 Table of Contents

- [🔑 Key Features](#-key-features)
- [📋 Requirements](#-requirements)
- [⚡ Installation](#-installation)
- [⚡ Quick Start](#-quick-start)
- [⚙️ Operating Modes](#️-operating-modes)
- [📸 System Architecture](#-system-architecture)
- [📚 Documentation](#-documentation)
- [🖥️ User Interface](#-user-interface)
- [💾 Data & Outputs](#-data--outputs)
- [🛡️ Error Handling & Reliability](#-error-handling--reliability)
- [🛠️ Technology Stack](#️-technology-stack)
- [📌 Project Status & Limitations](#-project-status--limitations)
- [📄 License](#-license)

---

## 🔑 Key Features

- **Multi-Sensor Calibration:** Supports multiple UUTs in a single test configuration while preserving sensor identity through `SensorID`, serial number, and channel records.
- **Database-Driven Configuration:** Sensor models, sample rates, settling requirements, tolerance limits, and other test parameters are retrieved from SQLite rather than hard-coded into the test sequence.
- **Simulation Mode:** Provides a hardware-independent acquisition path using predefined passing and failing sensor waveforms for development and verification.
- **Hardware Acquisition:** Supports physical acquisition using NI-DAQmx.
- **Automated Test Sequencing:** Supports ascending and descending calibration profiles with explicit cycle number and direction tracking.
- **PASS/FAIL Evaluation:** Calibration measurements are evaluated against model-specific `%FS` tolerance limits.
- **Calibration Analytics:** Calculates accuracy, Best Fit Straight Line (BFSL) linearity, hysteresis, and repeatability metrics from stored calibration points.
- **Analysis Dialog:** Operators can select Model Number, Serial Number, and calibration session date to retrieve and analyze historical calibration results.

[⬆ Back to Top](#top)

---

## 📋 Requirements

### Software Requirements

| Component | Requirement |
| :--- | :--- |
| **LabVIEW** | National Instruments LabVIEW |
| **NI-DAQmx** | Required for operation with physical NI data acquisition hardware |
| **Database Tools** | LabVIEW Database Connectivity Toolkit / compatible NI DB API |
| **SQLite** | SQLite database support required by the application |
| **ODBC Driver** | Required only when the database configuration uses ODBC |

### Hardware Requirements

Physical operation requires compatible NI-DAQmx hardware. The system has been developed around NI modular DAQ hardware, including NI cDAQ chassis and analog input/output modules.

### Configuration & Development Tools

| Tool | Purpose |
| :--- | :--- |
| **DB Browser for SQLite** | Used for Version 1.0 database configuration and database inspection |
| **Git / Git Bash** | Source control and development |

[⬆ Back to Top](#top)

---

## ⚡ Installation

1. Install the required software and drivers listed in [Requirements](#-requirements).
2. Clone the repository.
3. Open the LabVIEW project file.
4. Configure `SystemConfig.ini`.
5. Configure the SQLite database.
6. Run the Main VI.

> **Note:** Version 1.0 uses DB Browser for SQLite and SQL statements for initial database configuration. See the [Quick Start](#-quick-start) workflow for the required setup sequence.

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

- `ModelNumber`
- `TargetSampleRateHz`
- `SteadyStateDurationSec`
- `AllowedTolerancePercentFS`
- `MaxSettlingTimeoutSec`

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

### 4. Configure a Controller

The system stores controller-specific configuration information in the SQLite `Controllers` table. A controller must be configured before it can be selected and used in the Settings interface.

For Version 1.0, new controller configurations are added directly to the SQLite `Controllers` table using SQL.

Each controller configuration defines:

- `Manufacturer`
- `ModelNumber`
- `SerialNumber`
- `MinValue`
- `MaxValue`
- `Units`
- `InputSignalType`
- `InputSignalMin`
- `InputSignalMax`

These parameters identify the controller and define its operating range and input signal configuration.

▶️ **[Watch the Quick Start video: Configure a Controller](https://www.youtube.com/watch?v=sDv8Sn0-mkE)**

### 5. Register the Sensor

From the Main VI, select **Manage Serial Numbers**.

1. Select a configured model number.
2. Enter the sensor serial number.
3. Enter the sensor's minimum and maximum measurement range.
4. Enter the engineering units.
5. Enter the sensor output signal.
6. Save the sensor record.

The sensor is stored in the SQLite `Sensors` table. Measurement role and physical acquisition-channel assignment are performed later in the Settings interface.

▶️ **[Watch the Quick Start video: Register the Sensor](https://www.youtube.com/watch?v=BjLVVS2KBrU)**

### 6. Register the Operator

From the Main VI, select **Manage Operators**.

1. Enter the operator's first and last name.
2. Save the operator record.

The operator is stored in the SQLite `Operators` table and can be used for operator identification within the application.

▶️ **[Watch the Quick Start video: Register the Operator](https://www.youtube.com/watch?v=EPBDVxanazg)**

### 7. Configure the Test

Open **Settings** from the Main VI to configure the instruments used during the calibration test.

Under **Instrument Configuration**, review the read-only summary of the current measurement configuration and database-configured test parameters. Values marked with an asterisk (`*`) are **database-configured values maintained by an Administrator**. These parameters include the target sample rate, steady-state duration, allowed tolerance, and maximum settling timeout.

> `*` Database-configured values. Maintained by an Administrator.

Under **Measurements (AI)**, configure the sensors used to measure the test condition:

1. Select the registered sensor used as the **Reference** sensor and assign its NI-DAQmx physical acquisition channel.
2. Select the first registered **UUT (Unit Under Test)** sensor and assign its NI-DAQmx physical acquisition channel.
3. Select the second registered **UUT** sensor and assign its NI-DAQmx physical acquisition channel.

The **Reference sensor** provides the reference measurement used to evaluate the UUT sensors. The two **UUT sensors** are the devices being evaluated during the calibration.

Under **Stimulus Outputs (AO)**, select the configured controller and assign its NI-DAQmx physical output channel. The controller is used to apply and control the test stimulus, such as pressure.

The test configuration is now ready for the next step.

▶️ **[Watch the Quick Start video: Configure the Test](https://www.youtube.com/watch?v=tpZwP3x1pj8)**

### 8. Run the Calibration

From the Main VI, select the appropriate operating mode.

For an initial software-only checkout, enable **Simulation Mode** to **ON** on the Main VI front panel and use the predefined simulated sensor responses.

Verify that the configured measurement sensors, controller, and test configuration are correct, then select **Start** to begin the calibration sequence.

During the test, the system:

1. Creates the calibration session and test-run records.
2. Applies the configured stimulus and setpoints.
3. Acquires or simulates multi-channel sensor data.
4. Evaluates settling and steady-state requirements.
5. Processes UUT measurements.
6. Determines calibration-point PASS/FAIL results.
7. Stores test-run, channel, and calibration-point records in SQLite.
8. Continuously logs raw acquisition data to TDMS.

▶️ **[Watch the Quick Start video: Run the Calibration](https://www.youtube.com/watch?v=7ZdO1xC_DXU)**

### 9. Review Calibration Results

After the calibration is complete, select **Get Analytics** on the Main VI.

In the Analysis Dialog window, select:

- **Model Number**
- **Serial Number**
- **Date**

The selected calibration session includes its associated test cycles. Select **Generate Results** to calculate the analysis results:

- **Accuracy %FS**
- **BFSL Linearity %FS**
- **Hysteresis %FS**
- **Repeatability %FS**
- **Overall PASS/FAIL status**

A detailed report is automatically generated for the selected calibration session and sensor.

▶️ **[Watch the Quick Start video: Review Calibration Results](https://www.youtube.com/watch?v=Ff5iCqyaV9M)**

[⬆ Back to Top](#top)

---

## ⚙️ Operating Modes

The application supports two acquisition modes:

| Mode | Description |
| :--- | :--- |
| **Hardware Mode** | Uses NI-DAQmx hardware for physical sensor acquisition and stimulus output. |
| **Simulation Mode** | Generates simulated multi-channel waveforms for development and verification without physical NI hardware. |

Simulation Mode provides a hardware-independent execution path for validating test sequencing, acquisition, processing, visualization, database logging, and calibration analysis.

The simulation uses predefined **passing** and **failing** sensor waveforms for repeatable development and verification.

**Default application behavior:** Simulation Mode initializes to **False** when the application starts.

[⬆ Back to Top](#top)

---

## 📸 System Architecture

The system uses dedicated LabVIEW execution loops for test sequencing, data acquisition, processing, visualization, database persistence, and calibration analysis. This architecture supports coordinated multi-sensor testing, deterministic test progression, and traceable calibration results.

```text
┌──────────────────────────────────────────────────────────────────────────────┐
│                          Main Application UI                                 │
│                                                                              │
│                    Operator controls and test status                         │
└───────────────────────────────────┬──────────────────────────────────────────┘
                                    │
                                    │ UI commands / events
                                    ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                            UI Message Loop                                   │
│                                                                              │
│           Handles operator commands and application windows                 │
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
│              Handles continuous multi-channel data acquisition               │
└──────────────────────────────────────┬───────────────────────────────────────┘
                                       │
              ┌────────────────  Waveform Data ──────────────────┐
              │                        │                         │
              │                        │                         │
              ▼                        ▼                         ▼
┌─────────────────────────┐ ┌───────────────────────┐ ┌──────────────────────┐
│     Processing Loop     │ │    Logging Loop       │ │  Data Display Loop   │
│                         │ │                       │ │                      │
│ Evaluates measurements, │ │ Logs raw acquisition  │ │ Displays real-time   │
│ determines point        │ │ waveforms to TDMS     │ │ UUT waveforms        │
│ PASS/FAIL, and creates  │ │ for persistent        │ │                      │
│ calibration point       │ │ storage               │ │                      │
│ records                 │ │                       │ │                      │
└────────────┬────────────┘ └────────────┬──────────┘ └──────────────────────┘
             │                           │
             │ Calibration point         │ Raw acquisition data
             │ records                   │
             ▼                           ▼
┌──────────────────────────────┐ ┌────────────────────────────────┐
│        Database Loop         │ │      TDMS Data Stream          │
│                              │ │                                │
│ Persists configuration and  │ │ Stores continuous raw waveform │
│ calibration data in SQLite  │ │ data independently from        │
│                              │ │ processed calibration results  │
└──────────────┬───────────────┘ └────────────────────────────────┘
               │
               │ Stored calibration session data
               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                         Calibration Analysis                                 │
│                                                                              │
│              Calculates calibration performance metrics                     │
└───────────────────────────────────┬──────────────────────────────────────────┘
                                    │
                                    │ Analysis results
                                    ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                          Analysis & Reporting                                │
│                                                                              │
│                    Displays results and generates reports                    │
└──────────────────────────────────────────────────────────────────────────────┘
```

[⬆ Back to Top](#top)

---

## 📚 Documentation

For detailed technical information, see:

- [System Architecture](docs/architecture.md)
- [Database Schema](docs/database-schema.md)
- [Calibration Analysis](docs/calibration-analysis.md)

[⬆ Back to Top](#top)

---

## 🖥️ User Interface

### Settings Dialog

The Settings dialog is organized into three primary sections:

- **Instrument Configuration** — read-only summary of the current measurement configuration and database-configured test parameters. Values marked with an asterisk (`*`) are maintained by an Administrator.
- **Measurements (AI)** — operator assignment of measurement roles, model numbers, serial numbers, and DAQmx AI physical channels.
- **Stimulus Outputs (AO)** — operator assignment of the controller and NI-DAQmx AO channel used to command the controller.

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

- Model Number
- Serial Number
- Date
- Overall PASS/FAIL result
- Maximum error metrics for Accuracy, Linearity, Hysteresis, and Repeatability

The Analysis Dialog can be opened from the Main VI and closed through its dedicated UI controls.

[⬆ Back to Top](#top)

---

## 💾 Data & Outputs

The system uses separate storage mechanisms for structured calibration data, raw acquisition data, and generated reports.

### SQLite Database

SQLite stores configuration and structured test data, including:

- Sensor definitions
- Sensor model test configurations
- Controller configurations
- Operator records
- Calibration sessions
- Test runs
- Test-run channel assignments
- Calibration point results

### TDMS Data

Raw acquisition waveforms are logged continuously to **TDMS** independently from the processed calibration results stored in SQLite.

### Calibration Reports

The Analysis Dialog uses stored calibration results to calculate performance metrics and automatically generate a detailed report for the selected calibration session and sensor.

[⬆ Back to Top](#top)

---

## 🛡️ Error Handling & Reliability

- **Error Cluster Propagation:** LabVIEW error clusters are propagated through major operations.
- **Database Key Management:** Database relationships are defined using foreign keys.
- **Data Integrity:** Calibration results are evaluated before database persistence.
- **Settling Timeout Protection:** Settling operations are bounded by a configurable timeout.

[⬆ Back to Top](#top)

---

## 🛠️ Technology Stack

| Technology | Purpose |
| :--- | :--- |
| **LabVIEW** | Application UI, message-driven execution, test sequencing, acquisition, processing, and analysis |
| **NI-DAQmx** | Physical analog input/output acquisition |
| **SQLite** | Configuration, test execution, channel mapping, and calibration result storage |
| **LabVIEW Formula Nodes / Waveform Generation** | Hardware-independent simulation |
| **TDMS** | Continuous raw acquisition data logging |
| **Git / Git Bash** | Source control and development |

[⬆ Back to Top](#top)

---

## 📌 Project Status & Limitations

**Version 1.0**

- Sensor model test configurations are currently added or modified directly in the SQLite `TestConfigurations` table using SQL.
- Controller configurations are currently added directly to the SQLite `Controllers` table using SQL.
- Simulation Mode uses predefined passing and failing sensor waveforms for development and verification.
- Physical operation requires compatible NI-DAQmx hardware and appropriate channel configuration.

[⬆ Back to Top](#top)

---

## 📄 License

This repository does not currently specify an open-source license. No permission is granted by the repository to use, modify, or redistribute the software beyond any rights provided by applicable law.

[⬆ Back to Top](#top)
