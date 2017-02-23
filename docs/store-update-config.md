# Store Update Configuration

## Desired Property

The AppStore update frequency can be configured by `"desired.microsoft.management.appStoreUpdateCheck"` desired property.

## Format
The format of the `"desired.microsoft.management.AppStoreUpdateCheck"` desired property is as follows:

<pre>
"desired" : {
    "microsoft" : {
        "management" : {
            "appStoreUpdateCheck" : <i>See below</i>
        }
    }
}
</pre>

The possible values of the `"appStoreUpdateCheck"` key are as follows:

- For updates performed by the default Windows Store client:

  ```
  "default"
  ```
  
- To disable the default Windows Store client:

  ```
  "disabled"
  ```

- For a one-time update check:
 
 <pre>
 {
     "one-time" : "<i>Datetime in ISO 8601 format, UTC</i>"
 }
 </pre>

- For a daily check:

 <pre>
 {
     "daily" : "<i>Local time in <b>hh::mm</b> format</i>"
 }
 </pre>

**Examples**

Perform a one-time update check on Jan 25th, 2017 at 09:00 UTC time

```
"desired" : {
    "microsoft" : {
        "management" : {
            "appStoreUpdateCheck" : {
                "one-time" : "2017-01-25T09:00:00+00:00"
            }
        }
    }
}
```
Start performing daily update checks at 3 AM:

```
"desired" : {
    "microsoft" : {
        "management" : {
            "appStoreUpdateCheck" : {
                "daily" : "03:00"
            }
        }
    }
}
```

## Reported Properties

The DM client reports the last time when the update check was performed in the `"reported.microsoft.management.lastAppStoreUpdateCheck"`
property with fields `time` and `updates-found`:

<pre>
"reported" : {
    "microsoft" : {
        "management" : {
            "lastAppStoreUpdateCheck" : {
                "time" : "<i>Datetime in ISO 8601 format, UTC</i>",
                "updates-found" : <i>Number of updates found, 0 meaning none</i>
            }
        }
    }
}
</pre>

For example, if the update check for performed at 2 AM UTC and updates for 2 apps were found, the property will look as follows:

<pre>
"reported" : {
    "microsoft" : {
        "management" : {
            "lastAppStoreUpdateCheck" : {
                "time" : "2017-02-25T02:00:00+00:00",
                "updates-found" : 2
            }
        }
    }
}
</pre>
