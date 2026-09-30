# 📸 System Architecture

## Overview

The Automated Calibration & Test System uses dedicated LabVIEW execution loops for test sequencing, data acquisition, processing, visualization, database persistence, and calibration analysis. This message-driven architecture supports coordinated multi-sensor testing, deterministic test progression, and traceable calibration results.

The primary execution components are:

- Main Application UI
- UI Message Loop
- Test Sequencer
- Acquisition Loop
- Processing Loop
- Logging Loop
- Data Display Loop
- Database Loop
- Calibration Analysis
- Analysis & Reporting

## System Data Flow

The system separates test sequencing, acquisition, processing, user-interface messaging, data display, database persistence, and calibration analysis into cooperating LabVIEW execution loops. This architecture allows the application to coordinate multiple sensors while maintaining deterministic test progression and persistent traceability of calibration results.
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

## Execution Components

| Component | Responsibility |
| :--- | :--- |
| **Main Application UI** | Provides operator controls and displays test status. |
| **UI Message Loop** | Handles operator commands and application windows. |
| **Test Sequencer** | Controls test progression, setpoints, cycle number, direction, and test state. |
| **Acquisition Loop** | Acquires or simulates continuous multi-channel measurement data. |
| **Processing Loop** | Evaluates measurements, determines calibration-point PASS/FAIL results, and creates calibration-point records. |
| **Logging Loop** | Continuously stores raw acquisition waveforms in TDMS. |
| **Data Display Loop** | Displays real-time UUT waveforms. |
| **Database Loop** | Persists configuration and calibration data in SQLite. |
| **Calibration Analysis** | Calculates post-test calibration performance metrics from stored results. |
| **Analysis & Reporting** | Displays calibration results and generates reports. |

## Acquisition

The Acquisition Loop provides the common acquisition path for both operating modes:

- **Hardware Mode** uses NI-DAQmx for physical analog input/output acquisition.
- **Simulation Mode** provides predefined simulated sensor waveforms without physical NI hardware.

The architecture allows the downstream processing and analysis paths to operate on acquired or simulated measurement data.

## Test Sequencing

The Test Sequencer is responsible for authoritative test progression. It manages:

- Setpoints
- Cycle number
- Direction
- Point transitions
- Test state

A typical static calibration sequence uses ascending and descending setpoints. A complete ascending/descending cycle is stored as one `TestRun`. Multiple `TestRuns` can be grouped into a `CalibrationSessionID`.

## Processing

The Processing Loop consumes acquisition data and evaluates measurements against the configured calibration requirements.

Its responsibilities include:

- evaluating settling and steady-state requirements
- applying tolerance criteria
- determining calibration-point PASS/FAIL results
- creating processed calibration-point records for UUT channels

Only UUT measurement channels generate records in `CalibrationPoints`. Controller and Reference channels remain represented in `TestRunChannels`.

## Visualization

The Data Display Loop provides the real-time UUT waveform display.

UUTs may appear in any configured measurement row. The display path associates each UUT waveform with its sensor serial number so the graph legend can identify the corresponding sensor rather than using generic plot names.

## Logging and Persistence

The application separates raw acquisition logging from structured calibration data:

- **TDMS** stores continuous raw acquisition waveforms.
- **SQLite** stores configuration, test execution, channel assignment, calibration sessions, and processed calibration results.

This separation allows raw waveform data to be retained independently of the processed results used by the calibration analysis.

## Calibration Analysis

Calibration Analysis operates on stored calibration-point data and calculates the performance metrics used by the application:

- Accuracy
- BFSL Linearity
- Hysteresis
- Repeatability

The analysis is performed after the calibration session has been stored and does not modify the underlying measurement records.

## Architectural Design Goals

The architecture is intended to provide:

- separation of responsibilities between major execution loops
- coordinated multi-sensor testing
- deterministic test progression
- hardware-independent simulation
- persistent calibration traceability
- separation of raw acquisition data from processed calibration results

## Implementation Notes

The current README documents the major execution loops and the Data Notifier used for UUT display data. Lower-level LabVIEW implementation details should be documented here as the architecture evolves rather than in the main README.

---

[⬆ Back to README](../README.md)
