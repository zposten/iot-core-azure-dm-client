# App Management Using Device Twin

Device Management client supports declarative app management with Azure IoT Hub device twin. The `"desired.microsoft.management.apps"` property represents the desired state of the apps installed on the device. The DM client compares that state with the actual state (by performing an inventory of the apps installed on the device) and makes up the difference.

## Desired Properties

The `"desired.microsoft.management.apps"` property is defined like this:

<pre>
"desired" : {
    "microsoft" : {
        "management" : {
            "apps" : {
                "<i>packageFamilyName1</i>" : {
                    "version" : "<i>see below</i>",
                    "source" : "<i>see below</i>"
                }
                <i>[,...]</i>
            }
        }
    }
}
</pre>

### Details

The `"desired.microsoft.management.apps"` property has a list of apps that are tracked (though not necessarily installed) on the device. Every app is defined by its Package Family Name.

Each `"apps"` value can be either `null` or have the properties as described below.

- If the value is `null`, the state of the app will no longer be tracked in the reported properties. This is mainly used to clean up the reported state.
- Otherwise, if the value is not `null`, it has the following properties:
    - `"version"`: this property can take one of several forms:
        - Package version formatted as <b>Major.Minor.Build</b>. This indicates the required version. If this version of the app is already installed on the device, the other properties are ignored and no install/update is attempted.
        - `"?"` : the version of the app is unknown. The actual version will be reported in reported properties as defined below.
        - `"not installed"` : The app must not be installed on the device. If it is already installed, the DM client will uninstall it.
    - `"source"`: this property is used for apps installed from the blob storage. The value is formatted as `"container\blob"`. The access to the blob storage is performed as described [here](blob-storage.md). If the property is not present, the source for the app is assumed to be the AppStore.

### Update Frequency

The DM client performs the update check according to the [Store Update Configuration](store-update-config.md). The update check is not performed each time a value in `"desired.microsoft.management.apps"` changes.

## Reported Properties

The DM client maintains the inventory of installed apps in the `"reported.microsoft.management.apps"` property. Only the apps listed in the `"desired.microsoft.management.apps"` property with non-`null` value are reported.

### Successful Case

If the DM client is able to bring the actual state in compliance with the desired state, the format of the `"reported.microsoft.management.apps"` property is as follows:

<pre>
"reported" : {
    "microsoft" : {
        "management" : {
            "apps" : {
                "<i>packageFamilyName1</i>" : {
                    "version" : "<i>see below</i>",
                    "installedDate" : "<i>Datetime in ISO 8601 format, UTC</i>"
                }
                <i>[,...]</i>
            }
        }
    }
}
</pre>

The reported `"version"` value can take one of several forms:
- Value formatted as <b>Major.Minor.Build</b> is reported for a currently installed app.
- Value `"not installled"` is reported for apps that are tracked but is not installed.

The reported `"installedDate"` property is not present if the value of `"version"` is `"not installed"`.

Only the apps that are tracked in `"desired.microsoft.management.apps"` are listed in `"reported.microsoft.management.apps"`. 

### Unsuccessful Case

If the DM client is not able to bring the actual state in compliance with the desired state, the failure is reported in the `"reported.microsoft.management.apps"` property for each app. For example, this happens if the DM client is not able to install a requested version of the app, or when the app could not be uninstalled. 

The format of the unsuccessful is as follows:

<pre>
"reported" : {
    "microsoft" : {
        "management" : {
            "apps" : {
                "<i>packageFamilyName1</i>" : {
                    ...
                    "error" : "<i>see below</i>"
                }
                <i>[,...]</i>
            }
        }
    }
}
</pre>

The value of the `"error"` property is a string in implementation-defined format (for example, it could be an error message, the exception text or a call stack).

Not the that the `"error"` property can coexist with the `"version"` property. If an app cannot be updated, the reported properties will still have the actual version. However, if the app cannot be installed at all, the `"version"` will not appear at all.

## Examples

### Example 1

The operator wishes to ensure that the Toaster app (with package family name `23983CETAthensQuality.IoTToasterSample`) and the GardenSprinkler app (`GardenSprinkler_kay8908908`) are installed on the device. Additionally, the operator wants to have the DogFeeder app (`DogFeeder_80615fge`) uninstalled from the device:

```
"desired" : {
    "microsoft" : {
        "management" : {
            "apps" : { 
                "23983CETAthensQuality.IoTToasterSample" : {
                    "version" : "1.1.0",
                },
                "GardenSprinkler_kay8908908" : {
                    "version" : "2.0.0",
                },
                "DogFeeder_80615fge" : {
                    "version" : "not installed",
                }
            }
        }
    }
}
```

The client determines the required set of actions, performs them and updates the `"reported.microsoft.management.apps"` property as follows:

```
"reported" : {
    "microsoft" : {
        "management" : {
            "apps" : { 
                "23983CETAthensQuality.IoTToasterSample" : {
                    "version" : "1.1.0",
                    "installedDate" : "2017-02-25T09:00:00+00:00"
                },
                "GardenSprinkler_kay8908908" : {
                    "version" : "2.0.0",
                    "installedDate" : "2017-02-25T09:15:00+00:00"
                },
                "DogFeeder_80615fge" : {
                    "version" : "not installed",
                }                
            }
        }
    }
}
```

### Example 2

In the following example, the operator wishes to stop tracking the state of the DogFeeder app, which has been decommissioned. This is expressed as follows:

```
"desired" : {
    "microsoft" : {
        "management" : {
            "apps" : { 
                "23983CETAthensQuality.IoTToasterSample" : {
                    "version" : "1.1.0"
                },
                "GardenSprinkler_kay8908908" : {
                    "version" : "2.0.0"
                },
                "DogFeeder_80615fge" : null
            }
        }
    }
}
```

After this, the reported properties look like this:

```
"reported" : {
    "microsoft" : {
        "management" : {
            "apps" : { 
                "23983CETAthensQuality.IoTToasterSample" : {
                    "version" : "1.1.0",
                    "installedDate" : "2017-02-25T09:00:00+00:00"
                },
                "GardenSprinkler_kay8908908" : {
                    "version" : "2.0.0",
                    "installedDate" : "2017-02-25T09:15:00+00:00"
                }              
            }
        }
    }
}
```

Notice that the DogFeeder app is no longer present in the list.

### Example 3

Next, the operator wishes to upgrade the Toaster app to version 2.0.0 using the appx file stored in the Azure storage located at `AppContainer/Toaster.appx`:

```
"desired" : {
    "microsoft" : {
        "management" : {
            "apps" : { 
                "23983CETAthensQuality.IoTToasterSample" : {
                    "source" : "AppContainer/Toaster.appx",
                    "version" : "2.0.0"
                },
                ...
            }
        }
    }
}
```

If the installation fails (for example, if Toaster.appx specified in the `"source"` property is not present or does not contain app version 2.0.0), the error is reported as follows:

```
"reported" : {
    "microsoft" : {
        "management" : {
            "apps" : { 
                "23983CETAthensQuality.IoTToasterSample" : {
                    "error" : "Cannot install app; The app version in Toaster.appx is 1.5.0; desired version is 2.0.0"
                },
                ...             
            }
        }
    }
}
```

### Example 4

When an operator needs to determine the version of an app (usually because it was not tracked), it can be accomplished by specifying the "?" in the version value. For example, to determine the HumiditySensor app (with a known package familiy name `HumiditySensor_76590kat`) is present, the desired propety looks like this:

```
"desired" : {
    "microsoft" : {
        "management" : {
            "apps" : { 
                "HumiditySensor_76590kat" : {
                    "version" : "?"
                },
                ...
            }
        }
    }
}
```

The state of the HumiditySensor app is then reported like this:

```
"reported" : {
    "microsoft" : {
        "management" : {
            "apps" : { 
                "HumiditySensor_76590kat" : {
                    "version" : "5.1.0",
                    "installedDate" : "2016-04-21T05:00:00+00:00"
                },
                ...
            }
        }
    }
}
```
