# Device management interfaces

Windows IoT Core devices can be managed via Azure IoT Hub. All device management operation are implemented via the Azure IoT Hub [direct methods](<https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-direct-methods>) and the [device twin](<https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-device-twins>).


## Direct Methods

Some device management actions are initiated by the _direct methods_. Direct methods work best for _ad hoc_ management of a small number of devices that are online and able to respond to commands immediately.

The methods start with the `microsoft.management` prefix followed by the method name. The method payload (when non-empty) is in JSON format. The return payload (if not empty) is also in JSON format.

Example:

```
microsoft.management.transmogrify
```

The payload for a method can look as follows:
```
"parameter" : "value"
```

The exact specification for each device management operation is defined in the [Specification](#specification) below.

## Device Twin

Certain device management operations are initiated by _desired properties_ set from the IoT Hub. Desired properties can be used to managed multiple devices regardless of whether each device is online. Desired properties do not offer an immediate response. Instead, devices that perform an action based on desired properties communicate their status using the _reported properties_. The reported and the desired properties together make up the _device twin_.

For example, some configuration settings are set by the desired properties as depicted in the example below:

```
"desired": {
    "microsoft" : { 
        "management" : {
            "key1" : value1,
            "key2" : value2,
            ...
        }
    }
    ...
}
```

## Specification

The specification for each device management capability is provided below.

### Direct Methods

The operations initiated by the direct methods are as follows:

- [Report All Device Properties](report-all-device-properties.md)
- [Immediate Reboot](immediate-reboot.md)
- [Install App](install-app.md)
- [Primary App Self-Update](app-self-update.md)

### Device Twin

The operations supported by the device twin are as follows:

- [Scheduled Reboot](scheduled-reboot.md)
- [Store Update Configuration](store-update-config.md)
- [App Management](app-management.md)
