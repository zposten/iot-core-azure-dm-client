# App Management Using Device Twin

Goals...

DT structure...

## Reported Properties

## Desired Properties

Example:

```
"reported" : {
    "microsoft" : {
        "management" : {
            "apps" : [ 
                {
                    "package-family-name" : "ToasterUi_9nthh9tntkkay",
                    "version" : "1.0.0",
                    "installed-date" : "2017-01-25T09:00:00+00:00"
                },
                {
                    "package-family-name" : "Sprinkler_798lklk0",
                    "version" : "1.0.0",
                    "installed-date" : "2017-02-20T04:00:00+00:00"
                }                
            ]
        }
    }
}
```

only side-loaded apps

the update check happens according to [tbd]


```
"desired" : {
    "microsoft" : {
        "management" : {
            "app" : {
                "primary-app-version" : "1.2.3",
                "update-method" : {
                    "daily" : "02:00"
                }
            }
        }
    }
}
```
