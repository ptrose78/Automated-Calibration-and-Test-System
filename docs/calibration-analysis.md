# 📊 Calibration Sequence &amp; Analysis

## Overview

The Automated Calibration & Test System evaluates calibration performance from stored UUT measurement data.

The current analysis metrics are:

- Accuracy %FS
- BFSL Linearity %FS
- Hysteresis %FS
- Repeatability %FS
- Overall PASS/FAIL status

The Analysis Dialog allows the operator to select a sensor model, serial number, and calibration session, retrieve the associated test cycles, and generate the calibration results.

## Calibration Sequence

A typical static calibration sequence uses ascending and descending setpoints.

For a 0–100 PSI example:

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

where:

- `A` = Ascending
- `D` = Descending

A complete ascending/descending cycle is stored as one `TestRun`.

Multiple `TestRuns` can be grouped under a single `CalibrationSessionID`. This session-level grouping allows multiple cycles to be analyzed together for repeatability.

## Calibration Point Data

Only UUT measurement channels generate records in `CalibrationPoints`.

Controller and Reference channels remain represented in `TestRunChannels` because they are required to execute and interpret the test, but they do not create independent UUT calibration points.

A calibration point retains information such as:

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

## Full Scale
```text
Full Scale = MaxMeasurement - MinMeasurement
```

## Accuracy

### Measurement Error

Signed measurement error is calculated as:

```text
Error = MeasuredValue - ReferenceValue
```

### Accuracy %FS

Accuracy error is expressed as a percentage of full scale:

```text
Accuracy %FS = ABS(Error) / FullScale * 100
```

## BFSL Linearity

### Best Fit Straight Line

Linearity is evaluated using a **Best Fit Straight Line (BFSL)**.

For each cycle and direction, reference values are treated as `X` and measured values as `Y`:

```text
Y = Slope * X + Intercept
```

### Linearity %FS

The maximum absolute deviation from the BFSL is normalized to full scale:

```text
Linearity %FS = Maximum Absolute Deviation / FullScale * 100
```

The current Version 1.0 analysis evaluates separate fits for each cycle/direction combination and uses the maximum result as the sensor-level linearity metric.

## Hysteresis

Hysteresis compares ascending and descending measurements at common setpoints:

```text
Hysteresis = ABS(AscendingValue - DescendingValue)
```

### Hysteresis %FS

Expressed as a percentage of full scale:

```text
Hysteresis %FS = Hysteresis / FullScale * 100
```

For a 0–100 PSI sequence, the 100 PSI point is used for accuracy but is not treated as a conventional hysteresis comparison point because there is no corresponding descending-leg measurement at that endpoint.

## Repeatability

Repeatability compares measurements from separate `TestRuns` at the same:

```text
SensorID + Setpoint + Direction
```

```text
Repeatability = ABS(TestRunTwo - TestRunOne)
```
### Repeatability %FS

Expressed as a percentage of full scale:

```text
Repeatability %FS = Repeatability/ FullScale * 100
```

This allows multiple calibration cycles within one session to be compared without confusing repeatability with hysteresis.

## PASS/FAIL Evaluation

Calibration-point PASS/FAIL evaluation is performed during test processing.

The calibration measurements are evaluated against the configured model-specific `%FS` tolerance.

The relevant test configuration parameters include:

- `AllowedTolerancePercentFS`
- `SteadyStateDurationSec`
- `MaxSettlingTimeoutSec`

A calibration point must remain within the configured tolerance continuously for the required steady-state duration before it is considered successful.

If the measurement leaves the allowed tolerance band, the continuous steady-state timer resets while the overall settling timeout continues.

If the required steady-state condition is not achieved before the maximum settling timeout, the point fails.

## Calibration Sessions and Repeatability

A calibration session groups the test runs that comprise a complete multi-cycle calibration.

For example:

```text
Calibration Session
│
├── TestRun 1
│   └── Ascending + Descending Cycle
│
└── TestRun 2
    └── Ascending + Descending Cycle
```

The session-level grouping prevents each cycle from appearing as a separate historical calibration while preserving the individual runs for repeatability analysis.

## Analysis Workflow

The Analysis Dialog provides the following workflow:

1. Select the **Model Number**.
2. Select the **Serial Number**.
3. Select the **Date** for the calibration session.
4. Select **Generate Results**.
5. Review Accuracy, BFSL Linearity, Hysteresis, Repeatability, and overall PASS/FAIL results.
6. Generate the detailed calibration report.

## Report Generation

The current application automatically generates a detailed report for the selected calibration session and sensor after the results are generated.

The report is based on the stored calibration results associated with the selected session.

## Analysis Design Principles

The analysis architecture is intended to:

- preserve the relationship between measured values and the source UUT channel
- distinguish ascending/descending behavior from repeatability across separate test runs
- normalize applicable error metrics to full scale
- analyze a complete calibration session as a single historical unit
- preserve the underlying measurement records while deriving user-facing metrics

## Related Documentation

- [System Architecture](architecture.md)
- [Database Schema](database-schema.md)

---

[⬆ Back to README](../README.md)
